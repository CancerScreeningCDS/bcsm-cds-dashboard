// Use a custom logger application
const LOGGER_HOST = process.env?.REACT_APP_LOGGER_HOST || "http://localhost"
const LOGGER_PORT = process.env?.REACT_APP_LOGGER_PORT || "4040";
const logger_url = `${LOGGER_HOST}:${LOGGER_PORT}/log`;

export async function logMsg(msg) {
  console.log("Logging at", logger_url);
  try {
    const response = await fetch(logger_url, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      mode:'cors',
      body: JSON.stringify(msg)
    }).then(response => {
              let cachedPostData = response.json();
    });
  } catch (e) {
    console.log("No response from log service")
  }

}
