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

library GeneticRiskReferralActions version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

codesystem "ActCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system'
codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'

// Act Codes
code "Brief familial risk assessment tool": 'fhxrisktool' from "ActCode" display 'Brief familial risk assessment tool'
code "Informal familial risk assessment": 'fhxriskassess' from "ActCode" display 'Informal familial risk assessment'
code "Genetic risk referral": 'geneticriskreferral' from  "ActCode" display 'Genetic risk referral'
// Reason Codes
code "Family history of inherited cancer susceptibility": 'fhxgenetic' from "LOCAL" display 'Family history of inherited cancer susceptibility'
code "Ancestry associated with BRCA1/2 gene mutations": 'brcageneancestry' from "LOCAL" display 'Ancestry associated with BRCA1/2 gene mutations'
code "Family history of breast, ovarian, tubal, or peritoneal cancer": 'fhxbrcaovcatubalperit' from "LOCAL" display 'Family history of breast, ovarian, tubal, or peritoneal cancer'
code "High familial risk": 'highfamilialrisk' from "LOCAL" display 'High familial risk'

context Patient

define "act-fhxrisktool":
  {
		code: "Brief familial risk assessment tool",
    reason: "Family history of breast, ovarian, tubal, or peritoneal cancer",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}  

define "act-fhxriskassess":
  {
		code: "Informal familial risk assessment",
    reason: "Family history of breast, ovarian, tubal, or peritoneal cancer",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}   

define "act-geneticreferralrisk":
  {
		code: "Genetic risk referral",
    reason: "High familial risk",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}

define "act-geneticreferralvariant":
  {
		code: "Genetic risk referral",
    reason: "Family history of inherited cancer susceptibility",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	} 

define "act-geneticreferralancestry":
  {
		code: "Genetic risk referral",
    reason: "Ancestry associated with BRCA1/2 gene mutations",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}   

