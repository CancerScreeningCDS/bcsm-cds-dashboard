library GeneticRiskReferralEvents version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements
include BCSMCommonFunctions version '1.0.0' called BCSMCommon
include CSMCommonFunctions version '1.0.0' called Common

codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'
codesystem "ActCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system'

code "Family history of inherited cancer susceptibility": 'fhxgenetic' from "LOCAL" display 'Family history of inherited cancer susceptibility'
code "Ancestry associated with BRCA1/2 gene mutations": 'brcageneancestry' from "LOCAL" display 'Ancestry associated with BRCA1/2 gene mutations'
code "Familial risk assessment": 'familialriskassessment' from "ActCode" display 'Familial risk assessment'
code "High genetic risk": 'highgeneticrisk' from "LOCAL" display 'High genetic risk'

context Patient

define "eve-fhxgeneinherited":
  DataElements."de-fhxgeneinherited"

define "eve-knownvariantstatus":
  DataElements."de-knownvariantstatus"

define "eve-fhxbrcaovcatubalperit":
  if DataElements.FamilyHistoryBreastOvarianTubalPeritonealCancerObservation is not null
    then FHIRHelpers.ToBoolean(DataElements.FamilyHistoryBreastOvarianTubalPeritonealCancerObservation.value as boolean) 
  else exists DataElements.FamilyMemberBreastOvarianTubalPeritonealCancer

define "eve-brcageneancestry":
  if DataElements.MostRecentBRCAGeneAncestryObservation is not null
    then FHIRHelpers.ToBoolean(DataElements.MostRecentBRCAGeneAncestryObservation.value as boolean) 
  else false

define "eve-fhxriskresult":
  DataElements."de-fhxbreastcarisk"

// Familial risk assessment is valid if exists
// and risk factor observation not changed from false to true  after risk assessment
define ValidMostRecentFamilialRiskAssessment:
  DataElements.FamilialRiskAssessmentExists
    and RiskFactorModifiedAfterRiskAssessment is false

define RiskFactorModifiedAfterRiskAssessment:
  if "eve-fhxbrcaovcatubalperit" and LastFhxBreastOvarianTubalPeritonealCancerObservationResult is false
    and Common.ObservationDate(DataElements.FamilyHistoryBreastOvarianTubalPeritonealCancerObservation) is not null
    and Common.ObservationDate(DataElements.FamilyHistoryBreastOvarianTubalPeritonealCancerObservation) 
      > Common.ObservationDate(DataElements."MostRecentFamilialRiskAssessmentObservation")
    then true
  else false  

define LastFhxBreastOvarianTubalPeritonealCancerObservationResult:
  BCSMCommon.SortedObservations(
    DataElements.FamilyHistoryBreastOvarianTubalPeritonealCancerObservations
  )[1].value 



