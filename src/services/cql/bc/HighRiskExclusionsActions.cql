library HighRiskExclusionsActions version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

codesystem "ActCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system'
codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'
codesystem "LOINC": 'http://loinc.org'

// Act Codes
code "Refer to specialist recommendations": 'specialtyreferral' from "ActCode" display 'Refer to specialist recommendations'
code "Perform lifetime risk assessment": 'lifetimeriskassessment' from "ActCode" display 'Perform lifetime risk assessment'
// Reason Codes
code "Other genetic marker or syndrome associated with breast cancer": 'othergeneticrisk' from "LOCAL" display 'Other genetic marker or syndrome associated with breast cancer'
code "Genetic risk exclusion": 'geneticriskexclusion' from "LOCAL" display 'Genetic risk exclusion'
code "History of chest radiation ages 10-30 y": 'chestxrt' from "LOCAL" display 'History of chest radiation ages 10-30 y'
code "Previous breast cancer": 'hxbreastca' from "LOCAL" display 'Previous breast cancer'
code "Breast cancer in remission < 5 years": 'hxbreastcawithin5y' from "LOCAL" display 'Breast cancer in remission < 5 years'
code "Atypical biopsy": 'atypicalbx' from "LOCAL" display 'Atypical biopsy'
code "Atypical biopsy high lifetime risk": 'atypicalbxhighlifetimerisk' from "LOCAL" display 'Atypical biopsy high lifetime risk'

// Standard codes
code "MG Breast Screening": '24606-6' from "LOINC" display 'MG Breast Screening' 
code "MR Breast": '30794-2' from "LOINC" display 'MR Breast' 

context Patient

define "act-othergeneticrisk":
  {
		code: "Refer to specialist recommendations",
    reason: "Other genetic marker or syndrome associated with breast cancer",
    documentation: BCSMCommon.SourceDocumentationACS
	}  

define "act-acshighriskmammo":
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

define "act-acshighriskmri":
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

define "act-acsgeneticriskmammo":
  BCSMCommon.SetRecommendation("act-acshighriskmammo".code, "Genetic risk exclusion", 
    BCSMCommon.SourceDocumentationACS, 
    {value: 30.0, code: 'a'}, null, "act-acshighriskmammo".timingTiming.repeat)    

define "act-acsgeneticriskmri":
  BCSMCommon.SetRecommendation("act-acshighriskmri".code, "Genetic risk exclusion", 
    BCSMCommon.SourceDocumentationACS, 
    {value: 30.0, code: 'a'}, null, "act-acshighriskmri".timingTiming.repeat)    

define "act-acsmammoafterRT":
  BCSMCommon.SetRecommendation("act-acshighriskmammo".code, "History of chest radiation ages 10-30 y", 
    BCSMCommon.SourceDocumentationACS, 
    Ageatleast25and8yafterRT, null, "act-acshighriskmammo".timingTiming.repeat) 

define "act-acsmriafterRT":
  BCSMCommon.SetRecommendation("act-acshighriskmri".code, "History of chest radiation ages 10-30 y", 
    BCSMCommon.SourceDocumentationACS, 
    Ageatleast25and8yafterRT, null, "act-acshighriskmri".timingTiming.repeat) 

define "act-acsmammoafterbrca":
  BCSMCommon.SetRecommendation("act-acshighriskmammo".code, "Previous breast cancer", 
    BCSMCommon.SourceDocumentationACS, 
    {value: AgeInYears() * 1.0, code: 'a'}, null, "act-acshighriskmammo".timingTiming.repeat) 

define "act-hxbreastcawithin5y":
  {
		code: "Refer to specialist recommendations",
    reason: "Breast cancer in remission < 5 years",
    documentation: BCSMCommon.SourceDocumentationOther
	}

define "act-acsmammoatypicalbx":
  BCSMCommon.SetRecommendation("act-acshighriskmammo".code, "Atypical biopsy", 
    BCSMCommon.SourceDocumentationACS, 
    {value: AgeInYears() * 1.0, code: 'a'}, null, "act-acshighriskmammo".timingTiming.repeat)

define "act-acsatypicalbx":
  {
		code: "Perform lifetime risk assessment",
    reason: "Atypical biopsy",
    documentation: BCSMCommon.SourceDocumentationACS
	}      

define "act-acsmriatypicalbx":  
  BCSMCommon.SetRecommendation("act-acshighriskmri".code, "Atypical biopsy high lifetime risk", 
    BCSMCommon.SourceDocumentationACS, 
    {value: AgeInYears() * 1.0, code: 'a'}, null, "act-acshighriskmri".timingTiming.repeat)   

define Ageatleast25and8yafterRT:
  if 25 years < Age8yafterRT 
    then {value: Age8yafterRT.value, code: 'a'}
  else
    {value: 25, code: 'a'} //default if no age provided

define Age8yafterRT:    
  "RadiationTherapyCompletionAge" + 8 years

define "RadiationTherapyCompletionAge":
  First(DataElements.HistoryOfChestRadiationAges10To30Condition C).abatement as Age
  // note these can't be sorted by abatement due to choice types