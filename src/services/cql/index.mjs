import AverageRisk from './bc/AverageRisk.json';
import AverageRiskActions from './bc/AverageRiskActions.json';
import AverageRiskEvents from './bc/AverageRiskEvents.json';
import BCSMCommonFunctions from './bc/BCSMCommonFunctions.json';
import CDSConnectCommonsforFHIRv401 from './bc/CDSConnectCommonsforFHIRv401.json';
import CSMCommonFunctions from './bc/CSMCommonFunctions.json';
import DataElements from './bc/DataElements.json';
import DecisionToScreen from './bc/DecisionToScreen.json';
import DecisionToScreenActions from './bc/DecisionToScreenActions.json';
import DecisionToScreenEvents from './bc/DecisionToScreenEvents.json';
import FHIRHelpers from './bc/FHIRHelpers-4.0.1.json';
import FollowupScreeningResult from './bc/FollowupScreeningResult.json';
import FollowupScreeningResultActions from './bc/FollowupScreeningResultActions.json';
import FollowupScreeningResultEvents from './bc/FollowupScreeningResultEvents.json';
import GeneticRiskReferral from './bc/GeneticRiskReferral.json';
import GeneticRiskReferralActions from './bc/GeneticRiskReferralActions.json';
import GeneticRiskReferralEvents from './bc/GeneticRiskReferralEvents.json';
import HighRiskExclusions from './bc/HighRiskExclusions.json';
import HighRiskExclusionsActions from './bc/HighRiskExclusionsActions.json';
import HighRiskExclusionsEvents from './bc/HighRiskExclusionsEvents.json';
import HighRiskReferral from './bc/HighRiskReferral.json';
import HighRiskReferralActions from './bc/HighRiskReferralActions.json';
import HighRiskReferralEvents from './bc/HighRiskReferralEvents.json';
import Hospice from './bc/Hospice.json';
import PertinentHistory from './bc/PertinentHistory.json';
import PrimaryScreeningDecision from './bc/PrimaryScreeningDecision.json';
import ScreeningDue from './bc/ScreeningDue.json';
import ScreeningDueEvents from './bc/ScreeningDueEvents.json';
import ScreeningEligible from './bc/ScreeningEligible.json';
import ScreeningEligibleActions from './bc/ScreeningEligibleActions.json';
import ScreeningEligibleEvents from './bc/ScreeningEligibleEvents.json';
import ScreeningTestIncomplete from './bc/ScreeningTestIncomplete.json';
import ScreeningTestIncompleteEvents from './bc/ScreeningTestIncompleteEvents.json';
import SpecialPopulations from './bc/SpecialPopulations.json';
import SpecialPopulationsActions from './bc/SpecialPopulationsActions.json';
import SpecialPopulationsEvents from './bc/SpecialPopulationsEvents.json';

const elmJsonDependencyArray = [
    AverageRisk, AverageRiskActions, AverageRiskEvents, BCSMCommonFunctions, 
    CDSConnectCommonsforFHIRv401, CSMCommonFunctions, DataElements, DecisionToScreen, 
    DecisionToScreenActions, DecisionToScreenEvents, FHIRHelpers, FollowupScreeningResult, 
    FollowupScreeningResultActions, FollowupScreeningResultEvents, GeneticRiskReferral, 
    GeneticRiskReferralActions, GeneticRiskReferralEvents, HighRiskExclusions, 
    HighRiskExclusionsActions, HighRiskExclusionsEvents, HighRiskReferral, 
    HighRiskReferralActions, HighRiskReferralEvents, Hospice, PertinentHistory, 
    PrimaryScreeningDecision, ScreeningDue, ScreeningDueEvents, ScreeningEligible, 
    ScreeningEligibleActions, ScreeningEligibleEvents, ScreeningTestIncomplete, 
    ScreeningTestIncompleteEvents, SpecialPopulations, SpecialPopulationsActions, 
    SpecialPopulationsEvents
];

// Reformat ELM JSON value set references to match what is expected by the 
// code service built into the cql execution engine.
// NOTE: This is needed since we are not using `cql-exec-vsac`.
export const elmJsonDependencies = elmJsonDependencyArray.reduce((acc, elm) => {
  let refs = elm?.library?.valueSets?.def;
  if (refs) {
    refs = refs.map(r => {
      return {
        ...r,
        id: r.id.split('/').pop()
      }
    });
    elm.library.valueSets.def = refs;
  }
  return {
    ...acc,
    [elm.library.identifier.id]: elm
  }
}, {});