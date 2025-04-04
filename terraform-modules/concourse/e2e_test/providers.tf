terraform {
  required_providers {
    concourse = {
      source = "terraform-provider-concourse/concourse"
    }
  }
}

provider "concourse" {
  target = var.fly_target
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

data "google_client_config" "provider" {}

data "google_container_cluster" "wg_ci_test" {
  project  = var.project
  name     = var.gke_name
  location = var.zone
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.wg_ci_test.endpoint}"
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.wg_ci_test.master_auth[0].cluster_ca_certificate)
}
