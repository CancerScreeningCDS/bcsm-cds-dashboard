/*
@author: The Health FFRDC, operated by The MITRE Corporation, in support of the Division of Cancer Prevention and Control, Centers for Disease Control and Prevention.
@description: Screening eligible criteria
*/
library ScreeningEligible version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include ScreeningEligibleEvents version '1.0.0' called Events
include ScreeningEligibleActions version '1.0.0' called Actions
include DataElements version '1.0.0' called DataElements

//------------------------------------------------------------------------------
// CODE SYSTEMS, VALUE SETS, AND CODES
//------------------------------------------------------------------------------

codesystem "LOINC": 'http://loinc.org'

codesystem "ActCode": 'http://example.org/CodeSystem/plan-definition-action-code-system'
codesystem "LOCAL": 'http://example.org/CodeSystem/plan-definition-action-reason-code-system'

// Act Codes
code "Error": 'error' from "ActCode"
// Reason Codes
code "Missing age or birth date": 'missingageorbirthdate' from "LOCAL"

// Standard codes
code "Age": '30525-0' from "LOINC" display 'Age'

context Patient

//------------------------------------------------------------------------------
// INCLUSIONS/EXCLUSIONS
//------------------------------------------------------------------------------

define CheckIsIncludedAndNotExcluded:
  IsIncludedAndNotExcludedErrorsHaveOccurred is not true 
    and Message(IsIncludedAndNotExcluded, IsIncludedAndNotExcluded is false,
    'http://example.org/CodeSystem/plan-definition-action-reason-code-system/excludedornotincluded',
    'Error', 
    'Excluded or not included')

define IsIncludedAndNotExcluded:
  IsIncluded and not Excluded

// INCLUSIONS
define IsIncluded:
  "inc-AgeAtLeast18" and "inc-assignedfemaleatbirthortransfemale"

// Age 18 years and older, only use MostRecentAgeValue if no birthdate  
define "inc-AgeAtLeast18":
  (AgeInYears() is not null and AgeInYears() >= 18) or (AgeInYears() is null and MostRecentAgeValue >= 18)

define MostRecentAgeValue:
  First(
    [Observation: "Age"] O
      where O.value.unit = 'years'
      sort by effective desc
  ).value.value.value

define "inc-assignedfemaleatbirthortransfemale":
  Events."eve-female" or DataElements."TransgenderFemale"

// EXCLUSIONS
define Excluded:
  false

//------------------------------------------------------------------------------
// RECOMMENDATIONS
//------------------------------------------------------------------------------

define "flow-ScreeningEligible":
  { 
    Coalesce(
      NotEligibleNotAssignedFemaleAtBirth,
      NotEligibleCurrentBreastCancer,
      NotEligibleBilateralMastectomy,
      NotEligibleBreastSymptomsOrFindings,
      Eligible
    )
  }
  except { null }

define NotEligibleNotAssignedFemaleAtBirth:
  if Events."eve-female" is not true
  then Actions."end-noteligible-notassignedfemaleatbirth" else null

define NotEligibleCurrentBreastCancer:
  if Events."eve-breastca" is true
  then Actions."end-noteligible-currentbreastcancer" else null

define NotEligibleBilateralMastectomy:
  if Events."eve-mastectomy" is true
  then Actions."end-noteligible-bilatmastectomy" else null  

define NotEligibleBreastSymptomsOrFindings:
  if Events."eve-breastsymptoms" is true or Events."eve-breastfindings" is true
  then Actions."act-dxtesting" else null  

define Eligible:
  if Coalesce(
      NotEligibleNotAssignedFemaleAtBirth,
      NotEligibleCurrentBreastCancer,
      NotEligibleBilateralMastectomy,
      NotEligibleBreastSymptomsOrFindings) is null
  then Actions."act-eligible" else null

//------------------------------------------------------------------------------
// DYNAMIC VALUES
//------------------------------------------------------------------------------

define IsScreeningEligible:
  Eligible is not null

define IsNotScreeningEligible:
  Eligible is null

define ExistsNotEligibleNotAssignedFemaleAtBirth:
  NotEligibleNotAssignedFemaleAtBirth is not null  

define ExistsNotEligibleCurrentBreastCancer:
  NotEligibleCurrentBreastCancer is not null  

define ExistsNotEligibleBilateralMastectomy:
  NotEligibleBilateralMastectomy is not null  

define ExistsNotEligibleBreastSymptomsOrFindings:
  NotEligibleBreastSymptomsOrFindings is not null  

define ScreeningEligibleCode:
  First("flow-ScreeningEligible").code

define ScreeningEligibleReason:
  First("flow-ScreeningEligible").reason    

//------------------------------------------------------------------------------
// ERRORS
//------------------------------------------------------------------------------

define IsIncludedAndNotExcludedErrorsHaveOccurred:
  ErrorMissingAgeOrBirthdate

define MissingAgeOrBirthdate:
  AgeInYears() is null and MostRecentAgeValue is null

define ErrorMissingAgeOrBirthdate:
  if MissingAgeOrBirthdate
  then Message(true, true,
    'http://example.org/CodeSystem/plan-definition-action-reason-code-system/missingageorbirthdate',
    'Warning', 
    'Missing age or birth date')
  else false