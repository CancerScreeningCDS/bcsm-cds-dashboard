library HighRiskExclusionsEvents version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements
include CSMCommonFunctions version '1.0.0' called Common
include CDSConnectCommonsforFHIRv401 version '1.0.0' called C3F

codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'

code "Breast cancer in remission < 5 years": 'hxbreastcawithin5y' from "LOCAL" display 'Breast cancer in remission < 5 years'

parameter encounter String default null
parameter ObservationLookbackPeriod default 14 days

context Patient

define "eve-geneticrisk":
  DataElements."de-geneticrisk"

define "eve-chestxrt":
  DataElements."de-chestxrtage10to30"

define "eve-hxbreastca":
  exists DataElements."de-hxbreastca"

define "eve-hxbreastcawithin5y":
  exists BreastCancerWithin5YEncounter or exists BreastCancerWithin5YLookback or
    exists DataElements."de-hxbreastca" C where Today() before C.abatement.value + 5 years  

define "eve-atypicalbx":
  DataElements."de-atypicalbx"

define "eve-nolifetimerisk":
  DataElements."MostRecentLifetimeRiskAssessment" is null or
  DataElements."MostRecentAtypicalBiopsyDate" after Common.ObservationDate(DataElements."MostRecentLifetimeRiskAssessment")

define "eve-highlifetimerisk":
  DataElements."de-highlifetimerisk"

define "eve-acsgeneticrisk":
  DataElements."de-acsgeneticrisk"

define BreastCancerWithin5YEncounter:
  BreastCancerWithin5YObservations O where O.encounter.reference = encounter

define BreastCancerWithin5YLookback:
  C3F.ObservationLookBack(
    BreastCancerWithin5YObservations,
    ObservationLookbackPeriod
  ) 

define BreastCancerWithin5YObservations:
  [Observation: "Breast cancer in remission < 5 years"]

