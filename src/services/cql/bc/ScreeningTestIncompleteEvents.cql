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

library ScreeningTestIncompleteEvents version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include DataElements version '1.0.0' called DataElements
include CDSConnectCommonsforFHIRv401 version '1.0.0' called C3F
include CSMCommonFunctions version '1.0.0' called Common
include BCSMCommonFunctions version '1.0.0' called BCSMCommon

context Patient

define "eve-pendingorders":
  ActiveBreastCancerScreeningOrders union 
  CompletedOrdersWithoutResults

define "eve-pendingprocedures":
  CompletedProceduresWithoutResults

define "eve-pendingpathology":
  IncompleteBreastBiopsyDiagnosticReports  

//------------------------------------------------------------------------------
// ORDERS
//------------------------------------------------------------------------------ 

define CompletedOrdersWithoutResults:
  if not exists DataElements.BreastImagingObservations 
      and not exists DataElements.BiopsyObservations
    then CompletedOrdersWithoutSubsequentReport
  else
    from CompletedOrdersWithoutSubsequentReport O,
      (DataElements.BreastImagingObservations union DataElements.BiopsyObservations) Obs
    where not Exists (Obs.basedOn B where B.reference = 'ServiceRequest/' + O.id)
    return O

define CompletedOrdersWithoutSubsequentReport:
  CompletedOrdersWithoutDiagnosticReport O
  let lastReportDate: LastReportDateByCode(O.code)
  where LastReportNotAfterOccurrenceDateTime(O.occurrence as FHIR.dateTime, lastReportDate)
    or LastReportNotAfterOccurrencePeriod(O.occurrence as FHIR.Period, lastReportDate)    

define CompletedOrdersWithoutDiagnosticReport:
  if not exists DataElements.CompletedBreastCancerScreeningDiagnosticReports
    then CompletedBreastCancerScreeningOrders
  else
    from CompletedBreastCancerScreeningOrders O,
      DataElements.CompletedBreastCancerScreeningDiagnosticReports DR
    where not Exists (DR.basedOn B where B.reference = 'ServiceRequest/' + O.id)
    return O

define CompletedBreastCancerScreeningOrders:
  BreastCancerScreeningOrders O
    where O.status in {'completed'}

define ActiveBreastCancerScreeningOrders:
  BreastCancerScreeningOrders O
    where O.status in {'active'}

define BreastCancerScreeningOrders:  
  ([ServiceRequest: DataElements."Breast Cancer Imaging Orders"] union [ServiceRequest: DataElements."Breast Cancer Biopsy Orders"]) O
    where BCSMCommon.ServiceRequestWithOrderIntent(O)

//------------------------------------------------------------------------------
// PROCEDURES
//------------------------------------------------------------------------------ 

define CompletedProceduresWithoutResults:
  if not exists DataElements.BreastImagingObservations 
      and not exists DataElements.BiopsyObservations
    then CompletedProceduresWithoutSubsequentReport
  else
    from CompletedProceduresWithoutSubsequentReport P,
      (DataElements.BreastImagingObservations union DataElements.BiopsyObservations) Obs
    where not Exists (Obs.basedOn B where B.reference = 'Procedure/' + P.id)
    and not Exists( (Obs.basedOn) oB where AnyTrue((P.basedOn) pB return pB = oB ) )
    return P

define CompletedProceduresWithoutSubsequentReport:
  CompletedProceduresWithoutDiagnosticReport P
  let lastReportDate: LastReportDateByCode(P.code)
  where LastReportNotAfterOccurrenceDateTime(P.performed as FHIR.dateTime, lastReportDate)
    or LastReportNotAfterOccurrencePeriod(P.performed as FHIR.Period, lastReportDate)    

define CompletedProceduresWithoutDiagnosticReport:
  if not exists DataElements.CompletedBreastCancerScreeningDiagnosticReports
    then CompletedBreastCancerScreeningProcedures
  else
    from CompletedBreastCancerScreeningProcedures P,
      DataElements.CompletedBreastCancerScreeningDiagnosticReports DR
    where not Exists (DR.basedOn B where B.reference = 'Procedure/' + P.id)
    return P

define CompletedBreastCancerScreeningProcedures:
  BreastCancerScreeningProcedures P
    where P.status in {'completed'}

define BreastCancerScreeningProcedures:
  BreastCancerScreeningOrderedProcedures union
  [Procedure] P
    where P.code in DataElements."Breast Cancer Imaging Orders"
     or P.code in DataElements."Breast Cancer Biopsy Orders"

define BreastCancerScreeningOrderedProcedures:
  from CompletedBreastCancerScreeningOrders O,
    [Procedure] P
  where Exists (P.basedOn B where B.reference = 'ServiceRequest/' + O.id)
    return P

//------------------------------------------------------------------------------
// DIAGNOSTIC REPORTS
//------------------------------------------------------------------------------ 

define IncompleteBreastBiopsyDiagnosticReports:
  DataElements.IncompleteBreastBiopsyDiagnosticReports

//------------------------------------------------------------------------------
// Functions
//------------------------------------------------------------------------------ 

define function LastReportDateByCode(code FHIR.CodeableConcept):
  code C
  let lastReport: BCSMCommon.MostRecentDiagnosticReportByCode(C),
  lastReportDate: Common.DiagnosticReportDate(lastReport)
  return lastReportDate

define function LastReportNotAfterOccurrenceDateTime(occurrence FHIR.dateTime, lastReportDate System.DateTime):
  lastReportDate is null 
    or (occurrence is not null and lastReportDate <= occurrence) 

define function LastReportNotAfterOccurrencePeriod(occurrence FHIR.Period, lastReportDate System.DateTime):
  lastReportDate is null
    or (occurrence is not null and lastReportDate before C3F.PeriodToInterval(occurrence))