library DataElements version '1.0.0'

using FHIR version '4.0.1'

include CDSConnectCommonsforFHIRv401 version '1.0.0' called C3F
include CSMCommonFunctions version '1.0.0' called Common
include BCSMCommonFunctions version '1.0.0' called BCSMCommon
include FHIRHelpers  version '4.0.1' called FHIRHelpers
include Hospice version '1.0.0' 

//------------------------------------------------------------------------------
// CODE SYSTEMS, VALUE SETS, AND CODES
//------------------------------------------------------------------------------

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "RXNORM": 'http://www.nlm.nih.gov/research/umls/rxnorm'
codesystem "ICD-9": 'http://hl7.org/fhir/sid/icd-9-cm'
codesystem "ICD-10": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "GENDER-IDENTITY": 'http://hl7.org/fhir/gender-identity'
codesystem "CONDCLINSTATUS": 'http://terminology.hl7.org/CodeSystem/condition-clinical'
codesystem "AdministrativeGender": 'http://hl7.org/fhir/administrative-gender'
codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'
codesystem "ActCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system'
codesystem "BiopsyResultCS": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/biopsy-result-observation-code-system'

code "Condition inactive code": 'inactive' from "CONDCLINSTATUS" display 'Inactive'
code "Condition remission code": 'remission' from "CONDCLINSTATUS" display 'Remission'
code "Condition resolved code": 'resolved' from "CONDCLINSTATUS" display 'Resolved'

concept "Condition inactive": { "Condition inactive code" } display 'Inactive'
concept "Condition remission": { "Condition remission code" } display 'Remission'
concept "Condition resolved": { "Condition resolved code" } display 'Resolved'

// Pregnancy
valueset "Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.378'
valueset "Pregnancy (New ICD10 codes published in 2018 and 2020)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.80'
// Breast diagnoses, procedures, and observations
valueset "INVASIVE BREAST CANCER": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1116.185'
// TODO: replace placeholder value set OID
valueset "NON-INVASIVE BREAST CANCER": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.1240.2017.3.2.1022'
valueset "BILATERAL MASTECTOMY": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1068'
valueset "LEFT UNILATERAL MASTECTOMY": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1069'
valueset "RIGHT UNILATERAL MASTECTOMY": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1070'
valueset "UNILATERAL MASTECTOMY": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1071'
valueset "BILATERAL MASTECTOMY PROCEDURE": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1005'
valueset "LEFT UNILATERAL MASTECTOMY PROCEDURE": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1133'
valueset "RIGHT UNILATERAL MASTECTOMY PROCEDURE": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1134'
// TODO: replace placeholder value set OID
valueset "BRCA1 Gene Mutation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.1444.3.203'
// TODO: replace placeholder value set OID
valueset "BRCA2 Gene Mutation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.1444.3.204'
// TODO: replace placeholder value set OID
valueset "Li-Fraumeni Syndrome": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.1240.2017.3.2.1022'
// TODO: replace placeholder value set OID
valueset "Cowden Syndrome": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.1240.2017.3.2.1022'
// TODO: replace placeholder value set OID
valueset "Bannayan-Riley-Ruvalcaba Syndrome": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.1240.2017.3.2.1022'
// TODO: replace placeholder value set OID
valueset "Biopsy Atypical Results": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.235' 
valueset "OVARIAN CANCER": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.1444.5.232'
// TODO: replace placeholder value set OID
valueset "TUBAL CANCER": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.235'
// TODO: replace placeholder value set OID
valueset "PERITONEAL CANCER": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.235'
// TODO: replace placeholder value set OID
valueset "BREAST SYMPTOMS": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.73'
valueset "FIRST DEGREE FAMILY MEMBER": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.92'
// TODO: replace placeholder value set OID
valueset "SECOND DEGREE FAMILY MEMBER": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.92'
valueset "MAMMOGRAPHY": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1018'
// TODO: replace placeholder with OID
// TODO: should include biopsy (FNA, core needle, incisional, excisional), this VS is sugical only
valueset "BREAST CANCER BIOPSY ORDERS": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1206.66'
// TODO: should include screening and diagnostic imaging, this value set is mammography only
valueset "BREAST CANCER IMAGING ORDERS": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1018'
// TODO: replace placeholder value set OID
valueset "GENETIC COUNSELING": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.235' 

// Standard codes
code "Male": 'male' from "AdministrativeGender" display 'Male'
code "Gender Identity": '76691-5' from "LOINC" display 'Gender identity'
code "Transgender Male Code": 'transgender-male' from "GENDER-IDENTITY" display 'transgender male'
code "Transgender Female Code": 'transgender-female' from "GENDER-IDENTITY" display 'transgender female'
code "Female-to-male Transsexual": '407377005' from "SNOMED-CT" display 'Female-to-male transsexual (finding)'
code "Male-to-female Transsexual": '407376001' from "SNOMED-CT" display 'Male-to-female transsexual (finding)'
code "Left (qualifier value)": '7771000' from "SNOMED-CT" display 'Left (qualifier value)'
code "Right (qualifier value)": '24028007' from "SNOMED-CT" display 'Right (qualifier value)'
code "History of radiation therapy to chest": '77941000119104' from "SNOMED-CT" display 'History of radiation therapy to chest'
code "Breast Pathology biopsy report": '66110-8' from "LOINC" display 'Breast Pathology biopsy report'
code "Breast Imaging Report": '10193-1' from "LOINC" display 'Physical findings of Breasts Narrative'
code "Heterogeneously dense": '129718006' from "SNOMED-CT" display 'Heterogeneously dense breast composition'
code "Extremely dense": '129719003' from "SNOMED-CT" display 'Extremely dense breast composition'
code "Pregnancy Status": '82810-3' from "LOINC" display 'Pregnancy status'
code "Patient currently pregnant": '77386006' from "SNOMED-CT" display 'Patient currently pregnant (finding)'
code "Pregnancy Episode Of Care": '424525001' from "SNOMED-CT" display 'Antenatal care (regime/therapy)'

// Non-standard codes
code "New or worsening breast symptoms": 'BreastSymptoms' from "LOCAL" display 'New or worsening breast symptoms'
code "New or worsening breast exam findings": 'BreastFindings' from "LOCAL" display 'New or worsening breast exam findings'
code "Reduced life expectancy indicator": 'lifeexp' from "LOCAL" display 'Reduced life expectancy indicator'
code "Currently lactating": 'currentlylactating' from "LOCAL" display 'Currently lactating'
code "Genetic marker or syndrome associated with breast cancer": 'GeneticMarkerOrSyndrome' from "LOCAL" display 'Genetic marker or syndrome associated with breast cancer'
code "History of chest radiation ages 10-30 y": 'chestxrt' from "LOCAL" display 'History of chest radiation ages 10-30 y'
code "Lifetime risk assessment": 'lifetimeriskassessment' from "ActCode" display 'Lifetime risk assessment'
code "High lifetime risk": 'highlifetimerisk' from "LOCAL" display 'High lifetime risk'
code "First degree relative with genetic marker or syndrome": 'firstdeggenetic' from "LOCAL" display 'First degree relative with genetic marker or syndrome'
code "Family history of inherited cancer susceptibility": 'fhxgenetic' from "LOCAL" display 'Family history of inherited cancer susceptibility'
code "Ancestry associated with BRCA1/2 gene mutations": 'brcageneancestry' from "LOCAL" display 'Ancestry associated with BRCA1/2 gene mutations'
code "Familial risk assessment": 'familialriskassessment' from "ActCode" display 'Familial risk assessment'
code "Brief familial risk assessment tool": 'fhxrisktool' from "ActCode" display 'Brief familial risk assessment tool'
code "Informal familial risk assessment": 'fhxriskassess' from "ActCode" display 'Informal familial risk assessment'
code "High familial risk": 'highfamilialrisk' from "LOCAL" display 'High familial risk'
code "Known breast cancer variant status": 'KnownVariantStatus' from "LOCAL" display 'Known breast cancer variant status'
code "Family history of breast, ovarian, tubal, or peritoneal cancer": 'fhxbrcaovcatubalperit' from "LOCAL" display 'Family history of breast, ovarian, tubal, or peritoneal cancer'
code "5 year risk assessment": '5yriskassessment' from "ActCode" display '5 year risk assessment'
code "Personal risk factors conferring increased risk of breast cancer": 'PersonalRiskFactors' from "LOCAL" display 'Personal risk factors conferring increased risk of breast cancer'
code "Atypical": 'Atypical' from BiopsyResultCS display 'Atypical breast finding'

//------------------------------------------------------------------------------
// PARAMETERS
//------------------------------------------------------------------------------

parameter encounter String default null
parameter ObservationLookbackPeriod default 14 days
parameter SymptomaticLookBack default 1 days

/***** BEGIN CDS LOGIC ********************************************************/

context Patient   

//------------------------------------------------------------------------------
// Assigned female at birth
//------------------------------------------------------------------------------

define "de-female":
  Female or TransgenderMale
    
define BirthSex:
  (Patient.extension) E
    where E.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex'

define BirthSexPresent:
  Exists(BirthSex)

define FemaleBirthSex:
  Exists(
    (BirthSex) E
      where E.value = 'F'
  )

define UnknownBirthSex:
  exists(
    (BirthSex) E
      where (
        E.value = 'ASKU' or
        E.value = 'OTH' or
        E.value = 'UNK'
      )
  )

define BirthSexMissingOrUnknown:
  not BirthSexPresent or
  UnknownBirthSex

define BirthSexCode:
  if BirthSexMissingOrUnknown then 'Unknown'
  else Coalesce(BirthSex.value.value)

define FemaleGender:
  Patient.gender.value = 'female'

define Female:
  FemaleBirthSex or
  (BirthSexMissingOrUnknown and FemaleGender)

define GenderIdentityExtension:
  (Patient.extension) E
    where
      E.url = 'http://hl7.org/fhir/StructureDefinition/patient-genderIdentity' or
      E.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-genderIdentity'

define TransgenderMaleExtension:
  (GenderIdentityExtension) E
    where
      E.value as FHIR.CodeableConcept ~ "Transgender Male Code" or
      E.value as FHIR.CodeableConcept ~ "Female-to-male Transsexual"

define TransgenderFemaleExtension:
  (GenderIdentityExtension) E
    where
      E.value as FHIR.CodeableConcept ~ "Transgender Female Code" or
      E.value as FHIR.CodeableConcept ~ "Male-to-female Transsexual"      

define GenderIdentityObservation:
  [Observation: "Gender Identity"]

define TransgenderMaleObservation:
  (GenderIdentityObservation) O
  where O.value as FHIR.CodeableConcept ~ "Transgender Male Code"
  or O.value as FHIR.CodeableConcept ~ "Female-to-male Transsexual"

define TransgenderFemaleObservation:
  (GenderIdentityObservation) O
    where O.value as FHIR.CodeableConcept ~ "Transgender Female Code"
    or O.value as FHIR.CodeableConcept ~ "Male-to-female Transsexual"    

define TransgenderMale:
  Exists(TransgenderMaleExtension) or Exists(TransgenderMaleObservation)

define TransgenderFemale:
  Exists(TransgenderFemaleExtension) or Exists(TransgenderFemaleObservation)  

define FemaleorTransgenderMale:
  Female or TransgenderMale

//------------------------------------------------------------------------------
// Current breast cancer
//------------------------------------------------------------------------------

define "de-breastca":
  exists BreastCancerDiagnoses C
    where C.clinicalStatus !~ "Condition inactive"
      and C.clinicalStatus !~ "Condition remission"
      and C.clinicalStatus !~ "Condition resolved"

define BreastCancerDiagnoses:
  (Common.ValidCondition([Condition: "INVASIVE BREAST CANCER"]) union
  Common.ValidCondition([Condition: "NON-INVASIVE BREAST CANCER"]))

//------------------------------------------------------------------------------
// History of bilateral mastectomy
//------------------------------------------------------------------------------

define "de-mastectomy":
  BilateralMastectomy or (LeftUnilateralMastectomy and RightUnilateralMastectomy)

define BilateralMastectomy:
  exists BilateralMastectomyConditions or 
  exists BilateralMastectomyProcedures

define LeftUnilateralMastectomy:
  exists LeftUnilateralMastectomyConditions or
  exists LeftUnilateralMastectomyProcedures or
  exists UnilateralMastectomyConditions C
    where
      exists C.bodySite bs where bs ~ "Left (qualifier value)" or
      exists (C.bodySite.extension E
        where E.url = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-laterality-qualifier'
          and E.value as CodeableConcept ~ "Left (qualifier value)")           

define RightUnilateralMastectomy:
  exists RightUnilateralMastectomyConditions or
  exists RightUnilateralMastectomyProcedures or 
  exists UnilateralMastectomyConditions C
    where
      exists C.bodySite bs where bs ~ "Right (qualifier value)" or
      exists (C.bodySite.extension E
        where E.url = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-laterality-qualifier'
          and E.value as CodeableConcept ~ "Right (qualifier value)")

define BilateralMastectomyConditions:
  Common.ValidCondition([Condition: "BILATERAL MASTECTOMY"])     

define LeftUnilateralMastectomyConditions:
  Common.ValidCondition([Condition: "LEFT UNILATERAL MASTECTOMY"])

define RightUnilateralMastectomyConditions:
  Common.ValidCondition([Condition: "RIGHT UNILATERAL MASTECTOMY"])  

define UnilateralMastectomyConditions:
  Common.ValidCondition([Condition: "UNILATERAL MASTECTOMY"])      

define BilateralMastectomyProcedures:
  C3F.Completed([Procedure: "BILATERAL MASTECTOMY PROCEDURE"])

define LeftUnilateralMastectomyProcedures:
  C3F.Completed([Procedure: "LEFT UNILATERAL MASTECTOMY PROCEDURE"])

define RightUnilateralMastectomyProcedures:
  C3F.Completed([Procedure: "RIGHT UNILATERAL MASTECTOMY PROCEDURE"])

//------------------------------------------------------------------------------
// Breast symptoms
//------------------------------------------------------------------------------

define "de-breastsymptoms":
  if MostRecentBreastSymptomObservation is not null 
    then FHIRHelpers.ToBoolean(MostRecentBreastSymptomObservation.value as boolean)
  else  
    exists EncounterBreastSymptomConditions or EncounterReasonBreastSymptoms

define EncounterReasonBreastSymptoms:
  encounter is not null and 
    exists AllBreastSymptomEncounters E where encounter = 'Encounter/' + E.id

define AllBreastSymptomEncounters:
  Common.RelevantEncounterStatus(
    [Encounter] E
      where
        E.reasonCode in "BREAST SYMPTOMS"      
  )

define EncounterBreastSymptomConditions:
  BreastSymptomConditions C
    where C.encounter.reference = encounter

define BreastSymptomConditions:
  Common.ValidCondition([Condition: "BREAST SYMPTOMS"])

define MostRecentBreastSymptomObservation:
  BCSMCommon.MostRecentLocalObservation(NewOrWorseningBreastSymptomsObservations,
    encounter, SymptomaticLookBack)

define NewOrWorseningBreastSymptomsObservations:
  [Observation: "New or worsening breast symptoms"]

//------------------------------------------------------------------------------
// Breast exam findings
//------------------------------------------------------------------------------

define "de-breastfindings":
  if MostRecentBreastFindingsObservation is not null 
    then FHIRHelpers.ToBoolean(MostRecentBreastFindingsObservation.value as boolean)
  else false

define MostRecentBreastFindingsObservation:
  BCSMCommon.MostRecentLocalObservation(NewOrWorseningBreastFindingsObservations,
    encounter, SymptomaticLookBack)

define NewOrWorseningBreastFindingsObservations:
  [Observation: "New or worsening breast exam findings"]

//------------------------------------------------------------------------------
// Life expectancy
//------------------------------------------------------------------------------

define "de-lifeexp":
  if MostRecentReducedLifeExpectancyObservation is not null 
    then FHIRHelpers.ToBoolean(MostRecentReducedLifeExpectancyObservation.value as boolean) 
  else "de-hospice"

define MostRecentReducedLifeExpectancyObservation:
  BCSMCommon.MostRecentLocalObservation(ReducedLifeExpectancyObservations, encounter, ObservationLookbackPeriod)

define ReducedLifeExpectancyObservations:  
  [Observation: "Reduced life expectancy indicator"]

define "de-hospice":
  Hospice."Has Hospice"

//------------------------------------------------------------------------------
// Lactating
//------------------------------------------------------------------------------

define MostRecentLactatingObservation:
  BCSMCommon.MostRecentLocalObservation(LactatingObservations, encounter, ObservationLookbackPeriod)

define LactatingObservations:
  [Observation: "Currently lactating"]

//------------------------------------------------------------------------------
// Pregnancy
//------------------------------------------------------------------------------

define Pregnant:
  // IF any Epsidose of care with status = active
  //    Pregnant = true
  // If any Episode of care with status = finished
  //    Pregnant = false
  // Use existing logic with conditions and observations
  if (HasActivePregnancyEpisodesOfCare) then
    true
  else if (HasFinishedPregnancyEpisodesOfCare) then
    false
  else
    Exists(PregnancyDiagnoses) or Exists(PregnancyObservations)

define PregnancyDiagnoses:
  C3F.Confirmed(
    C3F.ActiveCondition(
      C3F.ConditionLookBack(
        [Condition: "Pregnancy"] union [Condition: "Pregnancy (New ICD10 codes published in 2018 and 2020)"],
        42 weeks
      )
    )
  )

define PregnancyObservations:
  C3F.ObservationLookBack(
    C3F.Verified(
      [Observation: "Pregnancy Status"] P
        where P.value ~ "Patient currently pregnant"
    ),
    42 weeks
  )  

define PregnancyEpisodesOfCare:
  [EpisodeOfCare] E where
    AnyTrue(
      (E.type) t
        return t ~ "Pregnancy Episode Of Care"
    )

define ActivePregnancyEpisodesOfCare:
  PregnancyEpisodesOfCare P
  where P.status ~ 'active'

define FinishedPregnancyEpisodesOfCare:
  PregnancyEpisodesOfCare P
  where P.status ~ 'finished'

define HasActivePregnancyEpisodesOfCare:
  Exists(ActivePregnancyEpisodesOfCare)

define HasFinishedPregnancyEpisodesOfCare:
  Exists(FinishedPregnancyEpisodesOfCare)  

//------------------------------------------------------------------------------
// Genetic syndrome
//------------------------------------------------------------------------------

define "de-geneticrisk":
  if MostRecentGeneticMarkerOrSyndromeObservation is not null
    then FHIRHelpers.ToBoolean(MostRecentGeneticMarkerOrSyndromeObservation.value as boolean) 
  else "de-acsgeneticrisk"

define GeneticMarkerOrSyndrome:
  MostRecentGeneticMarkerOrSyndromeObservation.value is true

define MostRecentGeneticMarkerOrSyndromeObservation:
  C3F.MostRecent(
    [Observation: "Genetic marker or syndrome associated with breast cancer"]
  )

define "de-acsgeneticrisk":
  exists "BRCA-1 Mutation Conditions" or exists "BRCA-2 Mutation Conditions" or
    exists "Li-Fraumeni Syndrome Conditions" or exists "Cowden Syndrome Conditions" or
    exists "Bannayan-Riley-Ruvalcaba Syndrome Conditions"

define "BRCA-1 Mutation Conditions":
  Common.ValidCondition([Condition: "BRCA1 Gene Mutation"])

define "BRCA-2 Mutation Conditions":
  Common.ValidCondition([Condition: "BRCA2 Gene Mutation"])

define "Li-Fraumeni Syndrome Conditions":
  Common.ValidCondition([Condition: "Li-Fraumeni Syndrome"])

define "Cowden Syndrome Conditions":
  Common.ValidCondition([Condition: "Cowden Syndrome"])

define "Bannayan-Riley-Ruvalcaba Syndrome Conditions":
  Common.ValidCondition([Condition: "Bannayan-Riley-Ruvalcaba Syndrome"])

//------------------------------------------------------------------------------
// Chest XRT
//------------------------------------------------------------------------------

define "de-chestxrt":
  Common.ValidCondition([Condition: "History of radiation therapy to chest"])

define "de-chestxrtage10to30":
  if HistoryOfChestRadiationAges10To30Observation is not null
    then FHIRHelpers.ToBoolean(HistoryOfChestRadiationAges10To30Observation.value as boolean) 
  else exists HistoryOfChestRadiationAges10To30Condition

define HistoryOfChestRadiationAges10To30Condition:    
  "de-chestxrt" C 
    where C.onset as Age is not null and C.onset.value >= 10 and C.onset.value <= 30 and C.onset.code = 'a'
    or C.abatement as Age is not null and C.abatement.value >= 10 and C.abatement.value <= 30 and C.abatement.code = 'a' 

define HistoryOfChestRadiationAges10To30Observation:
  C3F.MostRecent([Observation: "History of chest radiation ages 10-30 y"])

//------------------------------------------------------------------------------
// Previous breast cancer
//------------------------------------------------------------------------------

define "de-hxbreastca":
  BreastCancerDiagnoses C
    where C.clinicalStatus ~ "Condition inactive"
      or C.clinicalStatus ~ "Condition remission"
      or C.clinicalStatus ~ "Condition resolved"  

//------------------------------------------------------------------------------
// Atypical biopsy
//------------------------------------------------------------------------------      

define "de-atypicalbx":
  exists AtypicalBiopsyConditions or
    exists AtypicalBiopsyResults

define MostRecentAtypicalBiopsyDate:
  if MostRecentAtypicalBiopsyConditionDate is null then MostRecentAtypicalBiopsyResultDate
  else if MostRecentAtypicalBiopsyResultDate is null then MostRecentAtypicalBiopsyConditionDate
  else Last(({MostRecentAtypicalBiopsyConditionDate, MostRecentAtypicalBiopsyResultDate}) E sort asc)

define MostRecentAtypicalBiopsyConditionDate:
  Common.ConditionDate(
    C3F.MostRecentCondition(AtypicalBiopsyConditions)
  )

define AtypicalBiopsyConditions:
  Common.ValidCondition([Condition: "Biopsy Atypical Results"])

define MostRecentAtypicalBiopsyResultDate:
  Common.DiagnosticReportDate(
    Common.MostRecentDiagnosticReport(AtypicalBiopsyResults)
  )

define AtypicalBiopsyResults:
  BiopsyDiagnosticReports D
    let cC: BCSMCommon.CollateConclusionCodes(D,BiopsyObservations)
    where cC in "Biopsy Atypical Results" 
      or Exists(cC.coding c where c ~ Atypical)

//------------------------------------------------------------------------------
// High lifetime risk
//------------------------------------------------------------------------------   

define "de-highlifetimerisk":
  MostRecentLifetimeRiskAssessmentResultHigh is not null

define MostRecentLifetimeRiskAssessmentResultHigh:
  MostRecentLifetimeRiskAssessment R where 
    R.value as FHIR.Quantity is not null and C3F.QuantityValue(R).value >20 or
    R.value as FHIR.CodeableConcept is not null and C3F.ConceptValue(R) ~ "High lifetime risk"

define MostRecentLifetimeRiskAssessment:
  C3F.MostRecent([Observation: "Lifetime risk assessment"])

//------------------------------------------------------------------------------
// First degree relative with genetic marker or syndrome
//------------------------------------------------------------------------------  

define "MostRecentFirstDegRelativeGeneticObservation":
  C3F.MostRecent(
      [Observation: "First degree relative with genetic marker or syndrome"]
  ) 

//------------------------------------------------------------------------------
// BI-RADS breast density category C or D
//------------------------------------------------------------------------------  

define "de-breastdensitycord":  
  exists BreastImagingHeterogenouslyOrExtremelyDenseResults

define BreastImagingHeterogenouslyOrExtremelyDenseResults:
  BreastImagingDiagnosticReports D
    let cC: BCSMCommon.CollateConclusionCodes(D,BreastImagingObservations)
    where exists(cC.coding C where FHIRHelpers.ToCode(C) ~ "Heterogeneously dense") 
      or exists (cC.coding C where FHIRHelpers.ToCode(C) ~ "Extremely dense")

//------------------------------------------------------------------------------
// Compelling family history of breast cancer
//------------------------------------------------------------------------------  

define "de-fhxbreastcarisk":
  if MostRecentFamilialRiskAssessmentObservation is not null
    then FHIRHelpers.ToBoolean(MostRecentFamilialRiskAssessmentObservation.value as boolean) 
  else MostRecentFamilialRiskAssessmentResultHigh is not null

define FamilialRiskAssessmentExists:
  MostRecentFamilialRiskAssessmentObservation is not null or 
    MostRecentFamilialRiskAssessmentResult is not null

define MostRecentFamilialRiskAssessmentObservation:  
  C3F.MostRecent(FamilialRiskAssessmentObservations)

define FamilialRiskAssessmentObservations:  
  [Observation: "Familial risk assessment"] R    

// Output of validated brief familial risk assessment tool is positive or greater than 5%
define MostRecentFamilialRiskAssessmentResultHigh:
  MostRecentFamilialRiskAssessmentResult R where 
    R.value as FHIR.Quantity is not null and C3F.QuantityValue(R).value >5 or
    R.value as FHIR.CodeableConcept is not null and C3F.ConceptValue(R) ~ "High familial risk"

define MostRecentFamilialRiskAssessmentResult:
  C3F.MostRecent([Observation: "Brief familial risk assessment tool"])

// 'Informal familial risk criteria' exist
define "de-fhxrisk":
  Count(FirstOrSecondDegreeRelativesWithBreastCancer) >= 2
  or Count(FirstOrSecondDegreeRelativesWithOvarianCancer) >= 2
  or exists (BreastCancerDiagnosedBefore50)
  or BreastAndOvarianCancerInFamily
  or exists (BreastAndOvarianCancerInSameRelative)
  or exists (TwoIndependentBreastCancers)
  or exists (MaleRelativeWithBreastCancer) 

define "FirstOrSecondDegreeRelativesWithBreastCancer":
  FirstOrSecondDegreeRelatives F
    where exists (F.condition C where C.code in "INVASIVE BREAST CANCER" or C.code in "NON-INVASIVE BREAST CANCER")

define "FirstOrSecondDegreeRelativesWithOvarianCancer":
  FirstOrSecondDegreeRelatives F
    where exists (F.condition C where C.code in "OVARIAN CANCER")

define "BreastCancerDiagnosedBefore50":
  FirstOrSecondDegreeRelatives F
    where exists (F.condition C where (C.code in "INVASIVE BREAST CANCER" or C.code in "NON-INVASIVE BREAST CANCER")
      and C.onset as Age <= 50 years)

define "BreastAndOvarianCancerInFamily":
  exists (FirstOrSecondDegreeRelativesWithBreastCancer)
    and exists (FirstOrSecondDegreeRelativesWithOvarianCancer)

define "BreastAndOvarianCancerInSameRelative":
  FirstOrSecondDegreeRelatives F
    where exists (F.condition C1 where C1.code in "INVASIVE BREAST CANCER" or C1.code in "NON-INVASIVE BREAST CANCER")
      and exists (F.condition C2 where C2.code in "OVARIAN CANCER")

define "TwoIndependentBreastCancers":
  FirstOrSecondDegreeRelatives F
    where exists F.condition C1 where C1.code in "INVASIVE BREAST CANCER" or C1.code in "NON-INVASIVE BREAST CANCER"
      and exists F.condition C2 where (C2.code in "INVASIVE BREAST CANCER" or C2.code in "NON-INVASIVE BREAST CANCER")
        and C1 != C2

define "MaleRelativeWithBreastCancer":
  FirstOrSecondDegreeRelatives F
    where exists (F.condition C where C.code in "INVASIVE BREAST CANCER" or C.code in "NON-INVASIVE BREAST CANCER")
      and F.sex ~ "Male"

define "FirstOrSecondDegreeRelatives":
  [FamilyMemberHistory] F
    where F.relationship in "FIRST DEGREE FAMILY MEMBER" or F.relationship in "SECOND DEGREE FAMILY MEMBER"

//------------------------------------------------------------------------------
// Family history of inherited cancer susceptibility
//------------------------------------------------------------------------------  

define "de-fhxgeneinherited":
  if FamilyGeneticHistoryAssessmentObservation is not null
    then FHIRHelpers.ToBoolean(FamilyGeneticHistoryAssessmentObservation.value as boolean) 
  else exists FamilyMemberGeneticMarkerOrSyndrome

define FamilyGeneticHistoryAssessmentObservation:  
  C3F.MostRecent(
      [Observation: "Family history of inherited cancer susceptibility"] R
  )

define "FirstDegRelativeGeneticMarkerOrSyndrome":
  FamilyMemberGeneticMarkerOrSyndrome F
    where 
      F.relationship in "FIRST DEGREE FAMILY MEMBER"

define "FamilyMemberGeneticMarkerOrSyndrome":
  FamilyMemberGeneticMarkerOrSyndromeConditions F
    return F.familyMemberHistory

define "FamilyMemberGeneticMarkerOrSyndromeConditions":
  [FamilyMemberHistory] F
    let
      GeneticConditions: F.condition C
        where         
          C.code in "BRCA1 Gene Mutation" or 
          C.code in "BRCA2 Gene Mutation" or
          C.code in "Li-Fraumeni Syndrome" or 
          C.code in "Cowden Syndrome" or
          C.code in "Bannayan-Riley-Ruvalcaba Syndrome"
    where exists GeneticConditions
    return {
      familyMemberHistory: F,
      conditions: GeneticConditions
    }

//------------------------------------------------------------------------------
// Unknown variant status
//------------------------------------------------------------------------------  

define "de-knownvariantstatus":
  if KnownGeneticMarkerOrSyndromeStatusObservation is not null
    then FHIRHelpers.ToBoolean(KnownGeneticMarkerOrSyndromeStatusObservation.value as boolean) 
  else false

define KnownGeneticMarkerOrSyndromeStatusObservation:  
  C3F.MostRecent(
      [Observation: "Known breast cancer variant status"] R
  ) 

//------------------------------------------------------------------------------
// BRCA ancestry
//------------------------------------------------------------------------------ 

define "MostRecentBRCAGeneAncestryObservation":
  C3F.MostRecent(
      [Observation: "Ancestry associated with BRCA1/2 gene mutations"] R
  )

//------------------------------------------------------------------------------
// Family history of breast, ovarian, tubal, or peritoneal cancer
//------------------------------------------------------------------------------  

define FamilyHistoryBreastOvarianTubalPeritonealCancerObservation:  
  C3F.MostRecent(FamilyHistoryBreastOvarianTubalPeritonealCancerObservations)

define FamilyHistoryBreastOvarianTubalPeritonealCancerObservations:  
  [Observation: "Family history of breast, ovarian, tubal, or peritoneal cancer"]  

define "FamilyMemberBreastOvarianTubalPeritonealCancer":
  FamilyMemberBreastOvarianTubalPeritonealCancerCondition FMH
    return FMH.familyMemberHistory

define "FamilyMemberBreastOvarianTubalPeritonealCancerCondition":
  [FamilyMemberHistory] F
    let
      CancerConditions: F.condition C
        where C.code in "INVASIVE BREAST CANCER" or
              C.code in "NON-INVASIVE BREAST CANCER" or
              C.code in "OVARIAN CANCER" or
              C.code in "TUBAL CANCER" or
              C.code in "PERITONEAL CANCER"
    where exists CancerConditions
    return {
      familyMemberHistory: F,
      conditions: CancerConditions
    }

//------------------------------------------------------------------------------
// Genetic risk referrals and encounters
//------------------------------------------------------------------------------  

define GeneticCounselingEncounters:
  Common.RelevantEncounterStatus(
    [Encounter] E
      where E.serviceType in "GENETIC COUNSELING" or E.reasonCode in "GENETIC COUNSELING"
  )

define GeneticCounselingReferralOrders:
  [ServiceRequest] O where 
    BCSMCommon.ServiceRequestWithOrderIntent(O) 
    and O.code in "GENETIC COUNSELING" or O.reasonCode in "GENETIC COUNSELING"

//------------------------------------------------------------------------------
// High risk referral factors
//------------------------------------------------------------------------------  

define MostRecent5YrRiskAssessment:
  C3F.MostRecent([Observation: "5 year risk assessment"])  

define MostRecent5YrRiskAssessmentDate:
  Common.ObservationDate(MostRecent5YrRiskAssessment)

define MostRecentPersonalRiskFactorAssessment:
  C3F.MostRecent(PersonalRiskFactorAssessments)  

define PersonalRiskFactorAssessments:
  [Observation: "Personal risk factors conferring increased risk of breast cancer"]

//------------------------------------------------------------------------------
// Latest screening test
//------------------------------------------------------------------------------  

define CompletedBreastCancerScreeningDiagnosticReports:
  CompletedBreastImagingDiagnosticReports union CompletedBreastBiopsyDiagnosticReports 

define AllCompletedDiagnosticReport:
  Common.CompletedDiagnosticReport([DiagnosticReport])    
  
// Imaging
define MostRecentBreastImagingDiagnosticReport:
  Common.MostRecentDiagnosticReport(BreastImagingDiagnosticReports)

define MostRecentBreastImagingDiagnosticReportNoConclusionCodes:
  MostRecentBreastImagingDiagnosticReport is not null and
    not Exists(BCSMCommon.CollateConclusionCodes(MostRecentBreastImagingDiagnosticReport,BreastImagingObservations))

define BreastImagingDiagnosticReports:
  distinct(
    (AllCompletedDiagnosticReport R
      where 
        Count(
          BCSMCommon.CollateConclusionCodes(R, BreastImagingObservations,"Breast Imaging Report")        
      ) > 0)
    union CompletedBreastImagingDiagnosticReports
  )

define ImagingDiagnosticReportsWithNoConclusionCodes:
  Exists(BreastImagingDiagnosticReports) and
    AnyTrue(
      (BiopsyDiagnosticReports) D 
      return not Exists(BCSMCommon.CollateConclusionCodes(D,BreastImagingObservations))
  )

define CompletedBreastImagingDiagnosticReports:
  Common.CompletedDiagnosticReport([DiagnosticReport: "BREAST CANCER IMAGING ORDERS"]) 

define BreastImagingObservations:
  [Observation: "Breast Imaging Report"]   

// Biopsy
define MostRecentBreastBiopsyDiagnosticReport:
  Common.MostRecentDiagnosticReport(BiopsyDiagnosticReports)

define MostRecentBreastBiopsyDiagnosticReportNoConclusionCodes:
  MostRecentBreastBiopsyDiagnosticReport is not null and
    not Exists(BCSMCommon.CollateConclusionCodes(
      MostRecentBreastBiopsyDiagnosticReport,BiopsyObservations))   

define BiopsyDiagnosticReports:
  distinct(
    (AllCompletedDiagnosticReport B
      where 
        Count(
          BCSMCommon.CollateConclusionCodes(B, BiopsyObservations,"Breast Pathology biopsy report")
        ) > 0 ) 
    union CompletedBreastBiopsyDiagnosticReports
  )

define BiopsyDiagnosticReportsWithNoConclusionCodes:
  Exists(BiopsyDiagnosticReports) and
    AnyTrue(
      (BiopsyDiagnosticReports) D 
      return not Exists(BCSMCommon.CollateConclusionCodes(D,BiopsyObservations))
  )

define CompletedBreastBiopsyDiagnosticReports:
  Common.CompletedDiagnosticReport([DiagnosticReport: "Breast Pathology biopsy report"])      

define IncompleteBreastBiopsyDiagnosticReports:
  [DiagnosticReport: "Breast Pathology biopsy report"] DR where
    DR.status in {'preliminary', 'registered', 'partial'}  

// TODO: should report observation code be a value set?
define BiopsyObservations:
  [Observation: "Breast Pathology biopsy report"]      