import axios from 'axios';
import { Auth } from 'aws-amplify';

export const configureAxios = () => {
  // Add a request interceptor
  axios.interceptors.request.use(async function (config) {
    // Add Authorization Bearer token to each axios request
    // config.headers.Authorization = `Bearer ${(await Auth.currentSession()).getIdToken().getJwtToken()}`;
    const headers = {
      'x-api-key': 'K7sFUTlhAd604MwhflI2O1BQq9QV8lFl4AsBMKVS'
    };
    config.headers = headers;
    console.log(config)
    return config;
  }, function (error) {

    return Promise.reject(error);
  });
}