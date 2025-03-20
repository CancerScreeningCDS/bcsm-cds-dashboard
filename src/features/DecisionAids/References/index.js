import './style.scss';

function References(props) {
  const { 
    input: {
      references=[]
    } 
  } = props;

  return (
    <article>
     <div className="cds-reference">
       <div className="document-list">
          <h4>Documents & Guidelines</h4>
          <ul>
            <li className="doc"><a href="https://www.cancer.org/cancer/types/breast-cancer/screening-tests-and-early-detection/american-cancer-society-recommendations-for-the-early-detection-of-breast-cancer.html" className="doc certificate">American Cancer Society Recommendations for the Early Detection of Breast Cancer</a></li>
          </ul>
          <ul>
            <li className="doc"><a href="https://www.uspreventiveservicestaskforce.org/uspstf/recommendation/breast-cancer-screening" className="doc certificate">USPSTF Final Recommendation Statement - Breast Cancer: Screening</a> (2024)</li>
          </ul>
        </div>
      </div>
      {
        references.map((ref,idx) => {
          const {
            name='',
            details=[],
            documents=[]
          } = ref;
          return (
            <div key={idx}>
              <h3>{name}</h3>
              {
                details.map((det,detIdx) => <p key={detIdx}>{det}</p>)
              }
              <div className='document-list'>
                <h4>Documents</h4>

                <ul>
                  {
                    documents.map((doc,idx) => {
                      return (
                        <li className='doc' key={idx}>
                          <a href={doc.link} className="doc certificate">{doc.title}</a>
                        </li>
                      )
                    })
                  }
                </ul>
              </div>
            </div>
          )
        })
      }
    </article>
  )
}

export default References;