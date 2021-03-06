#!/bin/sh -e

if test -z "$COMPONENT_NAME" -o -z "$DOMAIN_NAME" -o -z "$NAMESPACE"; then
  echo "COMPONENT_NAME, DOMAIN_NAME, NAMESPACE must be set"
  exit 1
fi

helm3=helm
if which helm3 >/dev/null; then helm3=helm3; fi

kubectl="kubectl --context=$DOMAIN_NAME --namespace=$NAMESPACE"
helm="$helm3 --kube-context=$DOMAIN_NAME --namespace=$NAMESPACE"

export kubectl helm

if $helm list --deployed --failed --pending -q | grep -E "^$COMPONENT_NAME\$"; then
  set -x
  $helm uninstall "$COMPONENT_NAME"
  set +x
fi

$kubectl delete --ignore-not-found -f "ingress.yaml"
