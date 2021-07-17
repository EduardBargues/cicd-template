git config --global user.email "${AUTOMATION_EMAIL}"
git config --global user.name "${AUTOMATION_USER}"
export ACCESS_TOKEN=$(curl -s -X POST -u "${AUTOMATION_CLIENT_ID}:${AUTOMATION_CLIENT_SECRET}" https://bitbucket.org/site/oauth2/access_token -d grant_type=client_credentials -d scopes="repository"| jq --raw-output '.access_token')
git remote set-url origin "https://x-token-auth:${ACCESS_TOKEN}@bitbucket.org/${BITBUCKET_REPO_OWNER}/${BITBUCKET_REPO_SLUG}"
node ./scripts/generate-version-and-release-notes.js