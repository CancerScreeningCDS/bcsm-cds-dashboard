library HighRiskReferral version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include HighRiskReferralEvents version '1.0.0' called Events
include HighRiskReferralActions version '1.0.0' called Actions
include DataElements version '1.0.0' called DataElements

codesystem "LOINC": 'http://loinc.org'

// Standard codes
code "Age": '30525-0' from "LOINC" display 'Age'

context Patient

//------------------------------------------------------------------------------
// INCLUSIONS/EXCLUSIONS
//------------------------------------------------------------------------------

define CheckIsIncludedAndNotExcluded:
  Message(IsIncludedAndNotExcluded, IsIncludedAndNotExcluded is false,
    'http://example.org/CodeSystem/plan-definition-action-reason-code-system/excludedornotincluded',
    'Error', 
    'Excluded or not included')

define IsIncludedAndNotExcluded:
  IsIncluded and not Excluded

// INCLUSIONS
define IsIncluded:
  "inc-AgeAtLeast18" and "inc-assignedfemaleatbirthortransfemale"

// Age 18 years and older, only use MostRecentAgeValue if no birthdate  
define "inc-AgeAtLeast18":
  (AgeInYears() is not null and AgeInYears() >= 18) or (AgeInYears() is null and MostRecentAgeValue >= 18)

define MostRecentAgeValue:
  First(
    [Observation: "Age"] O
      where O.value.unit = 'years'
      sort by effective desc
  ).value.value.value

define "inc-assignedfemaleatbirthortransfemale":
  DataElements."de-female" or DataElements."TransgenderFemale"

// EXCLUSIONS
define Excluded:
  "exc-hxbrca"

define "exc-hxbrca": //Previous diagnosis of breast cancer
  DataElements."de-breastca" or exists DataElements."de-hxbreastca"

//------------------------------------------------------------------------------
// RECOMMENDATIONS
//------------------------------------------------------------------------------

define "flow-HighRiskReferral":
  {
    HighRiskReferral,
    ConsiderLifeExpectancy,
    HighRiskAssessment
  }
  except { null, {} }

define ConsiderLifeExpectancy:
  if HighRiskReferral is not null and Events."eve-LifeExp" is true
  then Actions."act-estlifexpectancy" else null

define HighRiskReferral: 
  Coalesce(
    HighRiskReferralGenetic,
    HighRiskReferralChestXRT,
    HighRiskReferralAtypicalBiopsy,
    HighRiskReferral5YRiskHigh,
    HighRiskReferral5YRiskHigherThanAverage
  )

define HighRiskReferralGenetic:  
  if Events."eve-ageAny" and Events."eve-geneticriskpop"    
  then Actions."act-HighRiskReferralGenetic" else null

define HighRiskReferralChestXRT:  
  if Events."eve-ageAny" and Events."eve-chestxrtpop"
  then Actions."act-HighRiskReferralChestXRT" else null

define HighRiskReferralAtypicalBiopsy:  
  if Events."eve-ageAny" and "eve-atypicalbxpop"
  then Actions."act-HighRiskReferralAtypicalBiopsy" else null

define HighRiskReferral5YRiskHigh:
  if Events."eve-ageAtLeast35" and Events."eve-fiveyrriskpop"
    and Events.ValidMostRecent5YrRiskAssessment    
  then Actions."act-HighRiskReferral" else null

define HighRiskReferral5YRiskHigherThanAverage:
  if Events."eve-ageAtLeast35" and Events."eve-fiveyrrisklowpop"   
    and Events.ValidMostRecent5YrRiskAssessment     
  then Actions."act-ConsiderHighRiskReferral" else null

define HighRiskAssessment:
  if HighRiskReferral is null and 
    Events."eve-ageAtLeast35" 
    and (Events."eve-fhxbrca" or Events."eve-personalriskfactors")
    and Events.ValidMostRecent5YrRiskAssessment is false
  then {Actions."act-5YRiskAssessment",Actions."act-5YRiskAssessmentTool"} else null   

//------------------------------------------------------------------------------
// ERRORS
//------------------------------------------------------------------------------     

define "eve-atypicalbxpop":  
  Message(Events."eve-atypicalbxpop", 
    DataElements.BiopsyDiagnosticReportsWithNoConclusionCodes,
    'http://example.org/CodeSystem/plan-definition-action-reason-code-system/missingresultcode',
    'Warning', 
    'A laboratory test was found without a result. Please review patient record to resolve.')    

//------------------------------------------------------------------------------
// DYNAMIC VALUES
//------------------------------------------------------------------------------  

define ExistsHighRiskReferralGenetic:
  HighRiskReferralGenetic is not null

define ExistsHighRiskReferralChestXRT:
  HighRiskReferralChestXRT is not null    

define ExistsHighRiskReferralAtypicalBiopsy:
  HighRiskReferralAtypicalBiopsy is not null  

define ExistsHighRiskReferral5YRiskHigh:
  HighRiskReferral5YRiskHigh is not null 

define ExistsHighRiskReferral5YRiskHigherThanAverage:
  HighRiskReferral5YRiskHigherThanAverage is not null     

define HighRiskReferralCode:
  HighRiskReferral.code

define HighRiskReferralReason:
  HighRiskReferral.reason 

define ExistsConsiderLifeExpectancy:
  ConsiderLifeExpectancy is not null  

define ConsiderLifeExpectancyCode:
  ConsiderLifeExpectancy.code  

define ConsiderLifeExpectancyReason:
  ConsiderLifeExpectancy.reason    

define ExistsHighRiskAssessment:
  HighRiskAssessment is not null  

define HighRiskAssessmentToolCode:
  (Actions."act-5YRiskAssessmentTool").code  

define HighRiskAssessmentToolReason:
  (Actions."act-5YRiskAssessmentTool").reason     

define HighRiskAssessmentCode:
  (Actions."act-5YRiskAssessment").code  

define HighRiskAssessmentReason:
  (Actions."act-5YRiskAssessment").reason    