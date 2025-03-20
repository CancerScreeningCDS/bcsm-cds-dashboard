import { useParams, useSearchParams } from 'react-router-dom';
import { Navigate } from 'react-router-dom';
import { useState } from 'react';
import Dashboard from 'features/Dashboard';
import { useCds } from 'hooks/useCds';
import './TestPatient.scss';

// Load the test data and configuration
//import { testData } from './testData.js';
import { config } from './test.config.js';
import { testData } from './patientData.js';



export function TestPatient() {
  let params = useParams();
  const [patientData, setPatientData] = useState([]);
  
  let [searchParams, setSearchParams] = useSearchParams();
  const library = searchParams.get("library")

  const [toggleStatus, setToggleStatus] = useState({
    isImmunosuppressed: false,
    hasCurrentBreastCancer: false,
    hasGeneticMarkers: false,
    hasBreastDiseaseSymptoms: false,
    hasBreastExamFindings: false,
    isPregnant: false,
    isPregnantConcerned: false,
    isSymptomatic: false,
    isToggleChanged: false
  });
  const {output: dashboardInput, isLoadingCdsData } = useCds(patientData, toggleStatus, library);
  const isLoading = isLoadingCdsData;
  // Extract the data for the requested test patient
  if (params.testName in testData) {
    if (patientData.length === 0) {
      // Assumes all test patient data is in a Bundle
      const newData = testData[params.testName].entry.map((c) => {
       return (c.resource) ? c.resource : {};
      })
      setPatientData(newData);
    }

    // Return the Dashboard with a testing disclaimer at the top
    return (
      <div className="content">
        <p><a href="/tests-fhir/">Home</a></p>
        <p className="sticky-banner alert alert-danger">NOTE: ALL CLINICAL ITEMS ARE NOTIONAL - FOR PURPOSES OF DEMONSTRATION ONLY</p>
        <div className="dashboard-container">
          {isLoading && (
            <div className="overlay">
              <div className="spinner"></div>
            </div>
          )}
        <h1 className="h5">Pathway: {library}</h1>
        <Dashboard 
          input={dashboardInput} 
          config={config} 
          setPatientData={setPatientData}
          toggleStatus={toggleStatus}
          onToggleStatusChange={setToggleStatus}
        />
      </div>
      </div>
    )
  } else {
    // TODO: Route back to TestPatientSelector
    return <Navigate to="/tests-fhir" replace={true} />
  }
  
}