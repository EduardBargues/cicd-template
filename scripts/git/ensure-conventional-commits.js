const git = require("./git.js");
const logger = require("./logging.js");
const acceptablePrefixes = [
  "break:",
  "fix:",
  "feat:",
  "build:",
  "chore:",
  "ci:",
  "docs:",
  "style:",
  "refactor:",
  "perf:",
  "test:",
];

logger.logAction("ENSURING CONVENTIONAL COMMITS");
const baseBranch = process.argv[2];
logger.logKeyValuePair("base-branch", baseBranch);
const prBranch = process.argv[3];
logger.logKeyValuePair("pr-branch", prBranch);
let ok = git
  .getCommitsInsidePullRequest(baseBranch, `origin/${prBranch}`)
  .every((commit) => {
    logger.logAction("EVALUATING COMMIT");
    let commitMessageOk = acceptablePrefixes.some((prefix) =>
      commit.subject.startsWith(prefix)
    );
    let resultText = commitMessageOk ? "OK" : "WRONG";
    logger.logKeyValuePair("result", resultText);
    logger.logKeyValuePair("commit", commit);

    return commitMessageOk;
  });

if (!ok) {
  process.exit(1);
}
