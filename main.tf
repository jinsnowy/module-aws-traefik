provider "kubernetes" {
  host                   = var.kubernetes_cluster_endpoint
  cluster_ca_certificate = base64decode(var.kubernetes_cluster_cert_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.kubernetes_cluster_name]
  }
}

provider "helm" {
}

provider "aws" {
  region = var.aws_region
}

resource "helm_release" "traefik-ingress" {
  name       = "ms-traefik-ingress"
  chart      = "traefik"
  repository = "https://helm.traefik.io/traefik"
  values = [<<EOF
  service:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: nlb
      externalTrafficPolicy: Local
  EOF
  ]
}
