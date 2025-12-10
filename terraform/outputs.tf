output "gke_cluster_name" {
  value = google_container_cluster.app_cluster.name
}

output "gke_cluster_location" {
  value = google_container_cluster.app_cluster.location
}
