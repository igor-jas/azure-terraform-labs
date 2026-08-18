# Kubernetes Monitoring - Lab 10

This lab adds a full monitoring stack (Prometheus and Grafana) to the local Kubernetes cluster from Lab 08, using Helm to install and configure it, and verifies that infrastructure metrics are correctly collected for the deployed Flask application.

## What this lab creates

A dedicated `monitoring` namespace in the cluster, running the `kube-prometheus-stack` Helm chart, which bundles Prometheus, Grafana, Alertmanager, kube-state-metrics, node-exporter, and the Prometheus Operator into a single, coordinated deployment.

## Technologies used

Helm, Prometheus, Grafana, kube-prometheus-stack, Kubernetes.

## Architecture

Helm was used as the package manager for Kubernetes, pulling the `kube-prometheus-stack` chart from the official prometheus-community and grafana chart repositories. This chart installs Prometheus configured to automatically discover and scrape metrics from cluster components (nodes, pods, containers) via node-exporter and cAdvisor, with kube-state-metrics exposing the state of Kubernetes objects like Deployments and Pods. Grafana is installed alongside it with Prometheus pre-configured as the default data source, and comes with a library of pre-built dashboards for Kubernetes compute resources, networking, node metrics, CoreDNS, etcd, and Prometheus itself.

Access to Grafana is done through `kubectl port-forward`, the same approach used in Lab 08 for reaching services inside the cluster from the host machine.

## Setup

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
kubectl --namespace monitoring port-forward svc/prometheus-grafana 3000:80
```

Grafana is then available at `http://localhost:3000`, with credentials retrieved via `kubectl get secret`.

## Verification

All six pods in the monitoring namespace reached a Running state (Prometheus, Grafana, Alertmanager, the operator, kube-state-metrics, and node-exporter). Prometheus was confirmed as the default Grafana data source, and the pre-built "Kubernetes / Compute Resources / Pod" dashboard was checked against the running Flask application pods from Lab 08, confirming that CPU usage data was being collected correctly for each pod individually, not just at the cluster level.

The CPU Throttling panel on this dashboard shows no data, which is expected rather than a fault: throttling metrics only populate when a pod has CPU limits defined and is hitting them, and the Lab 08 deployment doesn't set `resources.limits`.

## Status

This lab covers infrastructure-level monitoring (CPU, memory, pod state) using metrics that are automatically exposed by the cluster and its components. Custom application-level metrics (for example, request counts or response times from the Flask app itself) were intentionally left out of scope here, since they would require instrumenting the application code directly and are a natural extension for a future lab rather than a gap in this one.