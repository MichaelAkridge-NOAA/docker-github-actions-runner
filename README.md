# docker-github-actions-runner
Containerized GitHub Actions self-hosted runner via docker
```
docker pull michaelakridge326/github-actions-sh-runner
```
# Usage
## Create & Update a docker-compose.yml
```
# docker-compose.yml
services:
  github-runner:
    image: michaelakridge326/github-actions-sh-runner
    container_name: my-github-runner
    environment:
      - GH_RUNNER_URL=https://github.com/your_repo_here
      - GH_RUNNER_TOKEN=your_gh_runner_token_here
      - GH_RUNNER_NAME=my-docker-gh-runner-name
    volumes:
      - runner_work:/actions-runner/_work
volumes:
  runner_work:
```
## Run
```
docker-compose up -d
```

----------
#### Disclaimer
This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project content is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.

##### License
See the [LICENSE.md](./LICENSE.md) for details
