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

library ScreeningEligibleActions version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include DataElements version '1.0.0' called DataElements
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

codesystem "ActCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system'
codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'

// Act Codes
code "Eligible for screening": 'eligible' from "ActCode" display 'Eligible for screening'
code "Not eligible for screening": 'noteligible' from "ActCode" display 'Not eligible for screening'
code "Diagnostic testing":  'diagtesting' from "ActCode" display 'Diagnostic testing'
// Reason Codes
code "Eligible for screening reason": 'eligibleforscreening' from "LOCAL" display 'Eligible for screening'
code "Not assigned female at birth": 'notassignedfemaleatbirth' from "LOCAL" display 'Not assigned female at birth'
code "Current breast cancer": 'currentbreastcancer' from "LOCAL" display 'Current breast cancer'
code "Bilateral mastectomy":  'bilatmastectomy' from "LOCAL" display 'Bilateral mastectomy'
code "New or worsening breast symptoms or findings":  'breastsymptomsorfindings' from "LOCAL" display 'New or worsening breast symptoms or findings'

context Patient

define "act-eligible":
  {
		code: "Eligible for screening",
    reason: "Eligible for screening reason",
    documentation: BCSMCommon.SourceDocumentationOther
	}

define "end-noteligible-notassignedfemaleatbirth":
  {    
		code: "Not eligible for screening",
    reason: "Not assigned female at birth",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}

define "end-noteligible-currentbreastcancer":
  {
		code: "Not eligible for screening",
    reason: "Current breast cancer",
    documentation: BCSMCommon.SourceDocumentationUSPSTF
	}  

define "end-noteligible-bilatmastectomy":  
  {
		code: "Not eligible for screening",
    reason: "Bilateral mastectomy",
    documentation: BCSMCommon.SourceDocumentationOther
	} 

define "act-dxtesting":
  {
		code: "Diagnostic testing",
    reason: "New or worsening breast symptoms or findings",
    documentation: BCSMCommon.SourceDocumentationOther
	} 

