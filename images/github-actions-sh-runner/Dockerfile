FROM ubuntu:20.04

# Set environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    jq \
    git \
    libicu66 \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Create a folder for the runner
RUN mkdir /actions-runner
WORKDIR /actions-runner

# Get the latest GitHub runner version and verify it
RUN LATEST_RUNNER_VERSION=$(curl --silent "https://api.github.com/repos/actions/runner/releases/latest" | jq -r .tag_name | sed 's/^v//') \
    && echo "Downloading GitHub Runner version $LATEST_RUNNER_VERSION" \
    && curl -o actions-runner-linux-x64-${LATEST_RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${LATEST_RUNNER_VERSION}/actions-runner-linux-x64-${LATEST_RUNNER_VERSION}.tar.gz \
    && echo "Verifying the checksum" \
    && CHECKSUM=$(curl -sL https://github.com/actions/runner/releases/download/v${LATEST_RUNNER_VERSION}/SHA256SUMS | grep "actions-runner-linux-x64-${LATEST_RUNNER_VERSION}.tar.gz") \
    && echo "$CHECKSUM" > checksum.txt \
    && sha256sum -c checksum.txt \
    && rm checksum.txt \
    && echo "Extracting the archive" \
    && tar xzf ./actions-runner-linux-x64-${LATEST_RUNNER_VERSION}.tar.gz \
    && echo "Cleanup" \
    && rm actions-runner-linux-x64-${LATEST_RUNNER_VERSION}.tar.gz

# Copy entrypoint script
COPY entrypoint.sh /actions-runner/entrypoint.sh

# Create a non-root user
RUN useradd -m runner \
    && mkdir -p /actions-runner/_work \
    && chown -R runner:runner /actions-runner \
    && chmod -R 750 /actions-runner \
    && chmod +x /actions-runner/entrypoint.sh

# Switch to the non-root user
USER runner

# Set a more restrictive ENTRYPOINT
ENTRYPOINT ["/actions-runner/entrypoint.sh"]
