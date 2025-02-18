library ScreeningEligibleEvents version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include DataElements version '1.0.0' called DataElements

context Patient

define "eve-female":
  DataElements."de-female"

define "eve-breastca":
  DataElements."de-breastca"

define "eve-mastectomy":
  DataElements."de-mastectomy"  

define "eve-breastsymptoms":
  DataElements."de-breastsymptoms"

define "eve-breastfindings":
  DataElements."de-breastfindings"

