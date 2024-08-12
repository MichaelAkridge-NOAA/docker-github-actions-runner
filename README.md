# Docker GitHub Actions Self-Hosted Runner (ephemeral)
Containerized GitHub Actions self-hosted runner via Docker. Ideal for:
- Customization / Control / Flexibility
- Performance / Support for Long-Running Jobs
- Security and more.

<img src="https://github.com/MichaelAkridge-NOAA/docker-github-actions-runner/raw/main/docs/images/00.png" />

# Features:
- pulls latest offical github runner via github api(https://api.github.com/repos/actions/runner/releases/latest)
- removes runner from repo after container stops. recreates on when retarted
- ability to scale up multiple runners
- runs in “ephemeral” mode which creates (and destroys) short-lived compute environment per job on demand

## Read more about Github self-hosted runners
- https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners

# Setup
## Step 0 | Setup Credentials 
### 0a Create a personal access token (https://github.com/settings/tokens)
- go to your Github Profile : Settings / Developer Settings / Personal Access Token
- Generate new token (with at least access permission scope for repo operations) 

### OR 0b Add a new self-hosted runner 
<img src="https://github.com/MichaelAkridge-NOAA/docker-github-actions-runner/raw/main/docs/images/01.png" align="right"  />

- go to your Github repo> Settings > Actions > Runners > Click "New self-hosted runner"
- look under the "Configure" section, and make a note of your github runner token

## Step 1 | Pull Docker Image
- Docker Hub Link: https://hub.docker.com/r/michaelakridge326/github-actions-sh-runner

```
docker pull michaelakridge326/github-actions-sh-runner
```
## Step 2 | Setup using Docker Compose
- Create & Update a docker-compose.yml file with your URL, Token, and a Name for the runner
```
# docker-compose.yml
services:
  github-runner:
    image: michaelakridge326/github-actions-sh-runner:v1.0.0
    container_name: my-github-runner
    environment:
      - GH_REPO_URL=https://github.com/your_name/your_repo_here 
      - GH_RUNNER_NAME=my-docker-gh-runner-name-02
    secrets:
      - gh_pat
    volumes:
      - runner_work:/actions-runner/_work
    restart: unless-stopped
    networks:
      - runner-network
volumes:
  runner_work:
secrets:
  gh_pat:
    file: ./secrets/gh_pat.txt
networks:
  runner-network:
    driver: bridge
```
#### Step 2 | Continued - Run Docker Compose File
```
docker-compose up -d
```
## OR Step 2a | Run using the Docker Run CMD
```
docker run -d \
  --name my-github-runner \
  -e GH_REPO_URL=https://github.com/your_repo_here \
  -e GH_PAT=insert_your_github_pat_here \
  -e GH_RUNNER_NAME=my-docker-gh-runner-name \
  -v runner_work:/actions-runner/_work \
  michaelakridge326/github-actions-sh-runner
```
# Spawn Multiple runners 
### Setup docker-compose like so
```
# docker-compose.yml
version: '3.8'
services:
  github-runner:
    image: michaelakridge326/github-actions-sh-runner:v1.0.0
    environment:
      - GH_REPO_URL=https://github.com/your_name/your_repo_here 
      - GH_RUNNER_NAME=my-docker-gh-runner-name-02
    secrets:
      - gh_pat
    volumes:
      - runner_work:/actions-runner/_work
    restart: unless-stopped
    networks:
      - runner-network
volumes:
  runner_work:
secrets:
  gh_pat:
    file: ./secrets/gh_pat.txt
networks:
  runner-network:
    driver: bridge
```
### Then run (replace 4 with the number of runners you wish to start up)
```
docker-compose up --scale github-runner=4 -d
```
# How to Use your New Self-hosted Runner with Github Workflows
## Update the YAML in your github workflow file for each job like so:
```
runs-on: self-hosted
```
## View your Github Runners
- Go back to your repo > Settings > Actions > Runners  to see your self hosted Runner

<img src="https://github.com/MichaelAkridge-NOAA/docker-github-actions-runner/raw/main/docs/images/03.png"/>

----------
#### Disclaimer
This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project content is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.

##### License
See the [LICENSE.md](./LICENSE.md) for details
