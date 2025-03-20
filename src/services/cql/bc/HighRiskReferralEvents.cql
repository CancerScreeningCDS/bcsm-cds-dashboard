/*  
  Author: CMS Alliance to Modernize Healthcare, operated by THE MITRE Corporation.

  (C) 2024 The MITRE Corporation. All Rights Reserved. 
  Approved for Public Release: 24-2711. 
  Distribution Unlimited.

  Unless otherwise noted, this work is available under an Apache 2.0 license. 
  It was produced by the MITRE Corporation for the Division of Cancer Prevention 
  and Control, Centers for Disease Control and Prevention in accordance with the 
  Statement of Work, contract number 75FCMC18D0047, task order number 75D30123F17931.
*/

library HighRiskReferralEvents version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements
include CDSConnectCommonsforFHIRv401 version '1.0.0' called C3F
include BCSMCommonFunctions version '1.0.0' called BCSMCommon
include CSMCommonFunctions version '1.0.0' called Common

codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'
codesystem "ActCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system'

code "High 5 year risk": 'high5yrisk' from "LOCAL" display 'High 5 year risk'
code "5 year risk at least 1.67%": 'higherthanaverage5yrisk' from "LOCAL" display '5 year risk at least 1.67%'

context Patient

define "eve-ageAny":
  true

define "eve-ageAtLeast35":
  AgeInYears() >= 35

define "eve-geneticriskpop":
  DataElements."de-geneticrisk"

define "eve-chestxrtpop":
  DataElements."de-chestxrtage10to30"

define "eve-atypicalbxpop":
  DataElements."de-atypicalbx"

define "eve-LifeExp":
  DataElements."de-lifeexp"  

define "eve-fiveyrriskpop":
  MostRecent5YrRiskAssessmentResultHigh is not null

define "eve-fiveyrrisklowpop":
  MostRecent5YrRiskAssessmentResultHigherThanAverage is not null

define "eve-fhxbrca":  
  DataElements."de-fhxbreastcarisk" or DataElements."de-fhxrisk"

define "eve-personalriskfactors":
  if DataElements.MostRecentPersonalRiskFactorAssessment is not null
    then FHIRHelpers.ToBoolean(DataElements.MostRecentPersonalRiskFactorAssessment.value as boolean) 
  else Count(DataElements."BiopsyDiagnosticReports") > 1 or
    DataElements."de-breastdensitycord"

define MostRecent5YrRiskAssessmentResultHigh:
  DataElements.MostRecent5YrRiskAssessment R where 
    R.value as FHIR.Quantity is not null and C3F.QuantityValue(R).value >=3 or
    R.value as FHIR.CodeableConcept is not null and C3F.ConceptValue(R) ~ "High 5 year risk"

define MostRecent5YrRiskAssessmentResultHigherThanAverage:
  DataElements.MostRecent5YrRiskAssessment R where 
    R.value as FHIR.Quantity is not null and C3F.QuantityValue(R).value >=1.67 and C3F.QuantityValue(R).value <3 
    or R.value as FHIR.CodeableConcept is not null and C3F.ConceptValue(R) ~ "5 year risk at least 1.67%"

// 5 year assessment is valid if done within past 5 years
// and risk factor observation not changed from false to true after risk assessment
define ValidMostRecent5YrRiskAssessment:
  DataElements."MostRecent5YrRiskAssessment" is not null
    and DataElements."MostRecent5YrRiskAssessmentDate" >= (Today() - 5 years)
    and RiskFactorModifiedAfterRiskAssessment is false

define RiskFactorModifiedAfterRiskAssessment:
  if "eve-fhxbrca" and LastFamilialRiskAssessmentObservationResult is false
      and Common.ObservationDate(DataElements.MostRecentFamilialRiskAssessmentObservation) is not null
      and Common.ObservationDate(DataElements.MostRecentFamilialRiskAssessmentObservation) 
        > DataElements."MostRecent5YrRiskAssessmentDate"
    then true
  else if "eve-personalriskfactors" and LastPersonalRiskFactorObservationResult is false
      and Common.ObservationDate(DataElements.MostRecentPersonalRiskFactorAssessment) is not null
      and Common.ObservationDate(DataElements.MostRecentPersonalRiskFactorAssessment) 
        > DataElements."MostRecent5YrRiskAssessmentDate"  
    then true
  else false  

define LastFamilialRiskAssessmentObservationResult:
  BCSMCommon.SortedObservations(
    DataElements.FamilialRiskAssessmentObservations
  )[1].value

define LastPersonalRiskFactorObservationResult:
  BCSMCommon.SortedObservations(
    DataElements.PersonalRiskFactorAssessments
  )[1].value  
