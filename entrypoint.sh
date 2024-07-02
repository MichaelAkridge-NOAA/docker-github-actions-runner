#!/bin/bash
# entrypoint.sh

# Check for required environment variables
if [ -z "$GH_RUNNER_URL" ] || [ -z "$GH_RUNNER_TOKEN" ]; then
  echo "Missing GH_RUNNER_URL or GH_RUNNER_TOKEN environment variables."
  exit 1
fi

# Configure the runner
./config.sh --url $GH_RUNNER_URL --token $GH_RUNNER_TOKEN --unattended --replace

# Run the runner
./run.sh