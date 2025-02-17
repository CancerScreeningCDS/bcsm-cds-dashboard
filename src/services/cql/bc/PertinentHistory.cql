library PertinentHistory version '1.0.0'

using FHIR version '4.0.1'

include CDSConnectCommonsforFHIRv401 version '1.0.0' called C3F
include CSMCommonFunctions version '1.0.0' called Common
include BCSMCommonFunctions version '1.0.0' called BCSMCommon
include FHIRHelpers version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements
include ScreeningDue version '1.0.0'
include ScreeningTestIncomplete version '1.0.0'

codesystem "SNOMED-CT": 'http://snomed.info/sct'

code "Category0": '397138000' from "SNOMED-CT" display 'Mammography assessment (Category 0) - Need additional imaging evaluation (finding)'
code "Category1": '397140005' from "SNOMED-CT" display 'Mammography assessment (Category 1) - Negative (finding)'
code "Category2": '397141009' from "SNOMED-CT" display 'Mammography assessment (Category 2) - Benign finding (finding)'
code "Category3": '397143007' from "SNOMED-CT" display 'Mammography assessment (Category 3) - Probably benign finding, short interval follow-up (finding)'
code "Category4": '397144001' from "SNOMED-CT" display 'Mammography assessment (Category 4) - Suspicious abnormality, biopsy should be considered (finding)'
code "Category4A": '6121000179106' from "SNOMED-CT" display 'Mammography assessment (Category 4A) - Suspicious abnormality, biopsy should be considered, low suspicion of malignancy (finding)'
code "Category4B": '6131000179108' from "SNOMED-CT" display 'Mammography assessment (Category 4B) - Suspicious abnormality, biopsy should be considered, moderate suspicion of malignancy (finding)'
code "Category4C": '6141000179100' from "SNOMED-CT" display 'Mammography assessment (Category 4C) - Suspicious abnormality, biopsy should be considered, high suspicion of malignancy (finding)'
code "Category5": '397145000' from "SNOMED-CT" display 'Mammography assessment (Category 5) - Highly suggestive of malignancy (finding)'
code "Category6": '6111000179101' from "SNOMED-CT" display 'Mammography assessment (Category 6) - known biopsy, proven malignancy (finding)'

//TODO: this should be a value set
concept BIRADS: {Category0, Category1, Category2, Category3, Category4, Category4A, Category4B, Category4C, Category5, Category6}

context Patient

define PertinentHistory:
{
  patientInfo: {
    name: PatientName,
    id: Patient.identifier,
    isPregnant: DataElements.Pregnant,
    dateOfBirth: Patient.birthDate,
    sexAtBirth: BirthSexText,
    age: AgeInYears(),
    gender: GenderText,
    primaryLanguage: LanguageText,
    race: RaceText + '; ' + EthnicityText
  },
  patientHistory: {
    conditions: PertinentConditionsSummary,
    familyMemberHistory: PertinentFamilyMemberHistorySummary,
    observations: PertinentObservationsSummary,
    procedures: PertinentProceduresSummary,
    diagnosticReports: PertinentDiagnosticReportsSummary,
    encounters: PertinentEncountersSummary,
    episodeOfCares: PertinentEpisodesOfCareSummary,
    requests: PertinentRequestsSummary
  }
}

//------------------------------------------------------------------------------
// PERTINENT DEMOGRAPHICS
//------------------------------------------------------------------------------

define PatientName:
  if Exists(UsualPatientName) then
    FormatPatientName(First(UsualPatientName))
  else if Exists(OfficialPatientName) then
    FormatPatientName(First(OfficialPatientName))
  else
    FormatPatientName(First(Patient.name))

define UsualPatientName:
  Patient.name N
    where N.use = 'usual'
    return N

define OfficialPatientName:
  Patient.name N
    where N.use = 'official'
    return N

define function FormatPatientName(name FHIR.HumanName):
  First(name.given) + ' ' + name.family

define BirthSexText:
  if DataElements.BirthSexCode = 'F' then 'Female'
  else if DataElements.BirthSexCode = 'M' then 'Male'
  else 'Unknown'  

define GenderText:
  if Exists(DataElements.GenderIdentityExtension) 
  then DataElements.GenderIdentityExtension[0].value.coding[0].code.value
  else Patient.gender.value  

define LanguageText:
  case
    when LanguageTextAbbreviated = 'en' then 'English'
    when LanguageTextAbbreviated = 'es' then 'Spanish'
    when LanguageTextAbbreviated = 'zh' then 'Chinese'
    when LanguageTextAbbreviated = 'fr' then 'French'
    when LanguageTextAbbreviated = 'tl' then 'Tagalog'
    when LanguageTextAbbreviated = 'vi' then 'Vietnamese'
    else 'Unknown'
  end  

define LanguageTextAbbreviated:
  Coalesce( {CommunicationLanguageCode, CommunicationLanguageText, LanguageCode} )

define CommunicationLanguageCode:
  Patient.communication.language.coding.code.value[0]

define CommunicationLanguageText:
  Patient.communication.language.text.value[0]

define LanguageCode:
  Patient.language.value

define RaceText:
  Coalesce(Coalesce(RaceExtensionValues))

define RaceExtensionValues:
  (Patient.extension) E 
    where E.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race'
    return (E.extension) X where X.url = 'text' return FHIRHelpers.ToString(X.value as FHIR.string)

define EthnicityText:
  Coalesce(Coalesce(EthnicityExtensionValues))

define EthnicityExtensionValues:
  (Patient.extension) E
    where E.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity'
    return (E.extension) X where X.url = 'text' return FHIRHelpers.ToString(X.value as FHIR.string)  

//------------------------------------------------------------------------------
// PERTINENT CONDITIONS
//------------------------------------------------------------------------------

define PertinentConditions:
  DataElements.BreastCancerDiagnoses union
  DataElements.BilateralMastectomyConditions union
  DataElements.LeftUnilateralMastectomyConditions union
  DataElements.RightUnilateralMastectomyConditions union
  DataElements.UnilateralMastectomyConditions union
  DataElements.BreastSymptomConditions union
  DataElements.PregnancyDiagnoses union
  DataElements."BRCA-1 Mutation Conditions" union
  DataElements."BRCA-2 Mutation Conditions" union
  DataElements."Li-Fraumeni Syndrome Conditions" union
  DataElements."Cowden Syndrome Conditions" union
  DataElements."Bannayan-Riley-Ruvalcaba Syndrome Conditions" union
	DataElements."de-chestxrt" union
	DataElements.AtypicalBiopsyConditions

define PertinentConditionsSummary:
  (PertinentConditions) C
  return {
    name: Common.ConceptText(C.code),
    value: C.clinicalStatus.coding[0].code.value,
    date: Common.DateTimeText(
      Coalesce(
        C.onset as FHIR.dateTime,
        C.recordedDate
      )
    ),
    reference: 'Condition/' + C.id,
    edited: HasBeenLocallyEdited(C)
  }
  sort by (date as String) desc

//------------------------------------------------------------------------------
// PERTINENT FAMILY MEMBER HISTORY
//------------------------------------------------------------------------------  

define PertinentFamilyMemberHistory:
  DataElements.FamilyMemberBreastOvarianTubalPeritonealCancerCondition union
  DataElements.FamilyMemberGeneticMarkerOrSyndromeConditions

define PertinentFamilyMemberHistorySummary:
  Flatten((PertinentFamilyMemberHistory) FMH
    return 
      FMH.conditions C return {
        name: Common.ConceptText(FMH.familyMemberHistory.relationship),
        value: Common.ConceptText(C.code),
        onset: Onset(C),
        reference: 'FamilyMemberHistory/' + FMH.familyMemberHistory.id,
        edited: HasBeenLocallyEdited(FMH.familyMemberHistory)
  })
  
//------------------------------------------------------------------------------
// PERTINENT OBSERVATIONS
//------------------------------------------------------------------------------

define PertinentObservations:
  ({DataElements.MostRecentLactatingObservation} union
  DataElements.PregnancyObservations union
  DataElements.NewOrWorseningBreastSymptomsObservations union
  DataElements.NewOrWorseningBreastFindingsObservations union
  {DataElements.MostRecentReducedLifeExpectancyObservation} union
  {DataElements.MostRecentGeneticMarkerOrSyndromeObservation} union
  {DataElements.HistoryOfChestRadiationAges10To30Observation} union
  {DataElements.MostRecentLifetimeRiskAssessment} union
  {DataElements.MostRecentFamilialRiskAssessmentObservation} union
  {DataElements.MostRecentFamilialRiskAssessmentResult} union
  {DataElements.FamilyGeneticHistoryAssessmentObservation} union
  {DataElements.KnownGeneticMarkerOrSyndromeStatusObservation} union
  {DataElements.MostRecentBRCAGeneAncestryObservation} union
  {DataElements.MostRecent5YrRiskAssessment} union
  {DataElements.MostRecentPersonalRiskFactorAssessment} union
  {DataElements.MostRecentFirstDegRelativeGeneticObservation})
  except {null}

define PertinentObservationsSummary:
  (PertinentObservations) Obs
  return {
    name: Common.ConceptText(Obs.code),
    value: Common.ConceptText(Obs.value),
    date: Common.ObservationDateString(Obs),
    reference: 'Observation/' + Obs.id,
    edited: HasBeenLocallyEdited(Obs)
  }
  sort by (date as String) desc

//------------------------------------------------------------------------------
// PERTINENT PROCEDURES
//------------------------------------------------------------------------------

define PertinentProcedures:
  DataElements.BilateralMastectomyProcedures union
  DataElements.LeftUnilateralMastectomyProcedures union
  DataElements.RightUnilateralMastectomyProcedures

define PertinentProceduresSummary:
  (PertinentProcedures) P
  return {
    name: Common.ConceptText(P.code),
    value: P.status.value,
    date: Common.ProcedureDateString(P),
    reference: 'Procedure/' + P.id,
    edited: HasBeenLocallyEdited(P)
  } sort by date desc  

//------------------------------------------------------------------------------
// PERTINENT DIAGNOSTIC REPORTS
//------------------------------------------------------------------------------

define PertinentDiagnosticReportsSummary:
  (
    BreastImagingDiagnosticReportsSummary
    union BiopsyDiagnosticReportsSummary
    union IncompleteBiopsyDiagnosticReportsSummary
  ) D
  sort by date desc

define BreastImagingDiagnosticReportsSummary:
  FormatReports(DataElements.BreastImagingDiagnosticReports, DataElements.BreastImagingObservations, 'Breast Imaging')

define BiopsyDiagnosticReportsSummary:
  FormatReports(DataElements.BiopsyDiagnosticReports, DataElements.BiopsyObservations, 'Breast Biopsy')  

define IncompleteBiopsyDiagnosticReportsSummary:
  FormatReports(ScreeningTestIncomplete.IncompleteScreeningPathology, DataElements.BiopsyObservations, 'Breast Biopsy')    

//------------------------------------------------------------------------------
// PERTINENT ENCOUNTERS
//------------------------------------------------------------------------------

define PertinentEncounters:
  DataElements.AllBreastSymptomEncounters union
  DataElements.GeneticCounselingEncounters

define PertinentEncountersSummary:
  (PertinentEncounters) E
  return {
    name: Common.ConceptText(E.reasonCode[0]),
    value: E.status,
    date: Common.DateTimeText((E.period as FHIR.Period)."start") +
      ' to ' +
      Common.DateTimeText((E.period as FHIR.Period)."end"),
    reference: 'Encounter/' + E.id
  }

//------------------------------------------------------------------------------
// PERTINENT EPISODES OF CARE
//------------------------------------------------------------------------------
  define PertinentEpisodesOfCare:
    DataElements.PregnancyEpisodesOfCare

define PertinentEpisodesOfCareSummary:
  (PertinentEpisodesOfCare) E
  return {
    name: Common.ConceptText(E.type[0]),
    value: E.status.value,
    date:
      displayStartDate(Common.PeriodObject(E.period)."Start") +
      ' to ' +
      displayEndDate(Common.PeriodObject(E.period)."End"),
    reference: 'EpisodeOfCare/' + E.id,
    edited: HasBeenLocallyEdited(E)
  }
  sort by (date as String) desc


//------------------------------------------------------------------------------
// PERTINENT REQUESTS
//------------------------------------------------------------------------------  

define DueOrOverdueScreeningSummary:
  (ScreeningDue.DueOrOverdue) R
    return
  {
    name: Common.ConceptText(R.code),
    intent: R.intent, 
    occurrence: R.nextDue,
    reference: null as String,
    flag: R.flag.display,
    plannedRepeat: R.plannedRepeat
  }  

define IncompleteScreeningOrdersSummary:
  (ScreeningTestIncomplete.IncompleteScreeningOrders) R
    return
  {
    name: Common.ConceptText(R.code),
    intent: FHIRHelpers.ToString(R.intent), 
    occurrence: FHIRHelpers.ToDateTime(R.occurrence as FHIR.dateTime),
    reference: 'ServiceRequest/' + R.id,
    flag: null as String,
    plannedRepeat: null as String
  } 

define GeneticCounselingReferralOrdersSummary:
  (DataElements.GeneticCounselingReferralOrders) R
    return
  {
    name: Common.ConceptText(R.code),
    intent: FHIRHelpers.ToString(R.intent), 
    occurrence: FHIRHelpers.ToDateTime(R.occurrence as FHIR.dateTime),
    reference: 'ServiceRequest/' + R.id,
    flag: null as String,
    plannedRepeat: null as String
  }  

define PertinentRequestsSummary:
  DueOrOverdueScreeningSummary union
  IncompleteScreeningOrdersSummary union
  GeneticCounselingReferralOrdersSummary

//------------------------------------------------------------------------------
// FUNCTIONS
//------------------------------------------------------------------------------

define function HasBeenLocallyEdited(R FHIR.DomainResource):
  R.extension ext
    where
      ext.url = 'http://cancerscreeningcds.github.io/bcsm-cds/StructureDefinition/bcsm-edited'
      and ext.value as FHIR.boolean = true

define function Onset(c FHIR.FamilyMemberHistory.Condition):
  Coalesce( List{
    Common.QuantityText(c.onset as FHIR.Age),
    Common.PeriodObject(c.onset as FHIR.Period),
    Common.RangeObject(c.onset as FHIR.Range),
    (c.onset as FHIR.string).value
  })      

define function FormatReports(DrList List<DiagnosticReport>, ObsList List<Observation>, ReportType String):
  (DrList) D
  let CollatedCodes: BCSMCommon.CollateConclusionCodes(D,ObsList),
  HighestRanked: HighestRankedResult(CollatedCodes)
  return {
    name: ReportType,
    longName: Common.ConceptText(D.code),
    value: HighestRanked.display,
    longValue: flatten(
      (CollatedCodes) cC
        return (cC.coding) cCC
          return cCC.display
    ),
    date: Common.DiagnosticReportDateString(D),
    reference: 'DiagnosticReport/' + D.id,
    edited: HasBeenLocallyEdited(D)
  }      

//return biopsy result annotation or BI-RADS result annotation if exists, otherwise return first coding
define function HighestRankedResult(CollatedCodes List<FHIR.CodeableConcept>):
  Coalesce(
    (CollatedCodes cC    
    return First(cC.coding C 
      where C.system = 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/biopsy-result-observation-code-system'
    )),
    (CollatedCodes cC    
    return First(cC.coding C 
      where FHIRHelpers.ToCode(C) ~ BIRADS
    )),
    CollatedCodes cC return First(cC.coding C)
  )
  
define function displayStartDate(startDate String):
  if startDate is not null then
    startDate
  else
    'no start date available'

define function displayEndDate(endDate String):
  if endDate is not null then
    endDate
  else
    'no end date available'
