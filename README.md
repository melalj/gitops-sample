# GitOps boilerplate

[Full tutorial is available here.](https://www.tonoid.com/blog/gitops-ci-cd-circleci-argocd-kubernetes)

## Ingredients

- Docker
- Helm
- ArgoCD

## Architecture

### Apps

- myproject-frontend: Sample frontend using NuxtJs
- myproject-api: Sample backend using express (and [@tonoid/helpers](https://github.com/melalj/tonoid-helpers))
- gsheet-api: Using a published image from Docker hub.

### Dependencies

- Redis

### Tasks

- Background tasks (cronJobs, jobs).
