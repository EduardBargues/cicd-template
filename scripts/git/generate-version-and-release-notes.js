const child = require("child_process");
const fs = require("fs");
const git = require("./git.js");
const logger = require("./logging.js");
const files = require("./file-tools.js");

const featPreffix = "feat:";
const fixPreffix = "fix:";
const breakPreffix = "break:";
const versionFile = "version.json";
const changelogFile = "CHANGELOG.md";

// ------------------ //
// ----- SCRIPT ----- //
// ------------------ //
logger.logAction("GETTING MERGE COMMIT");
let lastCommit = git.getLastCommit();
logger.logKeyValuePair("commit", lastCommit);

logger.logAction("GETTING CHANGES");
let changes = lastCommit.body
  .split("\n")
  .filter((block) => block.startsWith("* "))
  .map((block) => getChange(block.replace("* ", "")));
if (changes.length === 0) {
  changes.push(getChange(lastCommit.subject));
}
logger.logKeyValuePair("changes", changes);

logger.logAction("GETTING PREVIOUS VERSION");
let versionFileContent = files.getJsonFrom(versionFile);
let previousVersion = getPreviousVersionAsText(versionFileContent);
logger.logKeyValuePair("previous-version", previousVersion);

logger.logAction("GETTING NEW VERSION");
let newVersion = getUpdatedVersion(previousVersion, changes);
logger.logKeyValuePair("new-version", newVersion);

logger.logAction("UPDATING VERSION FILE");
files.saveJsonTo(
  versionFile,
  files.prettifyJsonObject({ version: newVersion })
);

logger.logAction("UPDATING CHANGELOG FILE");
updateChangelogFile(newVersion, changes);

logger.logAction("COMMITTING AND TAGGING");
commitAndTag(newVersion);

// --------------------- //
// ----- FUNCTIONS ----- //
// --------------------- //
function updateChangelogWith(changelog, title, changeContents) {
  if (changeContents.length > 0) {
    changelog += `${title}`;
    changeContents.forEach((content) => {
      changelog += content;
    });
  }
  return changelog;
}
function getUpdatedVersion(version, changes) {
  let versionFileContent = version.split(".");
  let major = parseInt(versionFileContent[0], 10);
  let minor = parseInt(versionFileContent[1], 10);
  let patch = parseInt(versionFileContent[2], 10);
  let secondary = 0;
  if (versionFileContent.length > 3) {
    secondary = parseInt(versionFileContent[3], 10);
  }

  let newMajor = 0;
  let newMinor = 0;
  let newPatch = 0;
  let newSecondary = 0;
  if (changes.some((change) => change.type === "break")) {
    newMajor = major + 1;
    newMinor = 0;
    newPatch = 0;
    newSecondary = 0;
  } else if (changes.some((change) => change.type === "feat")) {
    newMajor = major;
    newMinor = minor + 1;
    newPatch = 0;
    newSecondary = 0;
  } else if (changes.some((change) => change.type === "fix")) {
    newMajor = major;
    newMinor = minor;
    newPatch = patch + 1;
    newSecondary = 0;
  } else {
    newMajor = major;
    newMinor = minor;
    newPatch = patch;
    newSecondary = secondary + 1;
  }

  return `${newMajor}.${newMinor}.${newPatch}.${newSecondary}`;
}
function getChange(line) {
  if (line.startsWith(featPreffix)) {
    return {
      type: featPreffix.replace(":", ""),
      content: line.replace(featPreffix, "").trim(),
    };
  } else if (line.startsWith(fixPreffix)) {
    return {
      type: fixPreffix.replace(":", ""),
      content: line.replace(fixPreffix, "").trim(),
    };
  } else if (line.startsWith(breakPreffix)) {
    return {
      type: breakPreffix.replace(":", ""),
      content: line.replace(breakPreffix, "").trim(),
    };
  } else {
    return {
      type: "none",
      content: line.trim(),
    };
  }
}
function getPreviousVersionAsText(versionFileContent) {
  let previousVersion = "";
  if (versionFileContent.version) {
    previousVersion = versionFileContent.version;
  } else {
    previousVersion = "0.0.0.0";
  }
  return previousVersion;
}
function updateChangelogFile(newVersion, changes) {
  let changelog = `# :confetti_ball: ${newVersion} (${new Date().toISOString()})\n`;
  changelog += "- - -\n";
  changelog = updateChangelogWith(
    changelog,
    "## :boom: BREAKING CHANGES\n",
    changes
      .filter((change) => change.type == "break")
      .map((change) => `* ${change.content}\n`)
  );
  changelog = updateChangelogWith(
    changelog,
    "## :hammer: Features\n",
    changes
      .filter((change) => change.type == "feat")
      .map((change) => `* ${change.content}\n`)
  );
  changelog = updateChangelogWith(
    changelog,
    "## :bug: Fixes\n",
    changes
      .filter((change) => change.type == "fix")
      .map((change) => `* ${change.content}\n`)
  );
  changelog = updateChangelogWith(
    changelog,
    "## :newspaper: Others\n",
    changes
      .filter((change) => change.type == "none")
      .map((change) => `* ${change.content}\n`)
  );
  changelog += "- - -\n";
  changelog += "- - -\n";
  console.log(changelog);
  let previousChangelog = "";
  try {
    previousChangelog = fs.readFileSync(changelogFile, "utf-8");
  } catch (error) {
    previousChangelog = "";
  }
  fs.writeFileSync(changelogFile, `${changelog}${previousChangelog}`);
}
function commitAndTag(newVersionAsText) {
  child.execSync(`git add ${versionFile}`);
  child.execSync(`git add ${changelogFile}`);
  child.execSync(
    `git commit -m "[SKIP CI] Bump to version ${newVersionAsText}"`
  );
  child.execSync(
    `git tag -a -m "Tag for version ${newVersionAsText}" ${newVersionAsText}`
  );
  child.execSync(`git push --follow-tags`);
}
