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

code "Condition inactive": 'inactive' from "CONDCLINSTATUS" display 'inactive'
code "Condition remission": 'remission' from "CONDCLINSTATUS" display 'remission'
code "Condition resolved": 'resolved' from "CONDCLINSTATUS" display 'resolved'
code "Condition active": 'active' from "CONDCLINSTATUS" display 'active'

// Pregnancy
valueset "Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.378'
valueset "Pregnancy (New ICD10 codes published in 2018 and 2020)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.80'
// Breast diagnoses, procedures, and observations
valueset "Breast Cancer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.367' // TODO clinical validation: Keep secondary cancers?
valueset "Bilateral Mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1068'
valueset "Left Unilateral Mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1069'
valueset "Right Unilateral Mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1070'
valueset "Unilateral Mastectomy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1071'
valueset "Bilateral Mastectomy Procedure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1005'
valueset "Left Unilateral Mastectomy Procedure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1133'
valueset "Right Unilateral Mastectomy Procedure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1134'
valueset "Genetic Marker of Susceptibility to Breast Cancer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.378'
valueset "BRCA1 Gene Mutation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.379' // TODO clinical validation: keep weird codes referencing specific BRCA mutations?
valueset "BRCA2 Gene Mutation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.380' // TODO clinical validation: keep weird codes referencing specific BRCA mutations?
valueset "History of Breast Cancer or Breast Cancer in Remission": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.383' // TODO clinical validation: include codes for partial remission?
valueset "Biopsy Atypical Results": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.392' // TODO clinical validation: Keep "generic" ICD-10-CM codes under which atypical hyperplasia is classified (but which are not specific to atypical hyperplasia)? Decided against it for similar situations in CRC.
valueset "Ovarian Cancer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.1444.5.232'
valueset "Tubal Cancer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1116.539'
valueset "Peritoneal Cancer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.1444.5.233'
valueset "Breast Cancer Signs and Symptoms": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.374' // TODO clinical validation: check for overall accuracy.
valueset "First Degree Family Member": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.92'
valueset "Second Degree Family Member": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.401' // TODO clinical validation: keep cousins (could be second cousins according to definition)?
valueset "Breast Cancer Biopsy Orders": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.387' //TODO: add CPT, HCPCS, ICD-10-PCS. TODO clinical validation: check for overall accuracy.
valueset "Breast Cancer Imaging Orders": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1032.394' //TODO: add CPT, HCPCS, ICD-10-PCS. TODO clinical validation: Keep SNOMED codes for core compression, magnification and localization mammography? Keep mammary ductograms? Keep doppler US?
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
code "Breast Imaging Report": '10193-1' from "LOINC" display 'Physical findings of Breasts Narrative' // Consider replacing with "Breast Screening Cancer Imaging Orders" value set when using to identify DiagnosticReport resources. All but a couple of the LOINC codes included can be used for both orders and observations/results.
code "Heterogeneously dense": '129718006' from "SNOMED-CT" display 'Heterogeneously dense breast composition'
code "Extremely dense": '129719003' from "SNOMED-CT" display 'Extremely dense breast composition'
code "Pregnancy Status": '82810-3' from "LOINC" display 'Pregnancy status'
code "Patient currently pregnant": '77386006' from "SNOMED-CT" display 'Patient currently pregnant (finding)'
code "Pregnancy Episode Of Care": '424525001' from "SNOMED-CT" display 'Antenatal care (regime/therapy)'

// Non-standard codes
code "Breast cancer within 5 years": 'hxbreastcawithin5y' from "LOCAL" display 'Breast cancer within 5 years'
code "New or worsening breast symptoms": 'BreastSymptoms' from "LOCAL" display 'New or worsening breast symptoms'
code "New or worsening breast exam findings": 'BreastFindings' from "LOCAL" display 'New or worsening breast exam findings'
code "Reduced life expectancy indicator": 'lifeexp' from "LOCAL" display 'Reduced life expectancy indicator'
code "Currently lactating": 'currentlylactating' from "LOCAL" display 'Currently lactating'
code "Genetic marker or syndrome associated with breast cancer": 'GeneticMarkerOrSyndrome' from "LOCAL" display 'Genetic marker or syndrome associated with breast cancer'
code "Li-Fraumeni Syndrome": '428850001' from "SNOMED-CT" display 'Li-Fraumeni syndrome (disorder)'
code "Cowden Syndrome": '58037000' from "SNOMED-CT" display 'Cowden syndrome (disorder)'
code "Bannayan-Riley-Ruvalcaba Syndrome": '234138005' from "SNOMED-CT" display 'Bannayan syndrome (disorder)'
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
  BreastCancerDiagnoses C
    where C.clinicalStatus !~ "Condition inactive"
      and C.clinicalStatus !~ "Condition remission"
      and C.clinicalStatus !~ "Condition resolved"

define BreastCancerDiagnoses:
  Common.ValidCondition([Condition: "Breast Cancer"])

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
  Common.ValidCondition([Condition: "Bilateral Mastectomy"])     

define LeftUnilateralMastectomyConditions:
  Common.ValidCondition([Condition: "Left Unilateral Mastectomy"])

define RightUnilateralMastectomyConditions:
  Common.ValidCondition([Condition: "Right Unilateral Mastectomy"])  

define UnilateralMastectomyConditions:
  Common.ValidCondition([Condition: "Unilateral Mastectomy"])      

define BilateralMastectomyProcedures:
  C3F.Completed([Procedure: "Bilateral Mastectomy Procedure"])

define LeftUnilateralMastectomyProcedures:
  C3F.Completed([Procedure: "Left Unilateral Mastectomy Procedure"])

define RightUnilateralMastectomyProcedures:
  C3F.Completed([Procedure: "Right Unilateral Mastectomy Procedure"])

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
        E.reasonCode in "Breast Cancer Signs and Symptoms"      
  )

define EncounterBreastSymptomConditions:
  BreastSymptomConditions C
    where C.encounter.reference = encounter

define BreastSymptomConditions:
  Common.ValidCondition([Condition: "Breast Cancer Signs and Symptoms"])

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
  else GeneticMarkerOrSyndrome is true or "de-acsgeneticrisk"

define GeneticMarkerOrSyndrome:
  MostRecentGeneticMarkerOrSyndromeObservation.value is true
    or exists GeneticMarkerOrSyndromeCondition

define MostRecentGeneticMarkerOrSyndromeObservation:
  C3F.MostRecent(
    [Observation: "Genetic marker or syndrome associated with breast cancer"]
  )

define GeneticMarkerOrSyndromeCondition:
  C3F.ActiveCondition(
    [Condition: "Genetic Marker of Susceptibility to Breast Cancer"]
  )  

define "de-acsgeneticrisk":
  exists "BRCA-1MutationConditions" or exists "BRCA-2MutationConditions" or
    exists "Li-FraumeniSyndromeConditions" or exists CowdenSyndromeConditions or
    exists "Bannayan-Riley-RuvalcabaSyndromeConditions"

define "BRCA-1MutationConditions":
  Common.ValidCondition([Condition: "BRCA1 Gene Mutation"])

define "BRCA-2MutationConditions":
  Common.ValidCondition([Condition: "BRCA2 Gene Mutation"])

define "Li-FraumeniSyndromeConditions":
  Common.ValidCondition([Condition: "Li-Fraumeni Syndrome"])

define CowdenSyndromeConditions:
  Common.ValidCondition([Condition: "Cowden Syndrome"])

define "Bannayan-Riley-RuvalcabaSyndromeConditions":
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
  (BreastCancerDiagnoses C
    where C.clinicalStatus ~ "Condition inactive"
      or C.clinicalStatus ~ "Condition remission"
      or C.clinicalStatus ~ "Condition resolved"
  )
  union
  (HistoryBreastCancerDiagnoses C
    where C.clinicalStatus ~ "Condition active"
  )
  
define HistoryBreastCancerDiagnoses:
  Common.ValidCondition([Condition: "History of Breast Cancer or Breast Cancer in Remission"])

//------------------------------------------------------------------------------
// Breast cancer onset within 5 years
//------------------------------------------------------------------------------

define "de-hxbreastcawithin5y":
  Coalesce(
    BreastCancerWithin5YEncounter.value as boolean,
    BreastCancerWithin5YLookback.value as boolean,
    (exists "de-breastca" C where Today() before (C.onset as FHIR.dateTime) + 5 years) or
    (exists "de-hxbreastca" P where Today() before (P.onset as FHIR.dateTime) + 5 years)
  ) 

define BreastCancerWithin5YEncounter:
  C3F.MostRecent(BreastCancerWithin5YObservations O where O.encounter.reference = encounter)

define BreastCancerWithin5YLookback:
  C3F.MostRecent(
    C3F.ObservationLookBack(
      BreastCancerWithin5YObservations,
      ObservationLookbackPeriod
    ) 
  )

define BreastCancerWithin5YObservations:
  [Observation: "Breast cancer within 5 years"]    

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
    where exists F.condition C where C.code in "Breast Cancer"

define "FirstOrSecondDegreeRelativesWithOvarianCancer":
  FirstOrSecondDegreeRelatives F
    where exists F.condition C where C.code in "Ovarian Cancer"

define "BreastCancerDiagnosedBefore50":
  FirstOrSecondDegreeRelatives F
    where exists (F.condition C where C.code in "Breast Cancer"
      and C.onset as Age <= 50 years)

define "BreastAndOvarianCancerInFamily":
  exists (FirstOrSecondDegreeRelativesWithBreastCancer)
    and exists (FirstOrSecondDegreeRelativesWithOvarianCancer)

define "BreastAndOvarianCancerInSameRelative":
  FirstOrSecondDegreeRelatives F
    where exists F.condition C1 where C1.code in "Breast Cancer"
      and exists F.condition C2 where C2.code in "Ovarian Cancer"

// TODO: do we need to consider two independent conditions with the same code but different onsets?
define "TwoIndependentBreastCancers":
  FirstOrSecondDegreeRelatives F
    where exists F.condition C1 where C1.code in "Breast Cancer"
      and exists F.condition C2 where C2.code in "Breast Cancer"
        and C1 != C2

define "MaleRelativeWithBreastCancer":
  FirstOrSecondDegreeRelatives F
    where exists F.condition C where C.code in "Breast Cancer"
      and F.sex ~ "Male"

define "FirstOrSecondDegreeRelatives":
  [FamilyMemberHistory] F
    where F.relationship in "First Degree Family Member" or F.relationship in "Second Degree Family Member"

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
      F.relationship in "First Degree Family Member"

define "FamilyMemberGeneticMarkerOrSyndrome":
  FamilyMemberGeneticMarkerOrSyndromeConditions F
    return F.familyMemberHistory

define "FamilyMemberGeneticMarkerOrSyndromeConditions":
  [FamilyMemberHistory] F
    let
      GeneticConditions: F.condition C
        where
          C.code in "Genetic Marker of Susceptibility to Breast Cancer" or         
          C.code in "BRCA1 Gene Mutation" or 
          C.code in "BRCA2 Gene Mutation" or
          C.code ~ "Li-Fraumeni Syndrome" or 
          C.code ~ "Cowden Syndrome" or
          C.code ~ "Bannayan-Riley-Ruvalcaba Syndrome"
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

// TODO: check for BRCA1 and BRCA2 DiagnosticReports with conclusion code and/or associated observations?

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
        where C.code in "Breast Cancer" or
              C.code in "Ovarian Cancer" or
              C.code in "Tubal Cancer" or
              C.code in "Peritoneal Cancer"
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
  Common.CompletedDiagnosticReport([DiagnosticReport: "Breast Cancer Imaging Orders"]) 

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