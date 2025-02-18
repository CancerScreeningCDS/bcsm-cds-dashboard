library ScreeningTestIncomplete version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include ScreeningTestIncompleteEvents version '1.0.0' called Events
include DataElements version '1.0.0' called DataElements
include ScreeningEligible version '1.0.0'
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

context Patient

define "flow-ScreeningTestIncomplete":
  exists IncompleteScreeningOrders
    or exists IncompleteScreeningProcedures
    or exists IncompleteScreeningPathology

define IncompleteScreeningOrders:
  Events."eve-pendingorders"  

define IncompleteScreeningProcedures:
  Events."eve-pendingprocedures"

define IncompleteScreeningPathology:
  Events."eve-pendingpathology"  

//------------------------------------------------------------------------------
// MEASURE
//------------------------------------------------------------------------------  

define "Initial Population":
  ScreeningEligible.IsIncludedAndNotExcluded

define "Denominator":
	"Initial Population"

define "Denominator Exclusion":
  ScreeningEligible.IsNotScreeningEligible

define "Numerator":
  "flow-ScreeningTestIncomplete"  