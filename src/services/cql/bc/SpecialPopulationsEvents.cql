library SpecialPopulationsEvents version '1.0.0'

using FHIR version '4.0.1'

include CDSConnectCommonsforFHIRv401 version '1.0.0' called C3F
include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements

codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'
codesystem "v3-RoleCode": 'http://terminology.hl7.org/CodeSystem/v3-RoleCode'

context Patient

define "eve-highlifetimerisk":
  DataElements."de-highlifetimerisk"

define "eve-firstdeggenetic":
  FirstDegRelativeGeneticMarkerOrSyndromeObservation or exists FirstDegRelativeGeneticMarkerOrSyndrome

define "FirstDegRelativeGeneticMarkerOrSyndromeObservation":
  if DataElements.MostRecentFirstDegRelativeGeneticObservation is not null
    then FHIRHelpers.ToBoolean(DataElements.MostRecentFirstDegRelativeGeneticObservation.value as boolean) 
  else false

define "FirstDegRelativeGeneticMarkerOrSyndrome":
  DataElements."FirstDegRelativeGeneticMarkerOrSyndrome"

define "eve-breastdensitycord":
  DataElements."de-breastdensitycord"

define "eve-fhxbreastcarisk":
  DataElements."de-fhxbreastcarisk" or DataElements."de-fhxrisk"
