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
  response=$(curl -sX POST -H "Authorization: token ${GH_PAT}" ${GH_REPO_URL}/actions/runners/registration-token)
  GH_RUNNER_TOKEN=$(echo $response | jq -r .token)

  if [ -z "$GH_RUNNER_TOKEN" ]; then
    echo "Failed to fetch runner token"
    echo "Response from GitHub API: $response"
    exit 1
  fi

  echo "Runner token fetched successfully"
fi

# Configure the runner
./config.sh --url $GH_REPO_URL --token $GH_RUNNER_TOKEN --unattended --replace --name $GH_RUNNER_NAME

# Run the runner
./run.sh