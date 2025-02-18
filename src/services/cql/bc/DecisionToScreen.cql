library DecisionToScreen version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DecisionToScreenEvents version '1.0.0' called Events
include DecisionToScreenActions version '1.0.0' called Actions
include HighRiskExclusions version '1.0.0'
include SpecialPopulations version '1.0.0'
include AverageRisk version '1.0.0'
include BCSMCommonFunctions version '1.0.0'

codesystem "LOINC": 'http://loinc.org'

code "MG Breast Screening": '24606-6' from "LOINC" display 'MG Breast Screening' 
code "MR Breast": '30794-2' from "LOINC" display 'MR Breast' 

context Patient

//------------------------------------------------------------------------------
// RECOMMENDATIONS
//------------------------------------------------------------------------------

define "flow-DecisionToScreen":  
  flatten({
    {SDMContinueScreeningAge} except { null },
    {SDMContinueScreeningLifeExp} except { null },
    HighRiskExclusionsRecommendations except { null },
    SpecialPopulationsRecommendations except { null },
    {SDMDelayScreeningLactating} except { null },
    AverageRiskRecommendations except { null }
  })
  except { null } 

define SDMContinueScreeningAge:
  if Events."eve-AgeOver74" is true
    then Actions."act-sdmcontinueage"
    else null

define SDMContinueScreeningLifeExp:
  if Events."eve-LifeExp" is true
    then Actions."act-sdmcontinuelifexp"
    else null

define HighRiskExclusionsRecommendations:  
  HighRiskExclusions."flow-HighRiskExclusions"

define SpecialPopulationsRecommendations:
  if exists HighRiskExclusionsRecommendations
  then SpecialPopulations."flow-SpecialPopulations" R where (R.reason ~ Actions."USPSTF average risk") is false
  else SpecialPopulations."flow-SpecialPopulations"

define AverageRiskRecommendations:  
  if not exists HighRiskExclusionsRecommendations and not exists SpecialPopulationsRecommendations
  then AverageRisk."flow-AverageRisk" 
  else null    

define SDMDelayScreeningLactating:
  if not exists HighRiskExclusionsRecommendations
      and Events."eve-lactating" is true
  then Actions."act-lactating"
  else null

//------------------------------------------------------------------------------
// DYNAMIC VALUES
//------------------------------------------------------------------------------  

define ExistsMammogramRecommendations:
  exists "flow-DecisionToScreen" R where R.code ~ "MG Breast Screening"

define ExistsMriRecommendations:
  exists "flow-DecisionToScreen" R where R.code ~ "MR Breast" 

define ExistsSDMContinueScreeningAge:
  SDMContinueScreeningAge is not null

define SDMContinueScreeningAgeCode:
  SDMContinueScreeningAge.code

define SDMContinueScreeningAgeReason:
  SDMContinueScreeningAge.reason  

define ExistsSDMContinueScreeningLifeExp:
  SDMContinueScreeningLifeExp is not null

define SDMContinueScreeningLifeExpCode:
  SDMContinueScreeningLifeExp.code  

define SDMContinueScreeningLifeExpReason:
  SDMContinueScreeningLifeExp.reason    

define ExistsSDMDelayScreeningLactating:
  SDMDelayScreeningLactating is not null

define SDMDelayScreeningLactatingCode:
  SDMDelayScreeningLactating.code   

define SDMDelayScreeningLactatingReason:
  SDMDelayScreeningLactating.reason  

define ExistsHighRiskExclusionsRecommendations:
  exists HighRiskExclusionsRecommendations

define ExistsSpecialPopulationsRecommendations:
  exists SpecialPopulationsRecommendations

define ExistsAverageRiskRecommendations:
  exists AverageRiskRecommendations    

//------------------------------------------------------------------------------
// DYNAMIC VALUES HIGH RISK EXCLUSIONS
//------------------------------------------------------------------------------   

define ExistsSpecialtyReferralGeneticRisk:  
  HighRiskExclusions."ExistsSpecialtyReferralGeneticRisk"

define SpecialtyReferralGeneticRiskCode:
  HighRiskExclusions."SpecialtyReferralGeneticRiskCode"  

define SpecialtyReferralGeneticRiskReason:
  HighRiskExclusions."SpecialtyReferralGeneticRiskReason"

define ExistsACSGeneticRiskMammo:
  HighRiskExclusions."ExistsACSGeneticRiskMammo"

define ACSGeneticRiskMammoCode:    
  HighRiskExclusions."ACSGeneticRiskMammoCode"

define ACSGeneticRiskMammoReason:
  HighRiskExclusions."ACSGeneticRiskMammoReason"

define ACSGeneticRiskMammoTiming:    
  HighRiskExclusions."ACSGeneticRiskMammoTiming"

define ACSGeneticRiskMammoTimingEvent:    
  HighRiskExclusions."ACSGeneticRiskMammoTimingEvent"

define ACSGeneticRiskMammoFlag:  
  HighRiskExclusions."ACSGeneticRiskMammoFlag"

define ExistsACSGeneticRiskMri:
  HighRiskExclusions."ExistsACSGeneticRiskMri"

define ACSGeneticRiskMriCode:    
  HighRiskExclusions."ACSGeneticRiskMriCode"

define ACSGeneticRiskMriReason:  
  HighRiskExclusions."ACSGeneticRiskMriReason"

define ACSGeneticRiskMriTiming:    
  HighRiskExclusions."ACSGeneticRiskMriTiming"

define ACSGeneticRiskMriTimingEvent:    
  HighRiskExclusions."ACSGeneticRiskMriTimingEvent"

define ACSGeneticRiskMriFlag:  
  HighRiskExclusions."ACSGeneticRiskMriFlag"

define ExistsACSMammoAfterRT:
  HighRiskExclusions."ExistsACSMammoAfterRT"

define ACSMammoAfterRTCode:    
  HighRiskExclusions."ACSMammoAfterRTCode"

define ACSMammoAfterRTReason:  
  HighRiskExclusions."ACSMammoAfterRTReason"

define ACSMammoAfterRTTiming:    
  HighRiskExclusions."ACSMammoAfterRTTiming"

define ACSMammoAfterRTTimingEvent:    
  HighRiskExclusions."ACSMammoAfterRTTimingEvent"

define ACSMammoAfterRTFlag:  
  HighRiskExclusions."ACSMammoAfterRTFlag"

define ExistsACSMriAfterRT:
  HighRiskExclusions."ExistsACSMriAfterRT"

define ACSMriAfterRTCode:    
  HighRiskExclusions."ACSMriAfterRTCode"

define ACSMriAfterRTReason:    
  HighRiskExclusions."ACSMriAfterRTReason"

define ACSMriAfterRTTiming:    
  HighRiskExclusions."ACSMriAfterRTTiming"

define ACSMriAfterRTTimingEvent:    
  HighRiskExclusions."ACSMriAfterRTTimingEvent"

define ACSMriAfterRTFlag:  
  HighRiskExclusions."ACSMriAfterRTFlag"

define ExistsACSMammoAfterBrca:
  HighRiskExclusions."ExistsACSMammoAfterBrca"

define ACSMammoAfterBrcaCode:    
  HighRiskExclusions."ACSMammoAfterBrcaCode"

define ACSMammoAfterBrcaReason:    
  HighRiskExclusions."ACSMammoAfterBrcaReason"

define ACSMammoAfterBrcaTiming:    
  HighRiskExclusions."ACSMammoAfterBrcaTiming"

define ACSMammoAfterBrcaTimingEvent:    
  HighRiskExclusions."ACSMammoAfterBrcaTimingEvent"

define ACSMammoAfterBrcaFlag:
  HighRiskExclusions."ACSMammoAfterBrcaFlag"  

define ExistsSpecialtyReferralBreastCaWithin5y:  
  HighRiskExclusions."ExistsSpecialtyReferralBreastCaWithin5y"

define SpecialtyReferralBreastCaWithin5yCode:
  HighRiskExclusions."SpecialtyReferralBreastCaWithin5yCode"

define SpecialtyReferralBreastCaWithin5yReason:
  HighRiskExclusions."SpecialtyReferralBreastCaWithin5yReason"

define ExistsACSMammoAtypicalBiopsy:
  HighRiskExclusions."ExistsACSMammoAtypicalBiopsy"

define ACSMammoAtypicalBiopsyCode:    
  HighRiskExclusions."ACSMammoAtypicalBiopsyCode"

define ACSMammoAtypicalBiopsyReason:    
  HighRiskExclusions."ACSMammoAtypicalBiopsyReason"

define ACSMammoAtypicalBiopsyTiming:    
  HighRiskExclusions."ACSMammoAtypicalBiopsyTiming"

define ACSMammoAtypicalBiopsyTimingEvent:    
  HighRiskExclusions."ACSMammoAtypicalBiopsyTimingEvent"

define ACSMammoAtypicalBiopsyFlag:  
  HighRiskExclusions."ACSMammoAtypicalBiopsyFlag"  

define ExistsACSAtypicalBiopsy:
  HighRiskExclusions."ExistsACSAtypicalBiopsy"

define ACSAtypicalBiopsyCode:    
  HighRiskExclusions."ACSAtypicalBiopsyCode"

define ACSAtypicalBiopsyReason:    
  HighRiskExclusions."ACSAtypicalBiopsyReason"

define ExistsACSMriAtypicalBiopsyHighRisk:
  HighRiskExclusions."ExistsACSMriAtypicalBiopsyHighRisk"

define ACSMriAtypicalBiopsyHighRiskCode:    
  HighRiskExclusions."ACSMriAtypicalBiopsyHighRiskCode"

define ACSMriAtypicalBiopsyHighRiskReason:    
  HighRiskExclusions."ACSMriAtypicalBiopsyHighRiskReason"

define ACSMriAtypicalBiopsyHighRiskTiming:    
  HighRiskExclusions."ACSMriAtypicalBiopsyHighRiskTiming"

define ACSMriAtypicalBiopsyHighRiskTimingEvent:    
  HighRiskExclusions."ACSMriAtypicalBiopsyHighRiskTimingEvent"

define ACSMriAtypicalBiopsyHighRiskFlag:  
  HighRiskExclusions."ACSMriAtypicalBiopsyHighRiskFlag"  

//------------------------------------------------------------------------------
// DYNAMIC VALUES SPECIAL POPULATIONS
//------------------------------------------------------------------------------  

define ExistsACSMammoHighRisk:
  SpecialPopulations.ExistsACSMammoHighRisk

define ACSMammoHighRiskCode:    
  SpecialPopulations.ACSMammoHighRiskCode

define ACSMammoHighRiskReason:    
  SpecialPopulations.ACSMammoHighRiskReason

define ACSMammoHighRiskTiming:    
  SpecialPopulations.ACSMammoHighRiskTiming

define ACSMammoHighRiskTimingEvent:    
  SpecialPopulations.ACSMammoHighRiskTimingEvent

define ACSMammoHighRiskFlag:  
  SpecialPopulations.ACSMammoHighRiskFlag

define ExistsACSMriHighRisk:
  SpecialPopulations.ExistsACSMriHighRisk

define ACSMriHighRiskCode:    
  SpecialPopulations.ACSMriHighRiskCode

define ACSMriHighRiskReason:    
  SpecialPopulations.ACSMriHighRiskReason

define ACSMriHighRiskTiming:    
  SpecialPopulations.ACSMriHighRiskTiming

define ACSMriHighRiskTimingEvent:    
  SpecialPopulations.ACSMriHighRiskTimingEvent

define ACSMriHighRiskFlag:  
  SpecialPopulations.ACSMriHighRiskFlag  

define ExistsACSFirstDegGeneticMammo:
  SpecialPopulations.ExistsACSFirstDegGeneticMammo

define ACSFirstDegGeneticMammoCode:    
  SpecialPopulations.ACSFirstDegGeneticMammoCode

define ACSFirstDegGeneticMammoReason:    
  SpecialPopulations.ACSFirstDegGeneticMammoReason

define ACSFirstDegGeneticMammoTiming:    
  SpecialPopulations.ACSFirstDegGeneticMammoTiming

define ACSFirstDegGeneticMammoTimingEvent:    
  SpecialPopulations.ACSFirstDegGeneticMammoTimingEvent

define ACSFirstDegGeneticMammoFlag:  
  SpecialPopulations.ACSFirstDegGeneticMammoFlag  

define ExistsACSFirstDegGeneticMri:
  SpecialPopulations.ExistsACSFirstDegGeneticMri

define ACSFirstDegGeneticMriCode:    
  SpecialPopulations.ACSFirstDegGeneticMriCode

define ACSFirstDegGeneticMriReason:    
  SpecialPopulations.ACSFirstDegGeneticMriReason

define ACSFirstDegGeneticMriTiming:    
  SpecialPopulations.ACSFirstDegGeneticMriTiming

define ACSFirstDegGeneticMriTimingEvent:    
  SpecialPopulations.ACSFirstDegGeneticMriTimingEvent

define ACSFirstDegGeneticMriFlag:  
  SpecialPopulations.ACSFirstDegGeneticMriFlag  

define ExistsBreastImagingHeterogenouslyOrExtremelyDense:
  SpecialPopulations.ExistsBreastImagingHeterogenouslyOrExtremelyDense

define BreastImagingHeterogenouslyOrExtremelyDenseCode:
  SpecialPopulations.BreastImagingHeterogenouslyOrExtremelyDenseCode

define BreastImagingHeterogenouslyOrExtremelyDenseReason:
  SpecialPopulations.BreastImagingHeterogenouslyOrExtremelyDenseReason

define ExistsCompellingFamilyHistory:
  SpecialPopulations.ExistsCompellingFamilyHistory

define CompellingFamilyHistoryCode:
  SpecialPopulations.CompellingFamilyHistoryCode

define CompellingFamilyHistoryReason:
  SpecialPopulations.CompellingFamilyHistoryReason

define ExistsUSPSTFRecommendation:
  SpecialPopulations.ExistsUSPSTFRecommendation

define USPSTFRecommendationCode:    
  SpecialPopulations.USPSTFRecommendationCode

define USPSTFRecommendationReason:    
  SpecialPopulations.USPSTFRecommendationReason

define USPSTFRecommendationTiming:    
  SpecialPopulations.USPSTFRecommendationTiming

define USPSTFRecommendationTimingEvent:    
  SpecialPopulations.USPSTFRecommendationTimingEvent

define USPSTFRecommendationFlag:  
  SpecialPopulations.USPSTFRecommendationFlag  

//------------------------------------------------------------------------------
// DYNAMIC VALUES AVERAGE RISK
//------------------------------------------------------------------------------    

define ExistsACSMammoAvgRiskAgeUnder45:
  AverageRisk.ExistsACSMammoAvgRiskAgeUnder45

define ACSMammoAvgRiskAgeUnder45Code:    
  AverageRisk.ACSMammoAvgRiskAgeUnder45Code

define ACSMammoAvgRiskAgeUnder45Reason:
  AverageRisk.ACSMammoAvgRiskAgeUnder45Reason

define ACSMammoAvgRiskAgeUnder45Timing:    
  AverageRisk.ACSMammoAvgRiskAgeUnder45Timing

define ACSMammoAvgRiskAgeUnder45TimingEvent:    
  AverageRisk.ACSMammoAvgRiskAgeUnder45TimingEvent

define ACSMammoAvgRiskAgeUnder45Flag:
  AverageRisk.ACSMammoAvgRiskAgeUnder45Flag  

define ExistsACSMammoAvgRiskAge45to54:
  AverageRisk.ExistsACSMammoAvgRiskAge45to54

define ACSMammoAvgRiskAge45to54Code:    
  AverageRisk.ACSMammoAvgRiskAge45to54Code

define ACSMammoAvgRiskAge45to54Reason:
  AverageRisk.ACSMammoAvgRiskAge45to54Reason

define ACSMammoAvgRiskAge45to54Timing:    
  AverageRisk.ACSMammoAvgRiskAge45to54Timing

define ACSMammoAvgRiskAge45to54TimingEvent:    
  AverageRisk.ACSMammoAvgRiskAge45to54TimingEvent

define ACSMammoAvgRiskAge45to54Flag:
  AverageRisk.ACSMammoAvgRiskAge45to54Flag   

define ExistsACSMammoAvgRiskAgeOver54:
  AverageRisk.ExistsACSMammoAvgRiskAgeOver54

define ACSMammoAvgRiskAgeOver54Code:    
  AverageRisk.ACSMammoAvgRiskAgeOver54Code

define ACSMammoAvgRiskAgeOver54Reason:
  AverageRisk.ACSMammoAvgRiskAgeOver54Reason

define ACSMammoAvgRiskAgeOver54Timing:    
  AverageRisk.ACSMammoAvgRiskAgeOver54Timing

define ACSMammoAvgRiskAgeOver54TimingEvent:    
  AverageRisk.ACSMammoAvgRiskAgeOver54TimingEvent

define ACSMammoAvgRiskAgeOver54Flag:
  AverageRisk.ACSMammoAvgRiskAgeOver54Flag    

define ExistsUSPSTFAvgRisk:
  AverageRisk.ExistsUSPSTFAvgRisk

define USPSTFAvgRiskCode:    
  AverageRisk.USPSTFAvgRiskCode

define USPSTFAvgRiskReason:
  AverageRisk.USPSTFAvgRiskReason

define USPSTFAvgRiskTiming:    
  AverageRisk.USPSTFAvgRiskTiming

define USPSTFAvgRiskTimingEvent:    
  AverageRisk.USPSTFAvgRiskTimingEvent

define USPSTFAvgRiskFlag:
  AverageRisk.USPSTFAvgRiskFlag

