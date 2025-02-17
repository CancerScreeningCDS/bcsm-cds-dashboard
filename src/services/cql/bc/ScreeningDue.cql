library ScreeningDue version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include ScreeningDueEvents version '1.0.0' called Events
include ScreeningEligible version '1.0.0'
include Hospice version '1.0.0'

context Patient

//------------------------------------------------------------------------------
// RECOMMENDATIONS
//------------------------------------------------------------------------------

define "flow-ScreeningDue":
  (Events."eve-nextdueexists" is false and Events."eve-noscreening27mo")
    or exists DueOrOverdue

define DueOrOverdue:    
  Events."eve-due"

//------------------------------------------------------------------------------
// MEASURE
//------------------------------------------------------------------------------  

define "Initial Population":
  ScreeningEligible.IsIncludedAndNotExcluded

define "Denominator":
	"Initial Population"

define "Denominator Exclusion":
  ScreeningEligible.IsNotScreeningEligible
	  or Hospice."Has Hospice"

define "Numerator":
  "flow-ScreeningDue"