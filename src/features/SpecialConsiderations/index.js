import { Alert, Card, Button } from 'react-bootstrap';
import IconTooltip from 'components/IconTooltip';
import { useEffect, useState, useRef } from 'react';
import './style.scss';



function SpecialConsiderations(props) {
  let {
    toggleStatus,
    onToggleStatusChange
  } = props;


  const [show, setShow] = useState(false);

  const toggleNote = () => {
    setShow(!show);
  }

  const handleGeneticMarkersChange = (event) => {
    onToggleStatusChange({ ...toggleStatus, hasGeneticMarkers: event.target.checked, isToggleChanged: true });
  };

  const handleCurrentBreastCancerChange = (event) => {
    onToggleStatusChange({ ...toggleStatus, hasCurrentBreastCancer: event.target.checked, isToggleChanged: true });
  };

  const handleBreastDiseaseSymptomsChange = (event) => {
    onToggleStatusChange({ ...toggleStatus, hasBreastDiseaseSymptoms: event.target.checked, isToggleChanged: true });
  };

  const handleBreastExamFindingsChange = (event) => {
    onToggleStatusChange({ ...toggleStatus, hasBreastExamFindings: event.target.checked, isToggleChanged: true });
  };
  
  const handleFdrGeneticChange = (event) => {
    onToggleStatusChange({ ...toggleStatus, hasFdrGenetic: event.target.checked, isToggleChanged: true });
  };

  const handleFdrCancerChange = (event) => {
    onToggleStatusChange({ ...toggleStatus, hasFdrCancer: event.target.checked, isToggleChanged: true });
  };


  return (
    <section id="special_considerations">
      <h2>Personal History Considerations (<Button variant="link" className="btn-toggle-link" data-bs-toggle="collapse" role="button" aria-expanded="false" onClick={toggleNote} aria-controls="specialConsiderationsNote">note</Button>)</h2>
      <Alert
        show={show}
        variant={'info'}
        dismissible
        onClose={() => setShow(false)}
      >
      Use these options to indicate patient considerations that may not be documented or available to the CDS. Selecting one or more of these will cause the CDS to consider these when providing a recommendation. This <b>may or may not</b> cause the recommendation to change, depending on the specific patient history.
      </Alert>

      <div className="form-check form-switch">
        <input className="form-check-input" type="checkbox" role="switch" id="force_hasGeneticMarkers" checked={toggleStatus.hasGeneticMarkers} onChange={handleGeneticMarkersChange} />
        <label className="form-check-label" htmlFor="force_hasGeneticMarkers">Heriditary genetic markers of unknown variant</label>
        <IconTooltip text="Does the patient have relevant genetic markers?"></IconTooltip>
      </div>
      <div className="form-check form-switch">
        <input className="form-check-input" type="checkbox" role="switch" id="force_hasCurrentBreastCancer" checked={toggleStatus.hasCurrentBreastCancer} onChange={handleCurrentBreastCancerChange} />
        <label className="form-check-label" htmlFor="force_hasCurrentBreastCancer">Current breast cancer</label>
        <IconTooltip text="Does the patient have current breast cancer?"></IconTooltip>
      </div>
      <div className="form-check form-switch">
        <input className="form-check-input" type="checkbox" role="switch" id="force_hasBreastDiseaseSymptoms" checked={toggleStatus.hasBreastDiseaseSymptoms} onChange={handleBreastDiseaseSymptomsChange}/>
        <label className="form-check-label" htmlFor="force_hasBreastDiseaseSymptoms">New or worsening breast disease symptoms</label>
        <IconTooltip text="Does the patient have symptoms of breast disease?"></IconTooltip>
      </div>
      <div className="form-check form-switch">
        <input className="form-check-input" type="checkbox" role="switch" id="force_hasBreastExamFindings" checked={toggleStatus.hasBreastExamFindings} onChange={handleBreastExamFindingsChange} />
        <label className="form-check-label" htmlFor="force_hasBreastExamFindings">New or worsening breast exam findings?</label>
        <IconTooltip text="Does the patient have findings after a breast exam?"></IconTooltip>
      </div>
      <hr />
      <h2>Family History Considerations</h2>
      <div className="form-check form-switch">
        <input className="form-check-input" type="checkbox" role="switch" id="force_hasFdrGenetic" checked={toggleStatus.hasFdrGenetic} onChange={handleFdrGeneticChange} />
        <label className="form-check-label" htmlFor="force_hasFdrGenetic">First degree relative with genetic marker or syndrome</label>
        <IconTooltip text="Does the patient have first degree relative with relevant genetic markers?"></IconTooltip>
      </div>
      <div className="form-check form-switch">
        <input className="form-check-input" type="checkbox" role="switch" id="force_hasFdrCancer" checked={toggleStatus.hasFdrCancer} onChange={handleFdrCancerChange} />
        <label className="form-check-label" htmlFor="force_hasFdrCancer">First degree relative with breast cancer diagnosis</label>
        <IconTooltip text="Does the patient have any first degree relatives who received a breast cancer diagnosis?"></IconTooltip>
      </div>
      <hr />
    </section>
  )
}

export default SpecialConsiderations;
