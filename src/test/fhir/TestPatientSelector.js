import logo from 'assets/bcsm-tulip.svg';
import './TestPatientSelector.scss';
import { Table } from 'react-bootstrap';
import { Link } from 'react-router-dom';

import screeningData from './bundles/PrimaryScreeningDecision_v1.0.0/PrimaryScreeningDecision.json';
import geneticRiskData from './bundles/GeneticRiskReferral_v1.0.0/GeneticRiskReferral.json'
import highRiskData from './bundles/HighRiskReferral_v1.0.0/HighRiskReferral.json'

const screeningPad = 1;

const geneticRiskPad = screeningPad + screeningData.length;

const highRiskPad = geneticRiskPad + geneticRiskData.length;

export function TestPatientSelector() {
  return (
    <div>
      <div className="hero">
        <img src={logo} alt="Breast Cancer CDS Tulip logo"/>
        <h1 className="public-sans-900">BCSM-CDS</h1>
        <h2 className="subtitle">Breast Cancer Screening and Management<br/>Clinical Decision Support</h2>
      </div>

      <h3>FHIR Test Patients</h3>
      <b>Authors:</b> Neelima Karipineni (<a href="mailto:nkaripineni@mitre.org">nkaripineni@mitre.org</a>), 
      Rute Martins (<a href="mailto:anarute@mitre.org">anarute@mitre.org</a>)<br/>
      <b>Last Updated:</b> Feb 17, 2025<br/>

      <div className="sitemap">

        <Table className="index-table">

          <thead>
            <tr>
              <th><span className="visually-hidden">Sample Patient Number</span></th>
              <th>Sample Patient Name</th>
              <th>Age</th>
              <th>Type of Scenario</th>
              <th>Last Update</th>
            </tr>
          </thead>

          <tbody>
            <tr className="group">
              <td colSpan="6">Primary Decision to Screen</td>
            </tr>
            { screeningData.map((rd,idx) => <IndexRow key={idx} index={screeningPad+idx} rowData={rd} library="PrimaryScreeningDecision" />) }
            
            <tr className="group">
              <td colSpan="6">Genetic Risk Referral</td>
            </tr>
            { geneticRiskData.map((rd,idx) => <IndexRow key={idx} index={geneticRiskPad+idx} rowData={rd} library="flow-GeneticRiskReferral" />) }

            <tr className="group">
              <td colSpan="6">High Risk Referral</td>
            </tr>
            { highRiskData.map((rd,idx) => <IndexRow key={idx} index={highRiskPad+idx} rowData={rd} library="flow-HighRiskReferral" />) }

          </tbody>
        </Table>

      </div>

      <h3>Notes</h3>
      <ul className="notelist">
        <li>Patient names follow the convention used by the synthetic-patient generator <a href="https://github.com/synthetichealth/synthea">Synthea&trade;</a>. Random digits are appended to the patient's name to indicate they are artificially generated, and <b>never</b> based on any real person who may have the same name.</li>
        <li>Real-world patients may have incomplete or irregular patient histories which <b>do not</b> follow best clinical practices. Some of the demonstration patients shown here have care histories designed to reflect these real-world problems.</li>
        <li>This is a work in progress and does not represent final versions of style, formatting or layout.</li>
      </ul>

    </div>
  )
}

function IndexRow(props) {
  const {index, rowData, library} = props;
  return (
    <tr>
      <td>{index}</td>
      <td><Link to={'/tests-fhir/'+rowData['id']+'?library='+library}>{rowData['name']}</Link></td>
      <td>{rowData['age']}</td>
      <td>{rowData['scenario']}</td>
      <td className="text-nowrap">{rowData['updated']}</td>
    </tr>
  )
}

