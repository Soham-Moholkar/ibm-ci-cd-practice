# CI/CD Tools and Practices Final Project Template

## Project name: ci-cd-final-project

Python counter REST API with GitHub Actions continuous integration and an OpenShift Tekton delivery pipeline. The GitHub repository is named `ibm-ci-cd-practice` as requested.

The sample application comes from [IBM Skills Network's official template](https://github.com/ibm-developer-skills-network/vselh-ci-cd-final-project-template), under the Apache 2.0 license.

## CI workflow

[`.github/workflows/workflow.yml`](.github/workflows/workflow.yml) runs on pushes and pull requests to `main`, and supports manual execution. It checks out the code, installs dependencies in `python:3.9-slim`, runs both required flake8 checks, and executes Nose tests with coverage. A dependent job builds and tags the container with the commit SHA. CI validates the image; the OpenShift buildah task publishes the deployment image.

The coverage package is `service`, matching the supplied application. The course's `--cover-package=app` example refers to a package that does not exist in this template.

## OpenShift delivery

The pipeline in [`.tekton/pipeline.yml`](.tekton/pipeline.yml) has six sequential stages:

`cleanup -> git-clone -> flake8 -> nose -> buildah -> deploy`

[`.tekton/tasks.yml`](.tekton/tasks.yml) defines cleanup, nose, and flake8. The pipeline uses the lab's installed `git-clone`, `buildah`, and `openshift-client` ClusterTasks. These manifests target the course's OpenShift environment and its `tekton.dev/v1beta1` API.

The shared `output` workspace binds to `oc-lab-pvc`, requesting `1Gi` on the `skills-network-learner` storage class. Buildah publishes a uniquely tagged image to the internal registry. The deploy task applies the Deployment and waits for its rollout to complete.

In an authenticated course lab terminal with `oc` and `tkn` installed:

```bash
git clone https://github.com/Soham-Moholkar/ibm-ci-cd-practice.git
cd ibm-ci-cd-practice
bash bin/deploy.sh
oc logs deployment/ci-cd-final-project
```

The service binds to port `8000` and writes `SERVICERUNNING on port 8000` in its startup banner. Its `/health` endpoint returns `{"status":"OK"}`. Counters are stored in memory, so this course sample uses a single process and loses counters on restart.

## Local validation

Use Python 3.9 for the course's pinned legacy Nose dependencies:

```bash
python3.9 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip wheel
pip install -r requirements.txt
flake8 service --count --select=E9,F63,F7,F82 --show-source --statistics
flake8 service --count --max-complexity=10 --max-line-length=127 --statistics
nosetests -v --with-spec --spec-color --with-coverage --cover-package=service
```

## Submission links

- [README.md](https://github.com/Soham-Moholkar/ibm-ci-cd-practice/blob/main/README.md)
- [GitHub Actions workflow](https://github.com/Soham-Moholkar/ibm-ci-cd-practice/blob/main/.github/workflows/workflow.yml)
- [Tekton tasks](https://github.com/Soham-Moholkar/ibm-ci-cd-practice/blob/main/.tekton/tasks.yml)
- [GitHub Actions runs](https://github.com/Soham-Moholkar/ibm-ci-cd-practice/actions)

Capture evidence from actual executions: `cicd-github-validate.txt`, `oc-pipelines-console-pvc-details.png`, `oc-pipelines-oc-final.png`, `oc-pipelines-oc-green.png`, and `oc-pipelines-app-logs.txt`. The application log can also be submitted as `oc-pipeline-application-logs.txt` to match the final question wording.

## Original template usage

This repository is to be used as a template to create your own repository in your own GitHub account. No need to Fork it as it has been set up as a Template. This will avoid confusion when making Pull Requests in the future.

From the GitHub **Code** page, press the green **Use this template** button to create your own repository from this template.

Name your repo: `ci-cd-final-project`.

## Setup

After entering the lab environment you will need to run the `setup.sh` script in the `./bin` folder to install the prerequisite software.

```bash
bash bin/setup.sh
```

Then you must exit the shell and start a new one for the Python virtual environment to be activated.

```bash
exit
```

## Tasks


## License

Licensed under the Apache License. See [LICENSE](/LICENSE)

## Author

Skills Network

## <h3 align="center"> © IBM Corporation 2023. All rights reserved. <h3/>
