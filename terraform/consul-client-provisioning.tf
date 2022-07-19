resource "null_resource" "uninstall_consul_helm" {
  depends_on = [null_resource.update_kubectl_configuration]
  provisioner "local-exec" {
    command = "helm uninstall consul --namespace consul"
    on_failure = continue
  }
  provisioner "local-exec" {
    command = "kubectl delete ns consul"
    on_failure = continue
  }
}

resource "null_resource" "update_consul_repo" {
  depends_on = [null_resource.uninstall_consul_helm]
  provisioner "local-exec" {
    command = "helm repo add hashicorp https://helm.releases.hashicorp.com"
  }
  provisioner "local-exec" {
    command = "helm repo update"
  }
}

resource "null_resource" "consu_client" {
  depends_on = [null_resource.update_consul_repo]
  provisioner "local-exec" {
    command = "kubectl create namespace consul"
  }
  provisioner "local-exec" {
    command = "kubectl create secret -n consul generic consul-gossip-key --from-literal=key=uDBV4e+LbFW3019YKPxIrg=="
  }
  provisioner "local-exec" {
    command = " helm install consul hashicorp/consul --namespace consul --create-namespace --values ../kubernetes-files/consul-client/consul-values.yaml"
  }
}

resource "null_resource" "apply_core_dns_config" {
  depends_on = [null_resource.consu_client]
  provisioner "local-exec" {
    command = "cp ../kubernetes-files/consul-client/coredns-cm.yaml ../kubernetes-files/consul-client/apply-coredns-cm.yaml"
  }
  provisioner "local-exec" {
    command = "sed -i -r \"s/consul-service-ip/$(kubectl get svc -n consul | grep consul-consul | awk '{print $3}')/\" ../kubernetes-files/consul-client/apply-coredns-cm.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f ../kubernetes-files/consul-client/apply-coredns-cm.yaml"
  }
}



