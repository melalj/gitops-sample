#!/bin/zsh

CIRCLE_TOKEN=`cat id_circleci_token` # Add the proper value on /init/id_dockerhub_username
PRIVATE_KEY=`cat id_rsa_circleci` # Generate it into /init/id_rsa_circleci using: ssh-keygen -m PEM -t rsa -C "git@circleci.com" -f ./id_rsa_circleci

GIT_ACCOUNT="melalj"
GIT_REPOS=(
  "myproject-api"
  "myproject-frontend"
)

DOCKERHUB_USERNAME=`cat id_dockerhub_username` # Add the proper value on /init/id_dockerhub_username
DOCKERHUB_PASSWORD=`cat id_dockerhub_password` # Add the proper value on /init/id_dockerhub_username
GITOPS_REPO_OWNER="melalj" # Edit this based on your setup
GITOPS_REPO="gitops-sample" # Edit this based on your setup

ENV_VARS=(
  "DOCKERHUB_USERNAME"
  "DOCKERHUB_PASSWORD"
  "GITOPS_REPO_OWNER"
  "GITOPS_REPO"
)

for GIT_REPO in "${GIT_REPOS[@]}"
do
  echo $GIT_REPO
  for ENV_VAR in "${ENV_VARS[@]}"
  do
    # Add env var
    ENV_VAR_VALUE=${(P)${:-${ENV_VAR}}}
    curl -X POST \
      --header "Content-Type: application/json" \
      -d "{\"name\":\"${ENV_VAR}\", \"value\":\"${ENV_VAR_VALUE}\"}" \
      "https://circleci.com/api/v1.1/project/github/${GIT_ACCOUNT}/${GIT_REPO}/envvar?circle-token=${CIRCLE_TOKEN}"
  done
  echo ""
  echo "Added SSH Key"
  # Add ssh key
  curl -X POST \
    --header "Content-Type: application/json" \
    -d "{\"hostname\":\"github.com\", \"private_key\":\"${PRIVATE_KEY}\"}" \
    -d PRIVATE_KEY \
    "https://circleci.com/api/v1.1/project/github/${GIT_ACCOUNT}/${GIT_REPO}/ssh-key?circle-token=${CIRCLE_TOKEN}"
  sleep 0.3
  echo "-"
done