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

library GeneticRiskReferral version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include GeneticRiskReferralEvents version '1.0.0' called Events
include GeneticRiskReferralActions version '1.0.0' called Actions
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
  false

//------------------------------------------------------------------------------
// RECOMMENDATIONS
//------------------------------------------------------------------------------

define "flow-GeneticRiskReferral":
  {
    GeneticRiskReferral, 
    GeneticRiskAssessment
  }
  except { null, {} }

define GeneticRiskReferral:
  Coalesce(
    GeneticReferralVariant,
    GeneticReferralAncestry,
    GeneticReferralRisk
  )

define GeneticReferralVariant:
  if Events."eve-fhxgeneinherited" is true and Events."eve-knownvariantstatus" is false
  then Actions."act-geneticreferralvariant" else null  

define GeneticReferralAncestry:
  if Events."eve-brcageneancestry" is true
  then Actions."act-geneticreferralancestry" else null    

define GeneticRiskAssessment:
  if GeneticRiskReferral is null and Events."eve-fhxbrcaovcatubalperit" is true 
    and Events.ValidMostRecentFamilialRiskAssessment is false
  then {Actions."act-fhxrisktool", Actions."act-fhxriskassess"} else null   

define GeneticReferralRisk:
  if Events."eve-fhxriskresult" is true
    and Events.ValidMostRecentFamilialRiskAssessment
  then Actions."act-geneticreferralrisk" else null

//------------------------------------------------------------------------------
// DYNAMIC VALUES
//------------------------------------------------------------------------------    

define ExistsGeneticReferralVariant:
  GeneticReferralVariant is not null

define ExistsGeneticReferralAncestry:
  GeneticReferralAncestry is not null    

define ExistsGeneticReferralRisk:
  GeneticReferralRisk is not null  

define GeneticRiskReferralCode:
  GeneticRiskReferral.code

define GeneticRiskReferralReason:
  GeneticRiskReferral.reason    

define ExistsGeneticRiskAssessment:
  GeneticRiskAssessment is not null  

define GeneticRiskAssessmentToolCode:
  (Actions."act-fhxrisktool").code  

define GeneticRiskAssessmentToolReason:
  (Actions."act-fhxrisktool").reason     

define GeneticRiskAssessmentCode:
  (Actions."act-fhxriskassess").code  

define GeneticRiskAssessmentReason:
  (Actions."act-fhxriskassess").reason    