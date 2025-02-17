library FollowupScreeningResult version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include FollowupScreeningResultEvents version '1.0.0' called Events
include FollowupScreeningResultActions version '1.0.0' called Actions
include DataElements version '1.0.0' called DataElements
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

context Patient

//------------------------------------------------------------------------------
// RECOMMENDATIONS
//------------------------------------------------------------------------------

define "flow-FollowupScreeningResult":
  if Errors then {}
  else
    {    
      FollowupBirads0Result,
      FollowupBirads3Result,
      FollowupBirads4Or5Result,
      FollowupBenignBiopsyResult,
      FollowupAtypicalBiopsyResult,
      FollowupMalignantBiopsyResult,
      FollowupIndeterminateBiopsyResult,
      FollowupDiscordantBiopsyResult
    }   
    except { null }

define FollowupBirads0Result:
  if Events."eve-latesttest".result ~ Events."Category0"
  then Actions."act-incompletescreen"
  else null 

define FollowupBirads3Result:
  if Events."eve-latesttest".result ~ Events."Category3"
  then Actions."act-intervalscreen"
  else null 

define FollowupBirads4Or5Result:
  if Events."eve-latesttest".result ~ Events."Category4" or
    Events."eve-latesttest".result ~ Events."Category4A" or
    Events."eve-latesttest".result ~ Events."Category4B" or
    Events."eve-latesttest".result ~ Events."Category4C"
  then Actions."act-biopsy4"
  else if Events."eve-latesttest".result ~ Events."Category5"
  then Actions."act-biopsy5"
  else null  

define FollowupBenignBiopsyResult:
  if Events."eve-latesttest".result ~ Events."Benign"
  then Actions."act-benignbiopsy"
  else null 

define FollowupAtypicalBiopsyResult:
  if Events."eve-latesttest".result ~ Events."Atypical"
  then Actions."act-highriskreferral"
  else null 

define FollowupMalignantBiopsyResult:
  if Events."eve-latesttest".result ~ Events."Malignant"
  then Actions."act-oncreferral"
  else null 

define FollowupIndeterminateBiopsyResult:
  if Events."eve-latesttest".result ~ Events."Indeterminate"
  then Actions."act-indeterminatebiopsy"
  else null 

define FollowupDiscordantBiopsyResult:
  if Events."eve-latesttest".result ~ Events."Discordant"
  then Actions."act-discordantbiopsy"
  else null   

//------------------------------------------------------------------------------
// ERRORS
//------------------------------------------------------------------------------     

define Errors:
  ErrorBreastBiopsyWithNoConclusionCodes or
    ErrorBreastImagingWithNoConclusionCodes or
    ErrorDiagnosticReportWithUnsupportedConclusionCode

define NoErrorsHaveOccurred:
  not Errors

define ErrorBreastBiopsyWithNoConclusionCodes:
  Events."eve-latesttest".type = 'biopsy' and 
  Message(DataElements.MostRecentBreastBiopsyDiagnosticReportNoConclusionCodes, 
    DataElements.MostRecentBreastBiopsyDiagnosticReportNoConclusionCodes,
    'http://example.org/CodeSystem/plan-definition-action-reason-code-system/missingresultcode',
    'Warning', 
    'A laboratory test was found without a result. Please review patient record to resolve.')  

define ErrorBreastImagingWithNoConclusionCodes:
  Events."eve-latesttest".type = 'imaging' and 
    Message(DataElements.MostRecentBreastImagingDiagnosticReportNoConclusionCodes, 
    DataElements.MostRecentBreastImagingDiagnosticReportNoConclusionCodes,
    'http://example.org/CodeSystem/plan-definition-action-reason-code-system/missingresultcode',
    'Warning', 
    'An imaging test was found without a result. Please review patient record to resolve.')      

define ErrorDiagnosticReportWithUnsupportedConclusionCode:  
  Message(Events."eve-latesttest".result is null, 
    Events."eve-latesttest".result is null,
    'http://example.org/CodeSystem/plan-definition-action-reason-code-system/unknownresultcode',
    'Warning', 
    'A laboratory test was found with an unexpected result code. Please review patient record to resolve.')   

//------------------------------------------------------------------------------
// DYNAMIC VALUES
//------------------------------------------------------------------------------    

define ExistsFollowupBirads0Result:
  FollowupBirads0Result is not null

define FollowupBirads0ResultCode:    
  FollowupBirads0Result R return R.code

define FollowupBirads0ResultReason:  
  FollowupBirads0Result R return R.reason

define FollowupBirads0ResultTiming:    
  FollowupBirads0Result R return R.timingTiming

define FollowupBirads0ResultTimingEvent:    
  FollowupBirads0ResultTiming R return First(R.event)

define FollowupBirads0ResultFlag:
  FollowupBirads0Result R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)  

define ExistsFollowupBirads3Result:
  FollowupBirads3Result is not null

define FollowupBirads3ResultCode:    
  FollowupBirads3Result R return R.code

define FollowupBirads3ResultReason:  
  FollowupBirads3Result R return R.reason

define FollowupBirads3ResultTiming:    
  FollowupBirads3Result R return R.timingTiming

define FollowupBirads3ResultTimingEvent:    
  FollowupBirads3ResultTiming R return First(R.event)

define FollowupBirads3ResultFlag:
  FollowupBirads3Result R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)

define ExistsFollowupBirads4Or5Result:
  FollowupBirads4Or5Result is not null

define FollowupBirads4Or5ResultCode:    
  FollowupBirads4Or5Result R return R.code

define FollowupBirads4Or5ResultReason:  
  FollowupBirads4Or5Result R return R.reason

define FollowupBirads4Or5ResultTiming:    
  FollowupBirads4Or5Result R return R.timingTiming

define FollowupBirads4Or5ResultTimingEvent:    
  FollowupBirads4Or5ResultTiming R return First(R.event)

define FollowupBirads4Or5ResultFlag:
  FollowupBirads4Or5Result R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)

define ExistsFollowupBenignBiopsyResult:
  FollowupBenignBiopsyResult is not null

define FollowupBenignBiopsyResultCode:    
  FollowupBenignBiopsyResult R return R.code

define FollowupBenignBiopsyResultReason:  
  FollowupBenignBiopsyResult R return R.reason

define FollowupBenignBiopsyResultTiming:    
  FollowupBenignBiopsyResult R return R.timingTiming

define FollowupBenignBiopsyResultTimingEvent:    
  FollowupBenignBiopsyResultTiming R return First(R.event)

define FollowupBenignBiopsyResultFlag:
  FollowupBenignBiopsyResult R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)

define ExistsFollowupAtypicalBiopsyResult:
  FollowupAtypicalBiopsyResult is not null

define FollowupAtypicalBiopsyResultCode:    
  FollowupAtypicalBiopsyResult R return R.code

define FollowupAtypicalBiopsyResultReason:  
  FollowupAtypicalBiopsyResult R return R.reason

define FollowupAtypicalBiopsyResultTiming:    
  FollowupAtypicalBiopsyResult R return R.timingTiming

define FollowupAtypicalBiopsyResultTimingEvent:    
  FollowupAtypicalBiopsyResultTiming R return First(R.event)

define FollowupAtypicalBiopsyResultFlag:
  FollowupAtypicalBiopsyResult R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)

define ExistsFollowupMalignantBiopsyResult:
  FollowupMalignantBiopsyResult is not null

define FollowupMalignantBiopsyResultCode:    
  FollowupMalignantBiopsyResult R return R.code

define FollowupMalignantBiopsyResultReason:  
  FollowupMalignantBiopsyResult R return R.reason

define FollowupMalignantBiopsyResultTiming:    
  FollowupMalignantBiopsyResult R return R.timingTiming

define FollowupMalignantBiopsyResultTimingEvent:    
  FollowupMalignantBiopsyResultTiming R return First(R.event)

define FollowupMalignantBiopsyResultFlag:
  FollowupMalignantBiopsyResult R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)

define ExistsFollowupIndeterminateBiopsyResult:
  FollowupIndeterminateBiopsyResult is not null

define FollowupIndeterminateBiopsyResultCode:    
  FollowupIndeterminateBiopsyResult R return R.code

define FollowupIndeterminateBiopsyResultReason:  
  FollowupIndeterminateBiopsyResult R return R.reason

define FollowupIndeterminateBiopsyResultTiming:    
  FollowupIndeterminateBiopsyResult R return R.timingTiming

define FollowupIndeterminateBiopsyResultTimingEvent:    
  FollowupIndeterminateBiopsyResultTiming R return First(R.event)

define FollowupIndeterminateBiopsyResultFlag:
  FollowupIndeterminateBiopsyResult R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)

define ExistsFollowupDiscordantBiopsyResult:
  FollowupDiscordantBiopsyResult is not null

define FollowupDiscordantBiopsyResultCode:    
  FollowupDiscordantBiopsyResult R return R.code

define FollowupDiscordantBiopsyResultReason:  
  FollowupDiscordantBiopsyResult R return R.reason

define FollowupDiscordantBiopsyResultTiming:    
  FollowupDiscordantBiopsyResult R return R.timingTiming

define FollowupDiscordantBiopsyResultTimingEvent:    
  FollowupDiscordantBiopsyResultTiming R return First(R.event)

define FollowupDiscordantBiopsyResultFlag:
  FollowupDiscordantBiopsyResult R return BCSMCommon.CreateRecommendationFlagExtension(R.flag)


