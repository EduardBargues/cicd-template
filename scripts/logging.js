const logAction = (action) => {
  console.log(``);
  console.log(`${action} ...`);
};
const logKeyValuePair = (key, value) => {
  console.log(`    ${key}: ${JSON.stringify(value, null, 4)}`);
};

module.exports = {
  logAction,
  logKeyValuePair,
};
