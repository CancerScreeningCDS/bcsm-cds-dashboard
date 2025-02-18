library FollowupScreeningResultEvents version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include DataElements version '1.0.0' called DataElements
include CSMCommonFunctions version '1.0.0' called CSMCommonFunctions
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "BiopsyResultCS": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/biopsy-result-observation-code-system'

code "Category0": '397138000' from "SNOMED-CT" display 'Mammography assessment (Category 0) - Need additional imaging evaluation (finding)'
code "Category1": '397140005' from "SNOMED-CT" display 'Mammography assessment (Category 1) - Negative (finding)'
code "Category2": '397141009' from "SNOMED-CT" display 'Mammography assessment (Category 2) - Benign finding (finding)'
code "Category3": '397143007' from "SNOMED-CT" display 'Mammography assessment (Category 3) - Probably benign finding, short interval follow-up (finding)'
code "Category4": '397144001' from "SNOMED-CT" display 'Mammography assessment (Category 4) - Suspicious abnormality, biopsy should be considered (finding)'
code "Category4A": '6121000179106' from "SNOMED-CT" display 'Mammography assessment (Category 4A) - Suspicious abnormality, biopsy should be considered, low suspicion of malignancy (finding)'
code "Category4B": '6131000179108' from "SNOMED-CT" display 'Mammography assessment (Category 4B) - Suspicious abnormality, biopsy should be considered, moderate suspicion of malignancy (finding)'
code "Category4C": '6141000179100' from "SNOMED-CT" display 'Mammography assessment (Category 4C) - Suspicious abnormality, biopsy should be considered, high suspicion of malignancy (finding)'
code "Category5": '397145000' from "SNOMED-CT" display 'Mammography assessment (Category 5) - Highly suggestive of malignancy (finding)'
code "Category6": '6111000179101' from "SNOMED-CT" display 'Mammography assessment (Category 6) - known biopsy, proven malignancy (finding)'
code "Negative": 'Negative' from BiopsyResultCS display 'Normal breast tissue'
code "Benign": 'Benign' from BiopsyResultCS display 'Benign breast finding'
code "Atypical": 'Atypical' from BiopsyResultCS display 'Atypical breast finding'
code "Malignant": 'Malignant' from BiopsyResultCS display 'Malignant breast finding'
code "Indeterminate": 'Indeterminate' from BiopsyResultCS display 'Indeterminate breast finding'
code "Discordant": 'Discordant' from BiopsyResultCS display 'Discordant breast finding'
code "Other": 'Other' from BiopsyResultCS display 'Other breast finding'

context Patient

define "eve-latesttest":
  LatestTest

define "eve-actionablebirads":
  LatestTest.result !~ "Category1" and 
    LatestTest.result !~ "Category2"

define "eve-biradsscore":
  MostRecentBreastImagingBiradsResult

define "eve-biopsyresult":
  MostRecentBreastBiopsyResult

define LatestTest:
  case
    when MostRecentBreastImagingDate is null and MostRecentBreastBiopsyDate is null 
      then null
    when MostRecentBreastBiopsyDate is null 
        or (MostRecentBreastImagingDate is not null and MostRecentBreastImagingDate after MostRecentBreastBiopsyDate) 
      then {
        type: 'imaging',
        date: MostRecentBreastImagingDate,
        result: MostRecentBreastImagingBiradsResult
      }
    else {
      type: 'biopsy',
      date: MostRecentBreastBiopsyDate,
      result: MostRecentBreastBiopsyResult
    }
  end    

define MostRecentBreastImagingDate:
  CSMCommonFunctions.DiagnosticReportDate(DataElements.MostRecentBreastImagingDiagnosticReport) 

define MostRecentBreastBiopsyDate:
  CSMCommonFunctions.DiagnosticReportDate(DataElements.MostRecentBreastBiopsyDiagnosticReport)

define MostRecentBreastImagingBiradsResult:
  BreastImagingBiradsResult(DataElements.MostRecentBreastImagingDiagnosticReport)

define MostRecentBreastBiopsyResult:
  BreastBiopsyResult(DataElements.MostRecentBreastBiopsyDiagnosticReport)  

//------------------------------------------------------------------------------
// Functions
//------------------------------------------------------------------------------ 

define function BreastImagingBiradsResult(report DiagnosticReport):
  report D
    let cC: BCSMCommon.CollateConclusionCodes(D,DataElements.BreastImagingObservations)
    return First(
      cC.coding C
        let c: FHIRHelpers.ToCode(C)
        where 
          c ~ "Category0"
          or c ~"Category1"
          or c ~ "Category2"
          or c ~ "Category3"
          or c ~ "Category4"     
          or c ~ "Category4A"
          or c ~ "Category4B"
          or c ~ "Category4C"
          or c ~ "Category5"
          or c ~ "Category6"
        return c  
    ) 

define function BreastBiopsyResult(report DiagnosticReport):
  report D
    let cC: BCSMCommon.CollateConclusionCodes(D,DataElements.BiopsyObservations)
    return First(
      cC.coding C
        let c: FHIRHelpers.ToCode(C)
        where //order by risk
          c ~ "Malignant"     
          or c ~ "Indeterminate"
          or c ~ "Discordant"                  
          or c ~ "Atypical"        
          or c ~ "Benign"
          or c ~ "Negative"
          or c ~ "Other" 
        return c  
    )  
