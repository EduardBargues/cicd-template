const git = require("./git.js");
const logger = require("./logging.js");
const reverse = (str) => str.split("").reverse().join("");

logger.logAction("ENSURING JIRA TICKETS INTO COMMIT MESSAGES");
const baseBranch = process.argv[2];
logger.logKeyValuePair("base-branch", baseBranch);
const prBranch = process.argv[3];
logger.logKeyValuePair("pr-branch", prBranch);
let ok = git
  .getCommitsInsidePullRequest(baseBranch, `origin/${prBranch}`)
  .every((commit) => {
    logger.logAction("EVALUATING COMMIT");
    let commitMessage = `${commit.subject} ${commit.body}`;
    const reversedTickets = reverse(commitMessage).match(
      /\d+-[A-Z]+(?!-?[a-zA-Z]{1,10})/g
    );
    let commitMessageOk = reversedTickets != null && reversedTickets.length > 0;
    let resultText = commitMessageOk ? "OK" : "WRONG";
    logger.logKeyValuePair("result", resultText);
    logger.logKeyValuePair("commit", commit);
    return commitMessageOk;
  });

if (!ok) {
  process.exit(1);
}
