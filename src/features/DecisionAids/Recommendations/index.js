import { Alert, Button, Card } from 'react-bootstrap';
import React, { useEffect, useState } from 'react';
import ViewDataDialog from 'components/ViewDataDialog';
import RiskEstimates from 'features/DecisionAids/RiskEstimates';
import SpecialConsiderations from 'features/SpecialConsiderations';
import { formatDate } from 'util/formatDate';

import './style.scss';
function RecommendationCardBody({
  errors,
  isCdsApplied,
  recommendation,
  recommendationDate,
  recommendationDetails,
  recommendationGroup,
  documentation,
  disclaimer,
  suggestedOrders,
  setDataToView
}) {
  const [show, setShow] = useState(errors.length > 0 || disclaimer !== '');
  useEffect(() => {
    if (errors.length > 0 || disclaimer !== '') setShow(true);
    else setShow(false);
  }, [errors, disclaimer]);
  return (
    <Card.Body>
      <Card.Title as='h3'>
        {
          errors.length > 0 ?
            <i className='bi bi-exclamation-triangle-fill text-danger'></i> :
            null
        }
        {
          errors.length > 0 ? 'Cannot Make Recommendation'
            : !isCdsApplied ? 'Loading Recommendation ...'
              : recommendation.length === 0 ? 'Cannot Make Recommendation'
                : recommendation
        }
      </Card.Title>
      <Card.Subtitle as='h4'>
        <div>{recommendationDate !== null && recommendationDate !== ''  ? 'Due: ' + formatDate(recommendationDate) : null}</div>
      </Card.Subtitle>
      {
        !isCdsApplied || errors.length > 0 ? ''
          : recommendation.length === 0 ?
            <Card.Text>The guidelines do not provide any recommendation for this case. Please use clinical judgement.</Card.Text>
            : recommendationDetails.map((detail, idx) => {
              return <Card.Text key={idx}>{detail}</Card.Text>
            })
      }
      <div className="recommendation-group-text">{recommendationGroup}</div>
      {documentation.map((doc) => {
      if (doc.type == 'citation') {
        return (<React.Fragment key={doc.label}>
          <span className="fw-bold">Source:</span>{" "}
          <a href={doc.url} target="_blank" rel="noopener noreferrer">
            {doc.label}
          </a><br />
        </React.Fragment>
        )
        } 
      }
      )}

      <Alert
        show={show}
        variant={errors.length > 0 ? 'danger' : 'warning'}
        dismissible={errors.length === 0}
        onClose={() => setShow(false)}
      >
        {
          errors.length > 0 ?
            errors.map((err, idx) => <span key={idx}>{err}</span>) :
            disclaimer
        }
      </Alert>
      {/* <RecommendationFooter areErrs={errors.length > 0} sugOrds={suggestedOrders} setDataToView={setDataToView} />
      <ViewDataDialog resolver={resolver} dataToView={dataToView} setDataToView={setDataToView} /> */}
    </Card.Body>
  );
}

function Recommendations({ inputs, toggleStatus, onToggleStatusChange }) {
  const [dataToView, setDataToView] = useState({ form: '', data: '' });
  const isCdsApplied = inputs.isCdsApplied;
  return (
    <div>
      <SpecialConsiderations toggleStatus={toggleStatus} onToggleStatusChange={onToggleStatusChange} />
      <Card>
        <Card.Header>Screening and Management Recommendation</Card.Header>
        {Array.isArray(inputs) ? inputs.map((input, index) => {
          let {
            recommendation = '',
            recommendationGroup = '',
            recommendationDetails = [],
            recommendationDate = '',
            documentation = [],
            errors = [],
            disclaimer = '',
            suggestedOrders = '',
            riskTable = {},
          } = input;
          if (riskTable === null) riskTable = {};
          else {
            if (riskTable?.relevant?.immediateRisk && riskTable.relevant.immediateRisk === -1) {
              riskTable.relevant.immediateRisk = 'N/A';
            }
            if (riskTable?.relevant?.fiveYearRisk && riskTable.relevant.fiveYearRisk === -1) {
              riskTable.relevant.fiveYearRisk = 'N/A';
            }
          }

          return (
            <React.Fragment key = {index}>
              <RecommendationCardBody
                errors={errors}
                isCdsApplied={isCdsApplied}
                recommendation={recommendation}
                recommendationDate={recommendationDate}
                recommendationDetails={recommendationDetails}
                recommendationGroup={recommendationGroup}
                documentation={documentation}
                disclaimer={disclaimer}
                suggestedOrders={suggestedOrders}
                setDataToView={setDataToView}
              />
              <RiskEstimates input={riskTable} />
            </React.Fragment>
          );
        }) : 'Loading'}
      </Card>

    </div>
  );
}
function RecommendationFooter(props) {
  const {
    areErrs,
    sugOrds,
    setDataToView
  } = props;
  if (areErrs) return null
  else if (sugOrds.length === 0) return null //return <Alert variant='info'>No Action Necessary</Alert>
  else return sugOrds.map(sugOrds => {
    let [order, reference] = Object.entries(sugOrds)[0];
    return <Button key={order} onClick={() => setDataToView({ form: '', data: reference })}> Order {order} </Button>
  });
}

export default Recommendations;