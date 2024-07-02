# Dockerfile
FROM ubuntu:20.04
# Set environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    libicu66 \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Create a folder for the runner
RUN mkdir /actions-runner
WORKDIR /actions-runner

# Download and extract the GitHub Actions runner
RUN curl -o actions-runner-linux-x64-2.317.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz \
    && tar xzf ./actions-runner-linux-x64-2.317.0.tar.gz \
    && rm actions-runner-linux-x64-2.317.0.tar.gz

# Copy entrypoint script
COPY entrypoint.sh /actions-runner/entrypoint.sh

# Create a non-root user
RUN useradd -m runner \
    && mkdir -p /actions-runner/_work \
    && chown -R runner:runner /actions-runner \
    && chmod -R 755 /actions-runner \
    && chmod +x /actions-runner/entrypoint.sh

# Switch to the non-root user
USER runner
ENTRYPOINT ["/actions-runner/entrypoint.sh"]