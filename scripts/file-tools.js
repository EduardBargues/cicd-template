const fs = require("fs");

function getJsonFrom(file) {
  let jsonObject = {};
  if (fs.existsSync(file)) {
    jsonObject = JSON.parse(fs.readFileSync(file));
  }
  return jsonObject;
}
function saveJsonTo(file, jsonObject) {
  fs.writeFileSync(file, jsonObject);
}
function prettifyJsonObject(obj) {
  return JSON.stringify(obj, null, 4);
}

module.exports = {
  getJsonFrom,
  saveJsonTo,
  prettifyJsonObject,
};
