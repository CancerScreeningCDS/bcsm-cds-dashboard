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

library SpecialPopulations version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include SpecialPopulationsEvents version '1.0.0' called Events
include SpecialPopulationsActions version '1.0.0' called Actions
include DataElements version '1.0.0' called DataElements
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

parameter ACS System.Boolean default true
parameter USPSTF System.Boolean default true

context Patient

//------------------------------------------------------------------------------
// RECOMMENDATIONS
//------------------------------------------------------------------------------

define "flow-SpecialPopulations":
  ACSRecommendations union {USPSTFRecommendation} except { null }

define ACSRecommendations:
  {    
    ACSMammoHighRisk,
    ACSMriHighRisk,
    ACSFirstDegGeneticMammo,
    ACSFirstDegGeneticMri,
    BreastImagingHeterogenouslyOrExtremelyDense,
    CompellingFamilyHistory
  }   
  except { null }

define ACSMammoHighRisk:
  if ACS and Events."eve-highlifetimerisk" is true
  then Actions."act-acshighriskmammo" else null       

define ACSMriHighRisk:
  if ACS and Events."eve-highlifetimerisk" is true
  then Actions."act-acshighriskmri" else null       

define ACSFirstDegGeneticMammo:
  if ACS and Events."eve-firstdeggenetic" is true
  then Actions."act-firstdeggeneticmammo" else null   

define ACSFirstDegGeneticMri:
  if ACS and Events."eve-firstdeggenetic" is true
  then Actions."act-firstdeggeneticmri" else null  

define BreastImagingHeterogenouslyOrExtremelyDense:
  if ACS and Events."eve-breastdensitycord" is true
  then Actions."act-breastdensitycord" else null

define CompellingFamilyHistory:
  if ACS and Events."eve-fhxbreastcarisk" is true
  then Actions."act-fhxbreastcarisk" else null

// only show recommendation if ACS recs exists, otherwise AverageRisk flow applies
define USPSTFRecommendation:
  if ACS and exists ACSRecommendations 
  then Actions."act-uspstfrecs" else null

//------------------------------------------------------------------------------
// DYNAMIC VALUES
//------------------------------------------------------------------------------    

define ExistsACSMammoHighRisk:
  ACSMammoHighRisk is not null

define ACSMammoHighRiskCode:    
  ACSMammoHighRisk R return R.code

define ACSMammoHighRiskReason:    
  ACSMammoHighRisk R return R.reason 

define ACSMammoHighRiskTiming:    
  ACSMammoHighRisk R return R.timingTiming

define ACSMammoHighRiskTimingEvent:    
  ACSMammoHighRiskTiming R return First(R.event) 

define ACSMammoHighRiskFlag:
  ACSMammoHighRisk R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)       

define ExistsACSMriHighRisk:
  ACSMriHighRisk is not null

define ACSMriHighRiskCode:    
  ACSMriHighRisk R return R.code

define ACSMriHighRiskReason:    
  ACSMriHighRisk R return R.reason 

define ACSMriHighRiskTiming:    
  ACSMriHighRisk R return R.timingTiming

define ACSMriHighRiskTimingEvent:    
  ACSMriHighRiskTiming R return First(R.event)   

define ACSMriHighRiskFlag:
  ACSMriHighRisk R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)   

define ExistsACSFirstDegGeneticMammo:
  ACSFirstDegGeneticMammo is not null

define ACSFirstDegGeneticMammoCode:    
  ACSFirstDegGeneticMammo R return R.code

define ACSFirstDegGeneticMammoReason:    
  ACSFirstDegGeneticMammo R return R.reason 

define ACSFirstDegGeneticMammoTiming:    
  ACSFirstDegGeneticMammo R return R.timingTiming

define ACSFirstDegGeneticMammoTimingEvent:    
  ACSFirstDegGeneticMammoTiming R return First(R.event)   

define ACSFirstDegGeneticMammoFlag:
  ACSFirstDegGeneticMammo R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)   

define ExistsACSFirstDegGeneticMri:
  ACSFirstDegGeneticMri is not null

define ACSFirstDegGeneticMriCode:    
  ACSFirstDegGeneticMri R return R.code

define ACSFirstDegGeneticMriReason:    
  ACSFirstDegGeneticMri R return R.reason 

define ACSFirstDegGeneticMriTiming:    
  ACSFirstDegGeneticMri R return R.timingTiming

define ACSFirstDegGeneticMriTimingEvent:    
  ACSFirstDegGeneticMriTiming R return First(R.event)  

define ACSFirstDegGeneticMriFlag:
  ACSFirstDegGeneticMri R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)     

define ExistsBreastImagingHeterogenouslyOrExtremelyDense:
  BreastImagingHeterogenouslyOrExtremelyDense is not null

define BreastImagingHeterogenouslyOrExtremelyDenseCode:
  BreastImagingHeterogenouslyOrExtremelyDense.code

define BreastImagingHeterogenouslyOrExtremelyDenseReason:
  BreastImagingHeterogenouslyOrExtremelyDense.reason

define ExistsCompellingFamilyHistory:
  CompellingFamilyHistory is not null

define CompellingFamilyHistoryCode:
  CompellingFamilyHistory.code

define CompellingFamilyHistoryReason:
  CompellingFamilyHistory.reason 

define ExistsUSPSTFRecommendation:
  USPSTFRecommendation is not null

define USPSTFRecommendationCode:    
  USPSTFRecommendation R return R.code

define USPSTFRecommendationReason:    
  USPSTFRecommendation R return R.reason 

define USPSTFRecommendationTiming:    
  USPSTFRecommendation R return R.timingTiming

define USPSTFRecommendationTimingEvent:    
  USPSTFRecommendationTiming R return First(R.event) 

define USPSTFRecommendationFlag:
  USPSTFRecommendation R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)   