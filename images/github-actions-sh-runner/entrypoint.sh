#!/bin/bash
# entrypoint.sh

# Check for required environment variables
if [ -z "$GH_REPO_URL" ] || [ -z "$GH_RUNNER_NAME" ]; then
  echo "Missing GH_REPO_URL or GH_RUNNER_NAME environment variables."
  exit 1
fi

if [ -z "$GH_RUNNER_TOKEN" ] && [ -z "$GH_PAT" ]; then
  echo "Missing GH_RUNNER_TOKEN or GH_PAT environment variables."
  exit 1
fi

# Fetch the runner token using the GitHub API if GH_PAT is provided
if [ -n "$GH_PAT" ]; then
  echo "Fetching the runner token for $GH_REPO_URL using GH_PAT..."

  # Extract owner and repo from GH_REPO_URL
  REPO_PATH=$(echo $GH_REPO_URL | sed 's|https://github.com/||')
  OWNER=$(echo $REPO_PATH | cut -d'/' -f1)
  REPO=$(echo $REPO_PATH | cut -d'/' -f2)

  # Fetch the runner token
  RESPONSE=$(curl -sX POST -H "Authorization: Bearer ${GH_PAT}" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token")
  GH_RUNNER_TOKEN=$(echo $RESPONSE | jq -r .token)

  if [ -z "$GH_RUNNER_TOKEN" ] || [ "$GH_RUNNER_TOKEN" == "null" ]; then
    echo "Failed to fetch runner token"
    echo "Response from GitHub API: $RESPONSE"
    exit 1
  fi

  echo "Runner token fetched successfully"
fi

# Configure the runner
./config.sh --url $GH_REPO_URL --token $GH_RUNNER_TOKEN --unattended --replace --name $GH_RUNNER_NAME

# Function to clean up the runner
cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${GH_RUNNER_TOKEN}
}

# Trap SIGTERM and SIGINT to execute cleanup
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

# Run the runner
./run.sh
