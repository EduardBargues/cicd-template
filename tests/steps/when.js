const axios = require("axios");

const weInvokeEndpoint = async (url) => {
  try {
    return await axios.get(url);
  } catch (err) {
    return err.response;
  }
};

module.exports = {
  weInvokeEndpoint,
};
