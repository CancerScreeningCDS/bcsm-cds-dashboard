library HighRiskExclusions version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include HighRiskExclusionsEvents version '1.0.0' called Events
include HighRiskExclusionsActions version '1.0.0' called Actions
include DataElements version '1.0.0' called DataElements
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

context Patient

//------------------------------------------------------------------------------
// RECOMMENDATIONS
//------------------------------------------------------------------------------

define "flow-HighRiskExclusions":
  {    
    ACSGeneticRiskMammo,
    ACSGeneticRiskMri,
    SpecialtyReferralGeneticRisk,
    ACSMammoAfterRT,
    ACSMriAfterRT,
    ACSMammoAfterBrca,
    SpecialtyReferralBreastCaWithin5y,
    ACSMammoAtypicalBiopsy,
    ACSAtypicalBiopsy,
    ACSMriAtypicalBiopsyHighRisk
  }   
  except { null }

define SpecialtyReferralGeneticRisk:
  if Events."eve-geneticrisk" is true
  then if Events."eve-acsgeneticrisk" is false
    then Actions."act-othergeneticrisk" else null
  else null    

define ACSGeneticRiskMammo:
  if Events."eve-geneticrisk" is true
    then if Events."eve-acsgeneticrisk" is true
      then Actions."act-acsgeneticriskmammo" else null
    else null    

define ACSGeneticRiskMri:
  if Events."eve-geneticrisk" is true
    then if Events."eve-acsgeneticrisk" is true
      then Actions."act-acsgeneticriskmri" else null
    else null       

define ACSMammoAfterRT:
  if Events."eve-chestxrt" is true
    then Actions."act-acsmammoafterRT" else null    

define ACSMriAfterRT:
  if Events."eve-chestxrt" is true
    then Actions."act-acsmriafterRT" else null    

define ACSMammoAfterBrca:
  if Events."eve-hxbreastca" is true
    then if Events."eve-hxbreastcawithin5y" is false
      then Actions."act-acsmammoafterbrca" else null
    else null       

define SpecialtyReferralBreastCaWithin5y:
  if Events."eve-hxbreastca" is true
    then if Events."eve-hxbreastcawithin5y" is true
      then Actions."act-hxbreastcawithin5y" else null
    else null  

define ACSMammoAtypicalBiopsy:
  if Events."eve-geneticrisk" is false and Events."eve-chestxrt" is false and Events."eve-hxbreastca" is false
    then if "eve-atypicalbx" is true
      then Actions."act-acsmammoatypicalbx" else null
    else null       

define ACSAtypicalBiopsy:
  if Events."eve-geneticrisk" is false and Events."eve-chestxrt" is false and Events."eve-hxbreastca" is false
    then if "eve-atypicalbx" is true and Events."eve-highlifetimerisk" is false and Events."eve-nolifetimerisk" is true
      then Actions."act-acsatypicalbx" else null
    else null       

define ACSMriAtypicalBiopsyHighRisk:
  if Events."eve-geneticrisk" is false and Events."eve-chestxrt" is false and Events."eve-hxbreastca" is false
    then if "eve-atypicalbx" is true and Events."eve-highlifetimerisk" is true
      then Actions."act-acsmriatypicalbx" else null
    else null       

//------------------------------------------------------------------------------
// ERRORS
//------------------------------------------------------------------------------     

define "eve-atypicalbx":  
  Message(Events."eve-atypicalbx", 
    DataElements.BiopsyDiagnosticReportsWithNoConclusionCodes,
    'http://example.org/CodeSystem/plan-definition-action-reason-code-system/missingresultcode',
    'Warning', 
    'A laboratory test was found without a result. Please review patient record to resolve.')      

//------------------------------------------------------------------------------
// DYNAMIC VALUES
//------------------------------------------------------------------------------   

define ExistsSpecialtyReferralGeneticRisk:  
  SpecialtyReferralGeneticRisk is not null

define SpecialtyReferralGeneticRiskCode:
  SpecialtyReferralGeneticRisk R return R.code  

define SpecialtyReferralGeneticRiskReason:
  SpecialtyReferralGeneticRisk R return R.reason

define ExistsACSGeneticRiskMammo:
  ACSGeneticRiskMammo is not null

define ACSGeneticRiskMammoCode:    
  ACSGeneticRiskMammo R return R.code

define ACSGeneticRiskMammoReason:
  ACSGeneticRiskMammo R return R.reason  

define ACSGeneticRiskMammoTiming:    
  ACSGeneticRiskMammo R return R.timingTiming

define ACSGeneticRiskMammoTimingEvent:    
  ACSGeneticRiskMammoTiming R return First(R.event)

define ACSGeneticRiskMammoFlag:
  ACSGeneticRiskMammo R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)    

define ExistsACSGeneticRiskMri:
  ACSGeneticRiskMri is not null

define ACSGeneticRiskMriCode:    
  ACSGeneticRiskMri R return R.code

define ACSGeneticRiskMriReason:  
  ACSGeneticRiskMri R return R.reason  

define ACSGeneticRiskMriTiming:    
  ACSGeneticRiskMri R return R.timingTiming

define ACSGeneticRiskMriTimingEvent:    
  ACSGeneticRiskMriTiming R return First(R.event)

define ACSGeneticRiskMriFlag:
  ACSGeneticRiskMri R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)      

define ExistsACSMammoAfterRT:
  ACSMammoAfterRT is not null

define ACSMammoAfterRTCode:    
  ACSMammoAfterRT R return R.code

define ACSMammoAfterRTReason:  
  ACSMammoAfterRT R return R.reason

define ACSMammoAfterRTTiming:    
  ACSMammoAfterRT R return R.timingTiming

define ACSMammoAfterRTTimingEvent:    
  ACSMammoAfterRTTiming R return First(R.event)

define ACSMammoAfterRTFlag:
  ACSMammoAfterRT R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)      

define ExistsACSMriAfterRT:
  ACSMriAfterRT is not null

define ACSMriAfterRTCode:    
  ACSMriAfterRT R return R.code

define ACSMriAfterRTReason:    
  ACSMriAfterRT R return R.reason  

define ACSMriAfterRTTiming:    
  ACSMriAfterRT R return R.timingTiming

define ACSMriAfterRTTimingEvent:    
  ACSMriAfterRTTiming R return First(R.event)  

define ACSMriAfterRTFlag:
  ACSMriAfterRT R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)      

define ExistsACSMammoAfterBrca:
  ACSMammoAfterBrca is not null

define ACSMammoAfterBrcaCode:    
  ACSMammoAfterBrca R return R.code

define ACSMammoAfterBrcaReason:    
  ACSMammoAfterBrca R return R.reason  

define ACSMammoAfterBrcaTiming:    
  ACSMammoAfterBrca R return R.timingTiming

define ACSMammoAfterBrcaTimingEvent:    
  ACSMammoAfterBrcaTiming R return First(R.event)

define ACSMammoAfterBrcaFlag:
  ACSMammoAfterBrca R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)      

define ExistsSpecialtyReferralBreastCaWithin5y:  
  SpecialtyReferralBreastCaWithin5y is not null

define SpecialtyReferralBreastCaWithin5yCode:
  SpecialtyReferralBreastCaWithin5y R return R.code    

define SpecialtyReferralBreastCaWithin5yReason:
  SpecialtyReferralBreastCaWithin5y R return R.reason

define ExistsACSMammoAtypicalBiopsy:
  ACSMammoAtypicalBiopsy is not null

define ACSMammoAtypicalBiopsyCode:    
  ACSMammoAtypicalBiopsy R return R.code

define ACSMammoAtypicalBiopsyReason:    
  ACSMammoAtypicalBiopsy R return R.reason  

define ACSMammoAtypicalBiopsyTiming:    
  ACSMammoAtypicalBiopsy R return R.timingTiming

define ACSMammoAtypicalBiopsyTimingEvent:    
  ACSMammoAtypicalBiopsyTiming R return First(R.event)  

define ACSMammoAtypicalBiopsyFlag:
  ACSMammoAtypicalBiopsy R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)   

define ExistsACSAtypicalBiopsy:
  ACSAtypicalBiopsy is not null

define ACSAtypicalBiopsyCode:    
  ACSAtypicalBiopsy R return R.code

define ACSAtypicalBiopsyReason:    
  ACSAtypicalBiopsy R return R.reason

define ExistsACSMriAtypicalBiopsyHighRisk:
  ACSMriAtypicalBiopsyHighRisk is not null

define ACSMriAtypicalBiopsyHighRiskCode:    
  ACSMriAtypicalBiopsyHighRisk R return R.code

define ACSMriAtypicalBiopsyHighRiskReason:    
  ACSMriAtypicalBiopsyHighRisk R return R.reason  

define ACSMriAtypicalBiopsyHighRiskTiming:    
  ACSMriAtypicalBiopsyHighRisk R return R.timingTiming

define ACSMriAtypicalBiopsyHighRiskTimingEvent:    
  ACSMriAtypicalBiopsyHighRiskTiming R return First(R.event) 

define ACSMriAtypicalBiopsyHighRiskFlag:
  ACSMriAtypicalBiopsyHighRisk R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)      