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

library HighRiskExclusionsEvents version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements
include CSMCommonFunctions version '1.0.0' called Common
include CDSConnectCommonsforFHIRv401 version '1.0.0' called C3F

codesystem "LOCAL": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system'

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
  DataElements."de-hxbreastcawithin5y"

define "eve-atypicalbx":
  DataElements."de-atypicalbx"

define "eve-nolifetimerisk":
  DataElements."MostRecentLifetimeRiskAssessment" is null or
  DataElements."MostRecentAtypicalBiopsyDate" after Common.ObservationDate(DataElements."MostRecentLifetimeRiskAssessment")

define "eve-highlifetimerisk":
  DataElements."de-highlifetimerisk"

define "eve-acsgeneticrisk":
  DataElements."de-acsgeneticrisk"       

