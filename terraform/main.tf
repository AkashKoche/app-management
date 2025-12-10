resource "google_container_cluster" "app_cluster" {
  name                     = "app-management-gke-cluster"
  location                 = var.gcp_region
  initial_node_count       = 1
  remove_default_node_pool = true
  network                  = "default"
  node_config {
    machine_type = "w2-medium"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name = "primary-node-pool"
  location = var.gcp_region
  cluster = google_container_cluster.app_cluster.name
  node_count = 2

  node_config {
    machine_type = "e2-medium"
  }
}

resource "google_sql_database_instance" "db_instance" {
  database_version = "POSTGRES_14"
  name             = "app-management-db"
  region           = var.gcp_region
  settings {
    tier = "db-f1-micro"
  }
}

data "google_client_config" "correct" {}

resource "kubernetes_secret" "mongo_credentials" {
  metadata {
    name = "mongo-secret"
    namespace = "default"
  }
  data = {
    "MONGO_URI" = "mongodb+srv://admin:securepassword@${google_sql_database_instance.db_instance.connection_name}/AppDB"
  }
}
