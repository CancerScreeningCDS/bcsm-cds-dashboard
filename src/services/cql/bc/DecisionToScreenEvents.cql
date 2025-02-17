library DecisionToScreenEvents version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include CDSConnectCommonsforFHIRv401 version '1.0.0' called C3F
include DataElements version '1.0.0' called DataElements

//------------------------------------------------------------------------------
// CODE SYSTEMS, VALUE SETS, AND CODES
//------------------------------------------------------------------------------

codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'

//------------------------------------------------------------------------------
// PARAMETERS
//------------------------------------------------------------------------------

parameter ObservationLookbackPeriod default 14 days
parameter SymptomaticLookBack default 14 days

context Patient

define "eve-AgeOver74":
  AgeInYears() > 74

define "eve-LifeExp":
  DataElements."de-lifeexp"

define "eve-lactating":
   Lactating

define Lactating:
  if DataElements.MostRecentLactatingObservation is not null
    then FHIRHelpers.ToBoolean(DataElements.MostRecentLactatingObservation.value as boolean) 
  else false

