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

library SpecialPopulationsActions version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include DataElements version '1.0.0' called DataElements
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

codesystem "ActCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system'
codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'
codesystem "LOINC": 'http://loinc.org'

// Act Codes
code "Perform lifetime risk assessment": 'lifetimeriskassessment' from "ActCode" display 'Perform lifetime risk assessment'
// Reason Codes
code "High lifetime risk": 'highlifetimerisk' from "LOCAL" display 'High lifetime risk'
code "First degree relative with genetic marker or syndrome": 'firstdeggenetic' from "LOCAL" display 'First degree relative with genetic marker or syndrome'
code "BI-RADS breast density category C or D": 'breastdensitycord' from "LOCAL" display 'BI-RADS breast density category C or D'
code "Compelling family history of breast cancer": 'fhxbreastcarisk' from "LOCAL" display 'Compelling family history of breast cancer'
code "USPSTF average risk": 'USPSTFaveragerisk' from "LOCAL" display 'USPSTF average risk'

// Standard codes
code "MG Breast Screening": '24606-6' from "LOINC" display 'MG Breast Screening' 
code "MR Breast": '30794-2' from "LOINC" display 'MR Breast' 

context Patient

define mammo_annual:
  {
		code: "MG Breast Screening",
    timingTiming: {
      event: {},
      repeat: {
        frequency: 1,
        period: 1.0,
        periodUnit: 'a'
      }
    }
	} 

define mammo_biennial:
  {
		code: "MG Breast Screening",
    timingTiming: {
      event: {},
      repeat: {
        frequency: 1,
        period: 2.0,
        periodUnit: 'a'
      }
    }
	}   

define mri_annual:
  {
		code: "MR Breast",
    timingTiming: {
      event: {},
      repeat: {
        frequency: 1,
        period: 1.0,
        periodUnit: 'a'
      }
    }
	}

define "act-acshighriskmammo":  
  BCSMCommon.SetRecommendation(mammo_annual.code, "High lifetime risk", 
    BCSMCommon.SourceDocumentationACS, 
    {value: 30.0, code: 'a'}, null, mammo_annual.timingTiming.repeat)     

define "act-acshighriskmri":  
  BCSMCommon.SetRecommendation(mri_annual.code, "High lifetime risk", 
    BCSMCommon.SourceDocumentationACS, 
    {value: 30.0, code: 'a'}, null, mri_annual.timingTiming.repeat)

define "act-firstdeggeneticmammo":    
  BCSMCommon.SetRecommendation(mammo_annual.code, "First degree relative with genetic marker or syndrome", 
    BCSMCommon.SourceDocumentationACS, 
    {value: 30.0, code: 'a'}, null, mammo_annual.timingTiming.repeat)

define "act-firstdeggeneticmri":  
  BCSMCommon.SetRecommendation(mri_annual.code, "First degree relative with genetic marker or syndrome", 
    BCSMCommon.SourceDocumentationACS, 
    {value: 30.0, code: 'a'}, null, mri_annual.timingTiming.repeat)

define "act-breastdensitycord":
  {
		code: "Perform lifetime risk assessment",
    reason: "BI-RADS breast density category C or D",
    documentation: BCSMCommon.SourceDocumentationACS
	}  

define "act-fhxbreastcarisk":
  {
		code: "Perform lifetime risk assessment",
    reason: "Compelling family history of breast cancer",
    documentation: BCSMCommon.SourceDocumentationACS
	}   

define "act-uspstfrecs":
  BCSMCommon.SetRecommendation(mammo_biennial.code, "USPSTF average risk", 
    BCSMCommon.SourceDocumentationUSPSTF, {value: 40.0, code: 'a'}, null, mammo_biennial.timingTiming.repeat) 