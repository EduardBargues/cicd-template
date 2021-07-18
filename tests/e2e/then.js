const HTTP_STATUS_CODE_OK = 200;

const responseIsOk = (response) => {
  expect(response.status).toBe(HTTP_STATUS_CODE_OK);
};

module.exports = {
  responseIsOk,
};
