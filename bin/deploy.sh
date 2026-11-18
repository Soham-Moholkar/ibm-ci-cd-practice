#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
namespace=$(oc project -q)
image="image-registry.openshift-image-registry.svc:5000/${namespace}/ci-cd-final-project:$(git rev-parse --short HEAD)-$(date +%s)"
oc apply -f .tekton/tasks.yml
oc apply -f .tekton/pvc.yml
oc apply -f .tekton/pipeline.yml
tkn pipeline start ci-cd-final-project \
  --param repo-url=https://github.com/Soham-Moholkar/ibm-ci-cd-practice.git \
  --param branch=main \
  --param app-name=ci-cd-final-project \
  --param build-image="${image}" \
  --workspace name=output,claimName=oc-lab-pvc \
  --serviceaccount pipeline \
  --showlog
