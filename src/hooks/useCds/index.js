import { useEffect, useState } from 'react';
import { applyPlan, simpleResolver } from 'encender';
import { elmJsonDependencies } from 'services/cql/index.mjs';
import { cdsResources } from 'services/fhir';
import { valueSetJson } from 'services/valuesets';
import { translateResponse, translateToggleChange } from './translate';
import { stridesData } from './strides';
import { logMsg } from 'util/logger';
import { testData } from 'test/fhir/patientData';
import { testOutput } from 'test/fhir/patientOutput';

import hardCodeData from '../../test/fhir/bundles/PrimaryScreeningDecision_v1.0.0/PrimaryScreeningDecision_JaniceMedford_fdr_breastca_age_45.json'
import patientDataJ from '../../test/fhir/bundles/patients/JaniceMedford_fdr_breastca_age_45.json'
import cql, { Results } from 'cql-execution';
import cqlfhir, { PatientSource } from 'cql-exec-fhir';
import { initialzieCqlWorker } from 'cql-worker';

const LOGGER_ENABLED = process.env?.REACT_APP_LOGGER_ENABLED || false;
/**
 *
 * @param {Object[]} patientData
 * @returns {Object}
 */
export const useCds = (patientData, toggleStatus, pathway) => {

  const [output, setOutput] = useState({});
  const [isLoadingCdsData, setIsLoadingCdsData] = useState(false);
  const [isPregnant, setIsPreganant] = useState(false);
  useEffect(() => {
    if (patientData.length === 0) {
      return;
    }

    setIsLoadingCdsData(true);

    console.log('toggleStatus: ', toggleStatus);
    console.log('patientData before translation: ', patientData);
    console.time('Translate FHIR Data');

    if (toggleStatus.isToggleChanged) {
      translateToggleChange(patientData, toggleStatus);
    } else {
      translateResponse(patientData, stridesData);
    }

    console.timeEnd('Translate FHIR Data');
    console.log('patientData after translation: ', patientData);

    applyCds(patientData, setOutput, setIsLoadingCdsData, toggleStatus.isToggleChanged, isPregnant, setIsPreganant, pathway);
  }, [patientData, toggleStatus, isPregnant]);

  return {output, isLoadingCdsData};
}

/**
 *
 * @param {Object[]} patientData
 * @param {function} setOutput
 */
const applyCds = async function(patientData, setOutput, setIsLoadingCdsData, isToggleChanged, isPregnant, setIsPreganant, pathway) {
  console.log('Starting applyCds()');
  console.time('Apply CDS');

  let resolver = simpleResolver([...cdsResources, ...patientData], false);
  const planDefinition = resolver('PlanDefinition/CervicalCancerScreeningAndManagementClinicalDecisionSupport')[0];
  // TODO: Throw error if there is anything other than 1 patient resource
  const patientId = patientData.filter(pd => pd.resourceType === 'Patient').map(pd => pd.id)[0]
  const patientReference = 'Patient/' + patientId;
  
  if (patientReference !== 'Patient/undefined') {
    // NOTE: CQL Worker is not used with cql-execution branch of encender
    const WorkerFactory = () => {
      return new Worker(new URL('../../../node_modules/cql-worker/src/cql.worker.js', import.meta.url))
    };
    
    // TODO: Move cqlParameters to a separate file within this directory and import them into this file
    const cqlParameters = {
      CervicalCytologyLookbackDate : '2017-04-04'
    };

    const aux = {
      elmJsonDependencies,
      valueSetJson,
      WorkerFactory,
      cqlParameters
    };
    const measure = elmJsonDependencies.PertinentHistory;
    let repository = new cql.Repository(elmJsonDependencies);
    const codeService = new cql.CodeService(valueSetJson);
    const lib = new cql.Library(measure, repository);
    const executor = new cql.Executor(lib, codeService, cqlParameters);
    const psource = cqlfhir.PatientSource.FHIRv401();
    psource.loadBundles(testData[patientId]);
    const result = await executor.exec(psource);
    const cqlResults = result?.patientResults?.[Object.keys(result.patientResults)?.[0]];
    let patientInfo={};
    let patientHistory={};
    if(cqlResults) {
      patientInfo = cqlResults.PertinentHistory.patientInfo;
      patientHistory = cqlResults.PertinentHistory.patientHistory;
    }
    const resources = testOutput[pathway][patientId].entry.map((e) => {
      return e.resource
    });
    // const [CarePlan, RequestGroup, ...otherResources] = await applyPlan(planDefinition, patientReference, resolver, aux);
    const [CarePlan, RequestGroup, ...otherResources] = resources;


    let ServiceRequests = otherResources.filter(otr => otr.resourceType === 'ServiceRequest');
    let PrimaryHpvRequest = ServiceRequests.filter(sr => sr.code.text === 'Primary HPV')[0];
    let CytologyRequest = ServiceRequests.filter(sr => sr.code.text === 'Cytology')[0];
    let CotestRequest = ServiceRequests.filter(sr => sr.code.text === 'Cotest')[0];
    let ColposcopyRequest = ServiceRequests.filter(sr => sr.code.text === 'Colposcopy')[0];
    let SurveillanceRequest = ServiceRequests.filter(sr => sr.code.text === 'Surveillance')[0];
    let TreatmentRequest = ServiceRequests.filter(sr => sr.code.text === 'Treatment')[0];

    resolver = simpleResolver(
      [
        ...cdsResources,
        ...patientData,
        ...ServiceRequests
      ],
      false
    );

    console.log('CarePlan: ', CarePlan);
    console.log('RequestGroup: ', RequestGroup);
    console.log('otherResources: ', otherResources);


    let decisionAids=[];
    decisionAids = recursiveActionParse(RequestGroup.action, decisionAids, resolver);

    let thereAreOutputs = false;

    // replace with actual logging data when ready from CQL 
    // output otherResources as a temporary stand-in
    console.timeEnd('Apply CDS');

    if (LOGGER_ENABLED){
      logMsg({
        timeRequestSent: new Date(),
        patientReference: patientReference,
        payload: [patientInfo, decisionAids]
      });
    }
    
    if (thereAreOutputs) {
      if (patientHistory.observations?.length > 0) {
        patientHistory.observations = patientHistory.observations.filter(obs => !obs.reference.includes('new-observation-for-'))
      }

      if (isToggleChanged) {
        patientInfo.isPregnant = isPregnant;
      } else {
        setIsPreganant(patientInfo.isPregnant);
      }
    }

    decisionAids.isCdsApplied = true;

    const output = {
      patientInfo,
      patientHistory,
      decisionAids,
      resolver: (r) => r === '' ? {} : resolver(r),
      patientReference
    }

    console.log('CDS output:', output);
    setIsLoadingCdsData(false);
    setOutput(output);
  }

}

function recursiveActionParse(actions, decisionAids, resolver) {
    actions.forEach((act)=> {
      const entry = {
        recommendation:'',
        recommendationGroup:'',
        recommendationDetails:[],
        recommendationDate:'',
        documentation: [],
        errors:[],
        disclaimer:'', // not neccessary?
        suggestedOrders:'',// not used
        riskTable:{},
      }
      entry.recommendation = act.title;
      if (act.resource) {
        
        const serviceReq = resolver(act.resource.reference)?.[0];
        entry.recommendationGroup = getReasonCodeDisplay(serviceReq);
      }

      entry.recommendationDetails.push(act.description);
      entry.recommendationDate = getTimingDateFromAction(act);
      if(act.documentation){
        entry.documentation = act.documentation;
      }
      decisionAids.push(entry);
    })
  return decisionAids;
  
}
// util
function getReasonCodeDisplay(serviceRequest) {
    if (!serviceRequest || !serviceRequest.reasonCode || !Array.isArray(serviceRequest.reasonCode)) {
        return null;
    }

    let display = null;

    serviceRequest.reasonCode.forEach(reason => {
        if (reason && reason.coding && Array.isArray(reason.coding)) {
            reason.coding.forEach(coding => {
                if (coding && coding.display && display === null) {
                    display = coding.display;
                }
            });
        }
    });
    return display;
}

function getTimingDateFromAction(action) {
  if (!action) {
      return null;
  }

  let timingDate = null;
  if (action.timingDateTime) {
      timingDate = action.timingDateTime;
  } else if (action.timingPeriod && action.timingPeriod.start) {
      timingDate = action.timingPeriod.start;
  } else if (action.timingPeriod && action.timingPeriod.end) {
      timingDate = action.timingPeriod.end;
  } else if (action.timingRange && action.timingRange.low && action.timingRange.low.value) {
      timingDate = action.timingRange.low.value;
  } else if (action.timingRange && action.timingRange.high && action.timingRange.high.value) {
      timingDate = action.timingRange.high.value;
  } else if (action.timingTiming && action.timingTiming.event && action.timingTiming.event.length > 0) {
      timingDate = action.timingTiming.event[0];
  }

  return timingDate;
}