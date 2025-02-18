library AverageRiskEvents version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements

context Patient

define "eve-ageUnder40":
  AgeInYears < 40

define "eve-age40to44":
  AgeInYears >= 40 and AgeInYears <= 44

define "eve-Age45to54":
  AgeInYears >= 45 and AgeInYears <= 54

define "eve-AgeOver54":
  AgeInYears > 54

define AgeInYears:
  AgeInYears()
