# Kubeflow Volumes Web Application

This web application allows user to review and delete persistent volumes that they do not need anymore

## Requirements

- Requires [kustomize](https://kustomize.io)

## Implementation Details & Parameters

This component has been operated by `kustomize` hub extension. 

Downloads tarball with base kustomize script and unpacks into the `./kustomize` directory

Fixing missing in manifests kustomize variable (namespace)

```text
./
└── kustomization.yaml                   # Kustomize deployment manifest
```
 
The following component level parameters has been defined `hub-component.yaml`:

| Name      | Description | Default Value
| --------- | ---------   | ---------
| `component.kubebench.namespace` | Target Kubernetes namespace for this component | `kubeflow`
| `component.kubebench.version`   | Version (branch) of Tensorboard app to be used | `v1.5.0`
| `component.kubebench.kustomize.tarball.tarball`   | URL to the tarball distribution with kustomize scripts | [tarball](https://codeload.github.com/kubeflow/manifests/tar.gz/v1.5.0) | 
| `component.kubebench.kustomize.subpath`   | Path inside tarball for kustomize scripts | [apps/kubebench/upstream](https://github.com/kubeflow/manifests/tree/v1.5.0/apps/kubebench/upstream) | 
