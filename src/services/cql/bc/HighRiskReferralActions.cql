library HighRiskReferralActions version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

codesystem "ActCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system'
codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'
codesystem "BiopsyResultCS": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/biopsy-result-observation-code-system'

// Act Codes
code "5 year risk assessment tool": '5yrisktool' from "ActCode" display '5 year risk assessment tool'
code "Perform informal 5 year risk assessment": '5YRiskAssess' from "ActCode" display 'Perform informal 5 year risk assessment'
code "High risk referral": 'highriskreferral' from  "ActCode" display 'High risk referral'
code "Consider life expectancy": 'estlifexpectancy' from  "ActCode" display 'Consider life expectancy'
// Reason Codes
code "High familial risk": 'highfamilialrisk' from "LOCAL" display 'High familial risk'
code "History of chest radiation ages 10-30 y": 'chestxrt' from "LOCAL" display 'History of chest radiation ages 10-30 y'
code "Atypical breast finding": 'Atypical' from BiopsyResultCS display 'Atypical breast finding'
code "High 5 year risk": 'high5yrisk' from "LOCAL" display 'High 5 year risk'
code "5 year risk at least 1.67%": 'higherthanaverage5yrisk' from "LOCAL" display '5 year risk at least 1.67%'
code "Personal or family history risk factors": 'riskfactors' from "LOCAL" display 'Personal or family history risk factors'

context Patient

define "act-estlifexpectancy":
  {
		code: "Consider life expectancy",
    reason: null,
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}

define "act-HighRiskReferralGenetic":
  {
		code: "High risk referral",
    reason: "High familial risk",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}

define "act-HighRiskReferralChestXRT":
  {
		code: "High risk referral",
    reason: "History of chest radiation ages 10-30 y",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}


define "act-HighRiskReferralAtypicalBiopsy":
  {
		code: "High risk referral",
    reason: "Atypical breast finding",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}  
  
define "act-HighRiskReferral":
  {
		code: "High risk referral",
    reason: "High 5 year risk",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}

define "act-ConsiderHighRiskReferral":
  {
		code: "High risk referral",
    reason: "5 year risk at least 1.67%",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}

define "act-5YRiskAssessment":
  {
		code: "Perform informal 5 year risk assessment",
    reason: "Personal or family history risk factors",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}  

define "act-5YRiskAssessmentTool":
  {
		code: "5 year risk assessment tool",
    reason: "Personal or family history risk factors",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	} 

