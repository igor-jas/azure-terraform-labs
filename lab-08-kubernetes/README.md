# Kubernetes Deployment - Lab 08

This lab deploys the containerized Flask application from Lab 05 onto a local
Kubernetes cluster, demonstrating the fundamentals of container orchestration:
Deployments, Services, replica management, and self-healing.

## What this lab creates

- A local, single-node Kubernetes cluster (via `kind`)
- A Deployment running two replicas of the Flask app from Lab 05
- A NodePort Service exposing the application

## Technologies used

- Kubernetes
- `kind` (Kubernetes in Docker)
- `kubectl`
- Docker (image built and loaded from Lab 05)

## Architecture

Unlike Lab 05, where a single container was run manually with `docker run`,
this lab uses Kubernetes to manage multiple replicas declaratively:

- The Docker image (`igor-flask-app`, built in Lab 05) is loaded directly into
  the `kind` cluster's internal registry, since it's not published anywhere
  public
- The Deployment (`deployment.yaml`) declares the desired state: 2 running
  replicas of the app
- The Service provides a stable network endpoint, routing traffic to
  whichever pods are currently healthy, regardless of their individual names
  or IPs

See `deployment.yaml` for the full manifest.

## Setup and deployment

```bash
kind create cluster --name igor-flask-cluster
docker build -t igor-flask-app .
kind load docker-image igor-flask-app --name igor-flask-cluster
kubectl apply -f deployment.yaml
```

## Accessing the application

On macOS, Docker Desktop runs containers inside a lightweight Linux VM, so the
`kind` node's internal IP address isn't directly reachable from the host
browser — connecting to it via NodePort resulted in a stalled connection.
`kubectl port-forward` was used instead, tunneling directly from the host to
the Service:

```bash
kubectl port-forward service/igor-flask-service 5000:5000
```

The app is then available at `http://localhost:5000`.

## Verification

- `kubectl get pods` — 2/2 pods `Running`
- `kubectl get deployments` — 2/2 ready, up-to-date, available
- `kubectl get services` — Service correctly mapping port 5000 to NodePort 30080
- Application verified in browser via port-forward tunnel

**Self-healing test:** one pod was manually deleted with `kubectl delete pod
<name>`. Kubernetes automatically created a replacement pod within seconds to
maintain the desired replica count of 2, while the untouched pod continued
running without interruption — confirming the Deployment's reconciliation
loop is functioning as expected.

## Notes

This is a local, single-node cluster intended for learning container
orchestration concepts without cloud costs. No Ingress or LoadBalancer is
configured — NodePort/port-forward is sufficient for local verification.