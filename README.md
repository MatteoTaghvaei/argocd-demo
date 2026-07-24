# gitops-demo

Minimal end-to-end GitOps learning project: GitHub Actions builds and pushes a
Docker image, updates the Kustomize overlay for the target environment, and
ArgoCD syncs the change into the cluster. One repo, one cluster, two
namespaces (`dev`, `prod`) simulating two environments.

## Flow

```
feature/* branch  --PR-->  feature branch  --push-->  GitHub Actions
                                                         |
                                                         v
                                          docker build & push  xxxxxx/argocd:dev-<sha>
                                                         |
                                                         v
                                   sed-update manifests/overlays/dev (image tag + VERSION)
                                                         |
                                                         v
                                              git commit + push to `feature`
                                                         |
                                                         v
                                    ArgoCD Application `demo-argocd-dev` (watches `feature` branch)
                                                         |
                                                         v
                                         syncs manifests/overlays/dev -> namespace `dev`

feature branch --PR-->  master branch  --push-->  same pipeline, but:
                                                  image tag: prod-<sha>
                                                  overlay:   manifests/overlays/prod
                                                  ArgoCD app: hello-argocd-prod (watches `master`)
                                                  namespace: prod
```

Only pushes that touch `app/**`, `Dockerfile`, or the workflow itself trigger
a build. The bot's own commits only touch `manifests/overlays/**`, so they
don't re-trigger the workflow.

## Repo layout

```
app/                          nginx html template + envsubst entrypoint script
Dockerfile
manifests/
  base/                       Deployment + Service + base kustomization
  overlays/dev/                namespace: dev, blue banner
  overlays/prod/               namespace: prod, green banner, 2 replicas
argocd/
  app-dev.yaml                 ArgoCD Application watching `feature` branch
  app-prod.yaml                ArgoCD Application watching `master` branch
.github/workflows/ci-cd.yaml
```
