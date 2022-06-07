# Kubeflow Volumes Web Application

This web application allows user to review and delete persistent volumes that they do not need anymore

## Requirements

- Requires [kustomize](https://kustomize.io)

## Implementation Details & Parameters

This component has been operated by `kustomize` hub extension. 

Downloads tarball with base kustomize script and unpacks into the `./kustomize` directory

In the Kubeflow, there is a hard dependency on cert manager with `v1alpha2` API (currently outdated). kustomize manifest with and remove hard-dependency on the cert-manager.

```text
./
├── overrides
│   └── default
│       └── kustomization.yaml        # Remove hard dependency on cert-manager
├── kustomization.yaml                # Kustomize deployment manfiet
├── pre-deploy                        # Pre deployment hook
└── pre-undeploy -> pre-deploy        # Before deployment hook
```
 
The following component level parameters has been defined `hub-component.yaml`:

| Name      | Description | Default Value
| --------- | ---------   | ---------
| `component.kfserving.namespace` | Target Kubernetes namespace for this component | `kubeflow`
| `component.kfserving.version`   | Version (branch) of Tensorboard app to be used | `v1.5.0`
| `component.kfservingtarball.tarball`   | URL to the tarball distribution with kustomize scripts | [tarball](https://codeload.github.com/kubeflow/manifests/tar.gz/v1.5.0) | 
| `component.kfserving.kustomize.subpath`   | Path inside tarball for kustomize scripts | [apps/kfserving/upstream](https://github.com/kubeflow/manifests/tree/v1.5.0/apps/kfserving/upstream) | 
