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

library AverageRisk version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include AverageRiskEvents version '1.0.0' called Events
include AverageRiskActions version '1.0.0' called Actions
include DataElements version '1.0.0' called DataElements
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

parameter ACS System.Boolean default true
parameter USPSTF System.Boolean default true

context Patient

//------------------------------------------------------------------------------
// RECOMMENDATIONS
//------------------------------------------------------------------------------

define "flow-AverageRisk":
  {    
    ACSMammoAvgRiskAgeUnder45,
    ACSMammoAvgRiskAge45to54,
    ACSMammoAvgRiskAgeOver54,
    USPSTFAvgRisk
  }   
  except { null }

define ACSMammoAvgRiskAgeUnder45:
  if ACS and Events."eve-ageUnder40" or Events."eve-age40to44" is true
  then Actions."act-acsavgrecs40" else null 

define ACSMammoAvgRiskAge45to54:
  if ACS and Events."eve-Age45to54" is true
  then Actions."act-acsavgrecs45" else null    

define ACSMammoAvgRiskAgeOver54:
  if ACS and Events."eve-AgeOver54" is true
  then Actions."act-acsavgrecs55" else null  

define USPSTFAvgRisk:
  if USPSTF 
  then Actions."act-uspstfavgrecs" else null  

//------------------------------------------------------------------------------
// DYNAMIC VALUES
//------------------------------------------------------------------------------    

define ExistsACSMammoAvgRiskAgeUnder45:
  ACSMammoAvgRiskAgeUnder45 is not null

define ACSMammoAvgRiskAgeUnder45Code:    
  ACSMammoAvgRiskAgeUnder45 R return R.code

define ACSMammoAvgRiskAgeUnder45Reason:
  ACSMammoAvgRiskAgeUnder45 R return R.reason

define ACSMammoAvgRiskAgeUnder45Timing:    
  ACSMammoAvgRiskAgeUnder45 R return R.timingTiming

define ACSMammoAvgRiskAgeUnder45TimingEvent:    
  ACSMammoAvgRiskAgeUnder45Timing R return First(R.event)  

define ACSMammoAvgRiskAgeUnder45Flag:
  ACSMammoAvgRiskAgeUnder45 R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)    

define ExistsACSMammoAvgRiskAge45to54:
  ACSMammoAvgRiskAge45to54 is not null

define ACSMammoAvgRiskAge45to54Code:    
  ACSMammoAvgRiskAge45to54 R return R.code

define ACSMammoAvgRiskAge45to54Reason:
  ACSMammoAvgRiskAge45to54 R return R.reason

define ACSMammoAvgRiskAge45to54Timing:    
  ACSMammoAvgRiskAge45to54 R return R.timingTiming

define ACSMammoAvgRiskAge45to54TimingEvent:    
  ACSMammoAvgRiskAge45to54Timing R return First(R.event)  

define ACSMammoAvgRiskAge45to54Flag:
  ACSMammoAvgRiskAge45to54 R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)

define ExistsACSMammoAvgRiskAgeOver54:
  ACSMammoAvgRiskAgeOver54 is not null

define ACSMammoAvgRiskAgeOver54Code:    
  ACSMammoAvgRiskAgeOver54 R return R.code

define ACSMammoAvgRiskAgeOver54Reason:
  ACSMammoAvgRiskAgeOver54 R return R.reason

define ACSMammoAvgRiskAgeOver54Timing:    
  ACSMammoAvgRiskAgeOver54 R return R.timingTiming

define ACSMammoAvgRiskAgeOver54TimingEvent:    
  ACSMammoAvgRiskAgeOver54Timing R return First(R.event)  

define ACSMammoAvgRiskAgeOver54Flag:
  ACSMammoAvgRiskAgeOver54 R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)  

define ExistsUSPSTFAvgRisk:
  USPSTFAvgRisk is not null

define USPSTFAvgRiskCode:    
  USPSTFAvgRisk R return R.code

define USPSTFAvgRiskReason:
  USPSTFAvgRisk R return R.reason

define USPSTFAvgRiskTiming:    
  USPSTFAvgRisk R return R.timingTiming

define USPSTFAvgRiskTimingEvent:    
  USPSTFAvgRiskTiming R return First(R.event)

define USPSTFAvgRiskFlag:
  USPSTFAvgRisk R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)    