library ScreeningDueEvents version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements
include CSMCommonFunctions version '1.0.0' called CSMCommonFunctions
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED": 'http://snomed.info/sct'

// Standard codes
code "Breast cancer screening": '268547008' from "SNOMED" display 'Breast cancer screening'
code "MG Breast Screening": '24606-6' from "LOINC" display 'MG Breast Screening' 
code "MR Breast": '30794-2' from "LOINC" display 'MR Breast' 

valueset "SCREENING MAMMOGRAM": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1206.61'

context Patient

//calculated nextdue logic:
//  +duedate, -interval, -lastreport or +lastreport < duedate = use duedate
//  +duedate, +interval, -lastreport or +lastreport < duedate = use duedate
//  +duedate, -interval, +lastreport > duedate = no prediction
//  +duedate, +interval, +lastreport > duedate = use lastreport + interval
//  -duedate = use CalculateNextDueByCodeAndInterval
// mammogram only and in age range:
//  +duedate, -interval, +lastreport > duedate = use lastreport + 24mos
//  -duedate, -interval, +lastreport = use lastreport + 24mos
//  no activity = use today
//return{
//  code: action.code
//  nextdue: calculated date
//  planneddue: action.timingTiming.event
//  plannedstart: action.timingTiming.repeat.boundsPeriod.start
//  plannedrepeat: action.timingTiming.repeat
//  lastReportDate: DiagnosticReport date
//  flag: "NOT DUE", "DUE", "OVERDUE", none
//}

define "eve-nextdueexists":
  ActivityPlannedDate(MammogramPlannedActivity.timing) is not null

define "eve-noscreening27mo":
  AgeInYears() >= 40 and AgeInYears() <=74 and 
  (LastMammography is null or Today() > (FHIRHelpers.ToDateTime(LastMammography.effective) as DateTime) + 27 months)

define "eve-due":
  CarePlanActivitiesDue A where A.flag in {BCSMCommon."DUE", BCSMCommon."OVERDUE"}

define CarePlanActivitiesDue:
  ScreeningActivities A
  let lastReport: BCSMCommon.MostRecentDiagnosticReportByCode(A.code),
  lastReportDate: CSMCommonFunctions.DiagnosticReportDate(lastReport),
  nextdue: CalculateActivityNextDue(A)
  return {
    code: A.code,
    intent: 'plan',
    nextDue: nextdue,
    plannedDue: A.plannedDue,
    plannedStart: A.plannedStart,
    plannedRepeat: BCSMCommon.EvaluateInterval((A.timing as FHIR.Timing).repeat),
    lastReportDate: lastReportDate,
    flag: BCSMCommon.EvaluateFlag((A.timing as FHIR.Timing).repeat, nextdue)
  }   

define ScreeningActivities:
  ScreeningRequestGroupActions union ScreeningServiceRequests

define LastMammography:
  BCSMCommon.MostRecentDiagnosticReportByVS("SCREENING MAMMOGRAM")


//------------------------------------------------------------------------------
// calculated next due
//------------------------------------------------------------------------------

define function CalculateActivityNextDue(
  activity Tuple{code FHIR.CodeableConcept,plannedDue System.DateTime,plannedStart System.DateTime,timing FHIR.Timing}
):
  activity A
  let lastReport: BCSMCommon.MostRecentDiagnosticReportByCode(A.code),
  lastReportDate: FHIRHelpers.ToDateTime(lastReport.effective) as DateTime,
  duedate: A.plannedDue,
  repeat: Tuple{frequency: FHIRHelpers.ToInteger((A.timing as Timing).repeat.frequency),
        period: FHIRHelpers.ToDecimal((A.timing as Timing).repeat.period),
        periodUnit: FHIRHelpers.ToString((A.timing as Timing).repeat.periodUnit)}
  return
    case
      // -duedate = use CalculateNextDueByCodeAndInterval
      when duedate is null then 
        BCSMCommon.CalculateNextDueByCodeAndInterval(
          A.code, 
          FHIRHelpers.ToDateTime(((A.timing as Timing).repeat.bounds as Period).start),
          repeat)
      // +duedate, -repeat, -lastreport or +lastreport < duedate = use duedate
      when BCSMCommon.RepeatIsValid(repeat) is false and (lastReport is null or lastReportDate < duedate) then duedate
      // +duedate, +repeat, -lastreport or +lastreport < duedate = use duedate
      when BCSMCommon.RepeatIsValid(repeat) and (lastReport is null or lastReportDate < duedate) then duedate
      // +duedate, -repeat, +lastreport > duedate = no prediction
      when BCSMCommon.RepeatIsValid(repeat) is false and lastReport is not null and lastReportDate > duedate then null
      // +duedate, +repeat, +lastreport > duedate = use lastreport + repeat
      when BCSMCommon.RepeatIsValid(repeat) and lastReport is not null and lastReportDate > duedate then
        date from BCSMCommon.AddIntervalToDateTime(lastReportDate, repeat)
      // Default case if none of the above conditions are met      
      else null
    end         

//------------------------------------------------------------------------------
// Care plan
//------------------------------------------------------------------------------

define MostRecentActiveScreeningCarePlan:
  Last(ActiveBreastCancerScreeningCarePlans C 
    sort by Coalesce(start of period, created)
  )      

define ActiveBreastCancerScreeningCarePlans:
  [CarePlan] C
    where C.status in {'active'}
      and exists C.category cat where cat ~ "Breast cancer screening"   

//------------------------------------------------------------------------------
// Care plan/Request group
//------------------------------------------------------------------------------

define ScreeningRequestGroupActions:
  MostRecentActiveScreeningCarePlanRequestGroup.action A
  return {
    code: First(A.code),
    plannedDue: ActivityPlannedDate(A.timing),
    plannedStart: FHIRHelpers.ToDateTime(((A.timing as Timing).repeat.bounds as Period).start),
    timing: A.timing as FHIR.Timing
  } 

define MostRecentActiveScreeningCarePlanRequestGroup:
  if MostRecentActiveScreeningCarePlan.activity[0].reference.reference is not null
    and StartsWith(MostRecentActiveScreeningCarePlan.activity[0].reference.reference,'RequestGroup/')
  then
    First(
      [RequestGroup] R where 
        R.id = Last(Split(MostRecentActiveScreeningCarePlan.activity[0].reference.reference,'/'))
    )
  else null       

//------------------------------------------------------------------------------
// Care plan/Service requests
//------------------------------------------------------------------------------

define ScreeningServiceRequests:
  MostRecentActiveScreeningCarePlanServiceRequests R
  return {
    code: R.code,
    plannedDue: Coalesce(
      ActivityPlannedDate(R.occurrence as Timing),
      (R.occurrence as FHIR.dateTime).value,
      (R.occurrence as FHIR.Period)."end".value,
      (R.occurrence as FHIR.Period)."start".value
    ),
    plannedStart: FHIRHelpers.ToDateTime(((R.occurrence as FHIR.Timing).repeat.bounds as Period).start),
    timing: R.occurrence as FHIR.Timing
  }

define MostRecentActiveScreeningCarePlanServiceRequests:
  MostRecentActiveScreeningCarePlan.activity A
  where
    A.reference.reference is not null and StartsWith(A.reference.reference,'ServiceRequest/')
  return singleton from (
    [ServiceRequest] R 
    where R.id = Last(Split(A.reference.reference,'/'))
      and R.intent = 'plan' //from CPG workflow        
  )

//------------------------------------------------------------------------------
// Activity
//------------------------------------------------------------------------------

define MammogramPlannedActivity:
  NextPlannedActivityByCode(ScreeningActivities, "MG Breast Screening")    

define function NextPlannedActivityByCode(
  activities List<Tuple{code FHIR.CodeableConcept,plannedDue System.DateTime,plannedStart System.DateTime,timing FHIR.Timing}>,
  code Code
):
  NextPlannedActivity(activities A where A.code ~ ToConcept(code))

define function NextPlannedActivity(
  activities List<Tuple{code FHIR.CodeableConcept,plannedDue System.DateTime,plannedStart System.DateTime,timing FHIR.Timing}>
):
  Last(activities A sort by ActivityPlannedDate(timing))

//------------------------------------------------------------------------------
// planned due date
//------------------------------------------------------------------------------

define function ActivityPlannedDate(timing Choice<FHIR.Timing,FHIR.Period>):
  Coalesce(
    MostRecentTimingEvent(timing as FHIR.Timing),
    (timing as FHIR.Period)."start".value,
    (timing as FHIR.Period)."end".value
  )

define function MostRecentTimingEvent(timing FHIR.Timing):
  Last(timing.event E sort asc).value 

