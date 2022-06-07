# Kubeflow Tensorboard app

This web application provides Web UI to manage Tensorboard instances in the user's profile

## Requirements

- Requires [kustomize](https://kustomize.io)

## Implementation Details & Parameters

This component will deploy two services of the Jupyter notebbok

* [tensorboards-web-app](tensorboards-web-app) - web application
* [tensorboard-controller](notebook-controller) - a BFF (backend-for-frontend) of the web application


```text
./
├── tensorboards-web-app                 # Contains kustomize scr
│   └── kustomization.yaml               # Kustomize deployment manifest
├── tensorboard-controller               # Backend for UI and operator for tensorboards
│   └── kustomization.yaml               # Kustomize deployment manifest
├── deploy                               # Deploys both applicaitons
└── undeploy                             # Symlink to deploy script (reversive script to deploy)
```
 

The following component level parameters has been defined `hub-component.yaml`:

| Name      | Description | Default Value
| --------- | ---------   | ---------
| `component.kubeflow.namespace` | Target Kubernetes namespace for this component | `kubeflow`
| `component.kubeflow.version`   | Version (branch) of Tensorboard app to be used | `v1.5.0`
| `component.kubeflow.tarball`   | URL to the tarball distribution with kustomize scripts | [tarball](https://codeload.github.com/kubeflow/manifests/tar.gz/v1.5.0) | 

## See Also

* Central Dashboard on Kubeflow [website](https://www.kubeflow.org/docs/components/central-dash/overview/)
