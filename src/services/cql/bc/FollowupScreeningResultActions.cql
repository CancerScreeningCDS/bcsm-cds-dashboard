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

library FollowupScreeningResultActions version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements
include BCSMCommonFunctions version '1.0.0' called BCSMCommon
include FollowupScreeningResultEvents version '1.0.0' called Events

codesystem "ActCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system'
codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "BiopsyResultCS": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/biopsy-result-observation-code-system'

// Act Codes
code "Determine next due date": 'determinenextdue' from "ActCode" display 'Determine next due date'
code "Follow-up radiologist recommendations": 'radiologyrecs' from "ActCode" display 'Follow-up radiologist recommendations'
code "Order interval imaging": 'intervalscreen' from "ActCode" display 'Order interval imaging'
code "Breast biopsy": 'breastbiopsy' from  "ActCode" display 'Breast biopsy'
code "Breast surgeon referral": 'surgicalreferral' from  "ActCode" display 'Breast surgeon referral'
code "Oncologic referral": 'oncreferral' from  "ActCode" display 'Oncologic referral'
// Reason Codes
code "Category0": '397138000' from "SNOMED-CT" display 'Mammography assessment (Category 0) - Need additional imaging evaluation (finding)'
code "Category3": '397143007' from "SNOMED-CT" display 'Mammography assessment (Category 3) - Probably benign finding, short interval follow-up (finding)'
code "Category4": '397144001' from "SNOMED-CT" display 'Mammography assessment (Category 4) - Suspicious abnormality, biopsy should be considered (finding)'
code "Category5": '397145000' from "SNOMED-CT" display 'Mammography assessment (Category 5) - Highly suggestive of malignancy (finding)'
code "Negative": 'Negative' from BiopsyResultCS display 'Normal breast tissue'
code "Benign": 'Benign' from BiopsyResultCS display 'Benign breast finding'
code "Atypical": 'Atypical' from BiopsyResultCS display 'Atypical breast finding'
code "Malignant": 'Malignant' from BiopsyResultCS display 'Malignant breast finding'
code "Indeterminate": 'Indeterminate' from BiopsyResultCS display 'Indeterminate breast finding'
code "Discordant": 'Discordant' from BiopsyResultCS display 'Discordant breast finding'

context Patient

define "act-incompletescreen":
  BCSMCommon.SetFollowupRecommendation(
    "Follow-up radiologist recommendations", 
    "Category0", 
    BCSMCommon.SourceDocumentationOther, 
    Events.LatestTest.date)     

define "act-intervalscreen":
  BCSMCommon.SetFollowupRecommendation(
    "Order interval imaging", 
    "Category3", 
    BCSMCommon.SourceDocumentationOther, 
    Events.LatestTest.date)  

define "act-biopsy4": 
  BCSMCommon.SetFollowupRecommendation(
    "Breast biopsy", 
    "Category4", 
    BCSMCommon.SourceDocumentationOther, 
    Events.LatestTest.date)    

define "act-biopsy5":
  BCSMCommon.SetFollowupRecommendation(
    "Breast biopsy", 
    "Category5", 
    BCSMCommon.SourceDocumentationOther, 
    Events.LatestTest.date)      

define "act-benignbiopsy":
  BCSMCommon.SetFollowupRecommendation(
    "Determine next due date", 
    "Benign", 
    BCSMCommon.SourceDocumentationOther, 
    Events.LatestTest.date)    

define "act-highriskreferral":
  BCSMCommon.SetFollowupRecommendation(
    "Breast surgeon referral", 
    "Atypical", 
    BCSMCommon.SourceDocumentationOther, 
    Events.LatestTest.date)    

define "act-indeterminatebiopsy":
  BCSMCommon.SetFollowupRecommendation(
    "Breast surgeon referral", 
    "Indeterminate", 
    BCSMCommon.SourceDocumentationOther, 
    Events.LatestTest.date)    

define "act-discordantbiopsy":
  BCSMCommon.SetFollowupRecommendation(
    "Breast surgeon referral", 
    "Discordant", 
    BCSMCommon.SourceDocumentationOther, 
    Events.LatestTest.date)    

define "act-oncreferral": 
  BCSMCommon.SetFollowupRecommendation(
    "Oncologic referral", 
    "Malignant", 
    BCSMCommon.SourceDocumentationOther, 
    Events.LatestTest.date)    

