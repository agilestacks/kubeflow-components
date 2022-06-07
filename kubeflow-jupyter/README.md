# Kubeflow Jupyter Notebook

A web application to allow user to create, update and delete Jupyter Notebooks inside their profile. This application can work as a standalone application, however by default it wll be opened from Kubeflow Central dashboard via iframe.

## Requirements

- Requires [kustomize](https://kustomize.io) CLI. Doesn't work with `kubectl -k ...`

## Implementation Details & Parameters

This component will deploy two services of the Jupyter notebbok

* [jupyter-web-app](jupyter-web-app) - a web application
* [notebook-controller](notebook-controller) - a BFF (backend-for-frontend) of this applicaiton.

Notebook creation form can be customized in [jupyter-web-app/spawner_ui_config.yaml](components/kubeflow-jupyter/jupyter-web-app/spawner_ui_config.yaml.template) file.

> There was a special update to the notebook to allow user select GPUs from a dropdown.

Once a notebook has been created. In the Kubernetes it has been represented as a Custom Resource (Notebook), so notebook controller also acts as an operator for this custom resource.

The component has the following directory structure:

```text
./
├── crds
│   └── notebook.yaml                    # CRD, contains previous verions, for smooth in-place upgrade
├── jupyter-web-app                      # Jupyter Web application (UI)
│   ├── kustomization.yaml.template      # Kustomize script for Jupyter web application
│   ├── params.yaml                      # Application environment variables
│   └── spawner_ui_config.yaml.template  # Extracted notebook creation form config for easier customization
├── notebook-controller                  # Backend for UI and operator for Notebooks
│   ├── kustomization.yaml.template      # Kustomize script for Notebook
│   └── params.env.template              # Environment variables for backend
├── README.md
├── backup                               # Script for backups
├── deploy.sh                            # Customized deployment script to hook both kustomize files
├── hub-component.yaml                   # Hub manifest
├── post-deploy                          # Special addon to hook a optional restore from backup script
└── undeploy.sh                          # Undeployment script for both kustomze applicaitons
```
 
The component uses an offical Kubeflow distribution Kustomize [scripts]("https://github.com/kubeflow/manifests/") as a and applies patches and additiona resources described in [kustomize.yaml](kustomize.yaml.template) file.

Where [pre-deploy](pre-deploy) script has been responsible for download tarball from Kubeflow official distribution website.

The following component level parameters has been defined `hub-component.yaml`:

| Name      | Description | Default Value
| --------- | ---------   | ---------
| `component.kubeflow.namespace` | Target Kubernetes namespace for this component | `kubeflow`
| `component.kubeflow.dashboard.image` | Central dashboard docker image configuration | `gcr.io/kubeflow-images-public/centraldashboard`
| `component.kubeflow.dashboard.imageTag` | Central dashboard docker image configuration | `vmaster-g8097cfeb`
| `component.kubeflow.dashboard.contributorFormat` | REGEX to configure validation for profiles congtributor | `^.+$`
| `component.kubeflow.dashboard.contributorValidationMessage` | Custom error message for contributor validation | `^.+$`

## See Also

* Central Dashboard on Kubeflow [website](https://www.kubeflow.org/docs/components/central-dash/overview/)
