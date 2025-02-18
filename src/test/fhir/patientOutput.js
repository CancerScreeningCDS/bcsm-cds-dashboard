import JaniceMedford from './bundles/PrimaryScreeningDecision_v1.0.0/PrimaryScreeningDecision_JaniceMedford_fdr_breastca_age_45.json';
import JosephineGreene from './bundles/PrimaryScreeningDecision_v1.0.0/PrimaryScreeningDecision_JosephineGreene-past-breast-pain-adh-biopsy.json';
import JustineWallace from './bundles/PrimaryScreeningDecision_v1.0.0/PrimaryScreeningDecision_JustineWallace_brca1.json';
import LindaNadler from './bundles/PrimaryScreeningDecision_v1.0.0/PrimaryScreeningDecision_LindaNadler-dcis.json';
import MarionHenderson from './bundles/PrimaryScreeningDecision_v1.0.0/PrimaryScreeningDecision_MarionHenderson_avg_45_to_54.json';
import NadiaWills from './bundles/PrimaryScreeningDecision_v1.0.0/PrimaryScreeningDecision_NadiaWills_palpable_breast_mass.json';
import PatriciaLambert from './bundles/PrimaryScreeningDecision_v1.0.0/PrimaryScreeningDecision_PatriciaLambert_remission_lt_5_years.json';

import GR_JaniceMedford from './bundles/GeneticRiskReferral_v1.0.0/GeneticRiskReferral_JaniceMedford_fdr_breastca_age_45.json'

import HR_JosephineGreene from './bundles/HighRiskReferral_v1.0.0/HighRiskReferral_JosephineGreene-past-breast-pain-adh-biopsy.json';
import HR_JustineWallace from './bundles/HighRiskReferral_v1.0.0/HighRiskReferral_JustineWallace_brca1.json'
export const testOutput = {
  PrimaryScreeningDecision: {
    JaniceMedford : JaniceMedford,
    JosephineGreene : JosephineGreene,
    JustineWallace : JustineWallace,
    LindaNadler : LindaNadler,
    MarionHenderson : MarionHenderson,
    NadiaWills : NadiaWills,
    PatriciaLambert : PatriciaLambert
  },
  HighRiskReferral: {
    JosephineGreene : HR_JosephineGreene,
    JustineWallace : HR_JustineWallace
    
  },
  GeneticRiskReferral: {
    JaniceMedford: GR_JaniceMedford
  }
}