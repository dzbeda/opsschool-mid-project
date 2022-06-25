resource "null_resource" "uninstall_helm" {
  depends_on = [null_resource.update_kubectl_configuration]
  provisioner "local-exec" {
    command = "helm uninstall prometheus --namespace monitoring"
    on_failure = continue
  }
  provisioner "local-exec" {
    command = "kubectl delete ns monitoring"
    on_failure = continue
  }
  provisioner "local-exec" {
    command = "helm uninstall grafana --namespace grafana"
    on_failure = continue
  }
  provisioner "local-exec" {
    command = "kubectl delete ns grafana"
    on_failure = continue
  }
}


resource "null_resource" "update_montoring_repo" {
  depends_on = [null_resource.uninstall_helm1]
  provisioner "local-exec" {
    command = "helm repo add prometheus-community https://prometheus-community.github.io/helm-charts"
  }
  provisioner "local-exec" {
    command = "helm repo add grafana https://grafana.github.io/helm-charts"
  }
  provisioner "local-exec" {
    command = "helm repo update"
  }
}

resource "null_resource" "promethues_provisioning" {
  depends_on = [null_resource.update_montoring_repo1]
  provisioner "local-exec" {
    command = "helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace --set alertmanager.persistentVolume.storageClass='gp2' --set server.persistentVolume.storageClass='gp2'"
  }
}
resource "null_resource" "grafana_provisioning" {
  depends_on = [null_resource.promethues_provisioning]
  provisioner "local-exec" {
    command = "helm install grafana grafana/grafana --namespace grafana --set persistence.storageClassName='gp2' --set persistence.enabled=true --set adminPassword='dudu' --values ../kubernetes-files/grafana_values.yaml --create-namespace"
  }
}