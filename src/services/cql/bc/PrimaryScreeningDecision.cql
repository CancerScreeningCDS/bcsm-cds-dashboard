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

library PrimaryScreeningDecision version '1.0.0'

using FHIR version '4.0.1'

include ScreeningEligible version '1.0.0' called ScreeningEligible
include DecisionToScreen version '1.0.0' called DecisionToScreen

context Patient

//------------------------------------------------------------------------------
// RECOMMENDATIONS
//------------------------------------------------------------------------------

define PrimaryScreeningDecision:
  Flatten({ "flow-ScreeningEligible", "flow-DecisionToScreen" }
      except { null }
  )

define "flow-ScreeningEligible":
  ScreeningEligible."flow-ScreeningEligible"

define "flow-DecisionToScreen":
  if IsScreeningEligible then DecisionToScreen."flow-DecisionToScreen" 
    else null

//------------------------------------------------------------------------------
// DYNAMIC VALUES
//------------------------------------------------------------------------------      

define CheckIsIncludedAndNotExcluded:
  ScreeningEligible.CheckIsIncludedAndNotExcluded

define IsScreeningEligible:
  ScreeningEligible."IsScreeningEligible"

define IsNotScreeningEligible:
  ScreeningEligible.IsNotScreeningEligible

define ExistsNotEligibleNotAssignedFemaleAtBirth:
  ScreeningEligible.ExistsNotEligibleNotAssignedFemaleAtBirth

define ExistsNotEligibleCurrentBreastCancer:
  ScreeningEligible.ExistsNotEligibleCurrentBreastCancer 

define ExistsNotEligibleBilateralMastectomy:
  ScreeningEligible.ExistsNotEligibleBilateralMastectomy 

define ExistsNotEligibleBreastSymptomsOrFindings:
  ScreeningEligible.ExistsNotEligibleBreastSymptomsOrFindings   

define ScreeningEligibleCode:
  ScreeningEligible.ScreeningEligibleCode

define ScreeningEligibleReason:
  ScreeningEligible.ScreeningEligibleReason     

//------------------------------------------------------------------------------
// DYNAMIC VALUES DECISION TO SCREEN
//------------------------------------------------------------------------------  

define ExistsMammogramRecommendations:
  DecisionToScreen.ExistsMammogramRecommendations

define ExistsMriRecommendations:
  DecisionToScreen.ExistsMriRecommendations

define ExistsSDMContinueScreeningAge:
  DecisionToScreen.ExistsSDMContinueScreeningAge

define SDMContinueScreeningAgeCode:
  DecisionToScreen.SDMContinueScreeningAgeCode

define SDMContinueScreeningAgeReason:
  DecisionToScreen.SDMContinueScreeningAgeReason

define ExistsSDMContinueScreeningLifeExp:
  DecisionToScreen.ExistsSDMContinueScreeningLifeExp

define SDMContinueScreeningLifeExpCode:
  DecisionToScreen.SDMContinueScreeningLifeExpCode

define SDMContinueScreeningLifeExpReason:
  DecisionToScreen.SDMContinueScreeningLifeExpReason

define ExistsSDMDelayScreeningLactating:
  DecisionToScreen.ExistsSDMDelayScreeningLactating

define SDMDelayScreeningLactatingCode:
  DecisionToScreen.SDMDelayScreeningLactatingCode

define SDMDelayScreeningLactatingReason:
  DecisionToScreen.SDMDelayScreeningLactatingReason

define ExistsHighRiskExclusionsRecommendations:
  exists DecisionToScreen.HighRiskExclusionsRecommendations

define ExistsSpecialPopulationsRecommendations:
  exists DecisionToScreen.SpecialPopulationsRecommendations

define ExistsAverageRiskRecommendations:
  exists DecisionToScreen.AverageRiskRecommendations  

//------------------------------------------------------------------------------
// DYNAMIC VALUES HIGH RISK EXCLUSIONS
//------------------------------------------------------------------------------   

define ExistsSpecialtyReferralGeneticRisk:  
  DecisionToScreen."ExistsSpecialtyReferralGeneticRisk"

define SpecialtyReferralGeneticRiskCode:
  DecisionToScreen."SpecialtyReferralGeneticRiskCode"    

define SpecialtyReferralGeneticRiskReason:
  DecisionToScreen."SpecialtyReferralGeneticRiskReason"

define ExistsACSGeneticRiskMammo:
  DecisionToScreen."ExistsACSGeneticRiskMammo"

define ACSGeneticRiskMammoCode:    
  DecisionToScreen."ACSGeneticRiskMammoCode"

define ACSGeneticRiskMammoReason:
  DecisionToScreen."ACSGeneticRiskMammoReason"

define ACSGeneticRiskMammoTiming:    
  DecisionToScreen."ACSGeneticRiskMammoTiming"

define ACSGeneticRiskMammoTimingEvent:    
  DecisionToScreen."ACSGeneticRiskMammoTimingEvent"

define ACSGeneticRiskMammoFlag:  
  DecisionToScreen."ACSGeneticRiskMammoFlag"

define ExistsACSGeneticRiskMri:
  DecisionToScreen."ExistsACSGeneticRiskMri"

define ACSGeneticRiskMriCode:    
  DecisionToScreen."ACSGeneticRiskMriCode"

define ACSGeneticRiskMriReason:  
  DecisionToScreen."ACSGeneticRiskMriReason"

define ACSGeneticRiskMriTiming:    
  DecisionToScreen."ACSGeneticRiskMriTiming"

define ACSGeneticRiskMriTimingEvent:    
  DecisionToScreen."ACSGeneticRiskMriTimingEvent"

define ACSGeneticRiskMriFlag:  
  DecisionToScreen."ACSGeneticRiskMriFlag"

define ExistsACSMammoAfterRT:
  DecisionToScreen."ExistsACSMammoAfterRT"

define ACSMammoAfterRTCode:    
  DecisionToScreen."ACSMammoAfterRTCode"

define ACSMammoAfterRTReason:  
  DecisionToScreen."ACSMammoAfterRTReason"

define ACSMammoAfterRTTiming:    
  DecisionToScreen."ACSMammoAfterRTTiming"

define ACSMammoAfterRTTimingEvent:    
  DecisionToScreen."ACSMammoAfterRTTimingEvent"

define ACSMammoAfterRTFlag:  
  DecisionToScreen."ACSMammoAfterRTFlag"

define ExistsACSMriAfterRT:
  DecisionToScreen."ExistsACSMriAfterRT"

define ACSMriAfterRTCode:    
  DecisionToScreen."ACSMriAfterRTCode"

define ACSMriAfterRTReason:    
  DecisionToScreen."ACSMriAfterRTReason"

define ACSMriAfterRTTiming:    
  DecisionToScreen."ACSMriAfterRTTiming"

define ACSMriAfterRTTimingEvent:    
  DecisionToScreen."ACSMriAfterRTTimingEvent"

define ACSMriAfterRTFlag:  
  DecisionToScreen."ACSMriAfterRTFlag"

define ExistsACSMammoAfterBrca:
  DecisionToScreen."ExistsACSMammoAfterBrca"

define ACSMammoAfterBrcaCode:    
  DecisionToScreen."ACSMammoAfterBrcaCode"

define ACSMammoAfterBrcaReason:    
  DecisionToScreen."ACSMammoAfterBrcaReason"

define ACSMammoAfterBrcaTiming:    
  DecisionToScreen."ACSMammoAfterBrcaTiming"

define ACSMammoAfterBrcaTimingEvent:    
  DecisionToScreen."ACSMammoAfterBrcaTimingEvent"

define ACSMammoAfterBrcaFlag:
  DecisionToScreen."ACSMammoAfterBrcaFlag"  

define ExistsSpecialtyReferralBreastCaWithin5y:  
  DecisionToScreen."ExistsSpecialtyReferralBreastCaWithin5y"

define SpecialtyReferralBreastCaWithin5yCode:
  DecisionToScreen."SpecialtyReferralBreastCaWithin5yCode"  

define SpecialtyReferralBreastCaWithin5yReason:
  DecisionToScreen."SpecialtyReferralBreastCaWithin5yReason"

define ExistsACSMammoAtypicalBiopsy:
  DecisionToScreen."ExistsACSMammoAtypicalBiopsy"

define ACSMammoAtypicalBiopsyCode:    
  DecisionToScreen."ACSMammoAtypicalBiopsyCode"

define ACSMammoAtypicalBiopsyReason:    
  DecisionToScreen."ACSMammoAtypicalBiopsyReason"

define ACSMammoAtypicalBiopsyTiming:    
  DecisionToScreen."ACSMammoAtypicalBiopsyTiming"

define ACSMammoAtypicalBiopsyTimingEvent:    
  DecisionToScreen."ACSMammoAtypicalBiopsyTimingEvent"

define ACSMammoAtypicalBiopsyFlag:  
  DecisionToScreen."ACSMammoAtypicalBiopsyFlag"  

define ExistsACSAtypicalBiopsy:
  DecisionToScreen."ExistsACSAtypicalBiopsy"

define ACSAtypicalBiopsyCode:    
  DecisionToScreen."ACSAtypicalBiopsyCode"

define ACSAtypicalBiopsyReason:    
  DecisionToScreen."ACSAtypicalBiopsyReason"  

define ExistsACSMriAtypicalBiopsyHighRisk:
  DecisionToScreen."ExistsACSMriAtypicalBiopsyHighRisk"

define ACSMriAtypicalBiopsyHighRiskCode:    
  DecisionToScreen."ACSMriAtypicalBiopsyHighRiskCode"

define ACSMriAtypicalBiopsyHighRiskReason:    
  DecisionToScreen."ACSMriAtypicalBiopsyHighRiskReason"

define ACSMriAtypicalBiopsyHighRiskTiming:    
  DecisionToScreen."ACSMriAtypicalBiopsyHighRiskTiming"

define ACSMriAtypicalBiopsyHighRiskTimingEvent:    
  DecisionToScreen."ACSMriAtypicalBiopsyHighRiskTimingEvent"

define ACSMriAtypicalBiopsyHighRiskFlag:  
  DecisionToScreen."ACSMriAtypicalBiopsyHighRiskFlag"  

//------------------------------------------------------------------------------
// DYNAMIC VALUES SPECIAL POPULATIONS
//------------------------------------------------------------------------------  

define ExistsACSMammoHighRisk:
  DecisionToScreen.ExistsACSMammoHighRisk

define ACSMammoHighRiskCode:    
  DecisionToScreen.ACSMammoHighRiskCode

define ACSMammoHighRiskReason:    
  DecisionToScreen.ACSMammoHighRiskReason

define ACSMammoHighRiskTiming:    
  DecisionToScreen.ACSMammoHighRiskTiming

define ACSMammoHighRiskTimingEvent:    
  DecisionToScreen.ACSMammoHighRiskTimingEvent

define ACSMammoHighRiskFlag:  
  DecisionToScreen.ACSMammoHighRiskFlag

define ExistsACSMriHighRisk:
  DecisionToScreen.ExistsACSMriHighRisk

define ACSMriHighRiskCode:    
  DecisionToScreen.ACSMriHighRiskCode

define ACSMriHighRiskReason:    
  DecisionToScreen.ACSMriHighRiskReason

define ACSMriHighRiskTiming:    
  DecisionToScreen.ACSMriHighRiskTiming

define ACSMriHighRiskTimingEvent:    
  DecisionToScreen.ACSMriHighRiskTimingEvent

define ACSMriHighRiskFlag:  
  DecisionToScreen.ACSMriHighRiskFlag  

define ExistsACSFirstDegGeneticMammo:
  DecisionToScreen.ExistsACSFirstDegGeneticMammo

define ACSFirstDegGeneticMammoCode:    
  DecisionToScreen.ACSFirstDegGeneticMammoCode

define ACSFirstDegGeneticMammoReason:    
  DecisionToScreen.ACSFirstDegGeneticMammoReason

define ACSFirstDegGeneticMammoTiming:    
  DecisionToScreen.ACSFirstDegGeneticMammoTiming

define ACSFirstDegGeneticMammoTimingEvent:    
  DecisionToScreen.ACSFirstDegGeneticMammoTimingEvent

define ACSFirstDegGeneticMammoFlag:  
  DecisionToScreen.ACSFirstDegGeneticMammoFlag  

define ExistsACSFirstDegGeneticMri:
  DecisionToScreen.ExistsACSFirstDegGeneticMri

define ACSFirstDegGeneticMriCode:    
  DecisionToScreen.ACSFirstDegGeneticMriCode

define ACSFirstDegGeneticMriReason:    
  DecisionToScreen.ACSFirstDegGeneticMriReason

define ACSFirstDegGeneticMriTiming:    
  DecisionToScreen.ACSFirstDegGeneticMriTiming

define ACSFirstDegGeneticMriTimingEvent:    
  DecisionToScreen.ACSFirstDegGeneticMriTimingEvent

define ACSFirstDegGeneticMriFlag:  
  DecisionToScreen.ACSFirstDegGeneticMriFlag  

define ExistsBreastImagingHeterogenouslyOrExtremelyDense:
  DecisionToScreen.ExistsBreastImagingHeterogenouslyOrExtremelyDense

define BreastImagingHeterogenouslyOrExtremelyDenseCode:
  DecisionToScreen.BreastImagingHeterogenouslyOrExtremelyDenseCode

define BreastImagingHeterogenouslyOrExtremelyDenseReason:
  DecisionToScreen.BreastImagingHeterogenouslyOrExtremelyDenseReason

define ExistsCompellingFamilyHistory:
  DecisionToScreen.ExistsCompellingFamilyHistory

define CompellingFamilyHistoryCode:
  DecisionToScreen.CompellingFamilyHistoryCode

define CompellingFamilyHistoryReason:
  DecisionToScreen.CompellingFamilyHistoryReason

define ExistsUSPSTFRecommendation:
  DecisionToScreen.ExistsUSPSTFRecommendation

define USPSTFRecommendationCode:    
  DecisionToScreen.USPSTFRecommendationCode

define USPSTFRecommendationReason:    
  DecisionToScreen.USPSTFRecommendationReason

define USPSTFRecommendationTiming:    
  DecisionToScreen.USPSTFRecommendationTiming

define USPSTFRecommendationTimingEvent:    
  DecisionToScreen.USPSTFRecommendationTimingEvent

define USPSTFRecommendationFlag:  
  DecisionToScreen.USPSTFRecommendationFlag  

//------------------------------------------------------------------------------
// DYNAMIC VALUES AVERAGE RISK
//------------------------------------------------------------------------------    

define ExistsACSMammoAvgRiskAgeUnder45:
  DecisionToScreen.ExistsACSMammoAvgRiskAgeUnder45

define ACSMammoAvgRiskAgeUnder45Code:    
  DecisionToScreen.ACSMammoAvgRiskAgeUnder45Code

define ACSMammoAvgRiskAgeUnder45Reason:
  DecisionToScreen.ACSMammoAvgRiskAgeUnder45Reason

define ACSMammoAvgRiskAgeUnder45Timing:    
  DecisionToScreen.ACSMammoAvgRiskAgeUnder45Timing

define ACSMammoAvgRiskAgeUnder45TimingEvent:    
  DecisionToScreen.ACSMammoAvgRiskAgeUnder45TimingEvent

define ACSMammoAvgRiskAgeUnder45Flag:
  DecisionToScreen.ACSMammoAvgRiskAgeUnder45Flag  

define ExistsACSMammoAvgRiskAge45to54:
  DecisionToScreen.ExistsACSMammoAvgRiskAge45to54

define ACSMammoAvgRiskAge45to54Code:    
  DecisionToScreen.ACSMammoAvgRiskAge45to54Code

define ACSMammoAvgRiskAge45to54Reason:
  DecisionToScreen.ACSMammoAvgRiskAge45to54Reason

define ACSMammoAvgRiskAge45to54Timing:    
  DecisionToScreen.ACSMammoAvgRiskAge45to54Timing

define ACSMammoAvgRiskAge45to54TimingEvent:    
  DecisionToScreen.ACSMammoAvgRiskAge45to54TimingEvent

define ACSMammoAvgRiskAge45to54Flag:
  DecisionToScreen.ACSMammoAvgRiskAge45to54Flag   

define ExistsACSMammoAvgRiskAgeOver54:
  DecisionToScreen.ExistsACSMammoAvgRiskAgeOver54

define ACSMammoAvgRiskAgeOver54Code:    
  DecisionToScreen.ACSMammoAvgRiskAgeOver54Code

define ACSMammoAvgRiskAgeOver54Reason:
  DecisionToScreen.ACSMammoAvgRiskAgeOver54Reason

define ACSMammoAvgRiskAgeOver54Timing:    
  DecisionToScreen.ACSMammoAvgRiskAgeOver54Timing

define ACSMammoAvgRiskAgeOver54TimingEvent:    
  DecisionToScreen.ACSMammoAvgRiskAgeOver54TimingEvent

define ACSMammoAvgRiskAgeOver54Flag:
  DecisionToScreen.ACSMammoAvgRiskAgeOver54Flag    

define ExistsUSPSTFAvgRisk:
  DecisionToScreen.ExistsUSPSTFAvgRisk

define USPSTFAvgRiskCode:    
  DecisionToScreen.USPSTFAvgRiskCode

define USPSTFAvgRiskReason:
  DecisionToScreen.USPSTFAvgRiskReason

define USPSTFAvgRiskTiming:    
  DecisionToScreen.USPSTFAvgRiskTiming

define USPSTFAvgRiskTimingEvent:    
  DecisionToScreen.USPSTFAvgRiskTimingEvent

define USPSTFAvgRiskFlag:
  DecisionToScreen.USPSTFAvgRiskFlag