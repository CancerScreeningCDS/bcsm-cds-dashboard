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

library DecisionToScreenActions version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

codesystem "ActCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system'
codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'

// Act Codes
code "Screening Next Due": 'screeningnextdue' from "ActCode" display 'Screening Next Due'
code "Discuss decision to continue screening": 'sdmcontinue' from "ActCode" display 'Shared decision making to continue screening'
code "Discuss delay in screening": 'sdmdelay' from "ActCode" display 'Shared decision making to consider delay in screening'
// Reason Codes
code "Age over 74 years": 'ageover74' from "LOCAL" display 'Age over 74 years'
code "Reduced life expectancy indicator": 'lifeexp' from "LOCAL" display 'Reduced life expectancy indicator'
code "Currently lactating": 'currentlylactating' from "LOCAL" display 'Currently lactating'
code "USPSTF average risk": 'USPSTFaveragerisk' from "LOCAL" display 'USPSTF average risk'

context Patient

define "act-sdmcontinueage":
  {
		code: "Discuss decision to continue screening",
    reason: "Age over 74 years",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}  

define "act-sdmcontinuelifexp":
  {
		code: "Discuss decision to continue screening",
    reason: "Reduced life expectancy indicator",
    documentation: BCSMCommon.SourceDocumentationACS
	} 

define "act-lactating":
  {
		code: "Discuss delay in screening",
    reason: "Currently lactating",
    documentation: BCSMCommon.SourceDocumentationOther
	} 

