# devops-way
App
  502  curl http://localhost:8001/s3-buckets
  503  curl http://localhost:8001/parameters
  505  curl http://localhost:8001/s3-bucketsalhost:8001/s3-buckets



Minikube
  581  minikube version
  582  kubectl version --client
  583  helm version
  584  docker info
  585  minikube start --driver=docker
kubectl get nodes
  587  kubectl cluster-info



ArgoCD
 kubectl create namespace argocd
  589  helm repo add argo https://argoproj.github.io/argo-helm
  590  helm repo update
  591  helm install argocd argo/argo-cd --namespace argocd
  592  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
  593  kubectl get pods -n argocd
  594  kubectl create namespace devops-app


Prometheus
  583  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  584  helm repo update
  585  helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace
  586  kubectl get pods -n monitoring

kubectl --namespace monitoring port-forward $POD_NAME 9090
http://localhost:9090/


Grafana 
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana --namespace monitoring
kubectl get pods -n monitoring

Password 
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
kubectl port-forward svc/grafana -n monitoring 3000:80
http://localhost:3000/
admin and Password
