# ── Compute: gmov6ip0c (test) ─────────────────────────────────
variable "gmov6ip0c_machine_type" {
  description = "GCP machine type"
  type        = string
  default     = "n2-highmem-8"
}
variable "gmov6ip0c_count" {
  description = "Number of instances"
  type        = number
  default     = 1
}
variable "gmov6ip0c_disk_size" {
  description = "Boot disk size GB"
  type        = number
  default     = 120
}

resource "google_compute_instance" "gmov6ip0c" {
  count        = var.gmov6ip0c_count
  name         = "GCPAPPTST03-${count.index}"
  machine_type = var.gmov6ip0c_machine_type
  zone         = "${var.gcp_region}-a"

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2022"
      size  = var.gmov6ip0c_disk_size
      type  = "pd-ssd"
    }
  }
  network_interface {
    network    = "var.vpc_network"
    subnetwork = "var.subnet_name"
    access_config {}
  }
  metadata = {
    enable-oslogin = "TRUE"
  }
  attached_disk {
    source      = google_compute_disk.gmov6ip0c_disk_d.self_link
    device_name = "disk-d"
    mode        = "READ_WRITE"
  }
  attached_disk {
    source      = google_compute_disk.gmov6ip0c_disk_e.self_link
    device_name = "disk-e"
    mode        = "READ_WRITE"
  }
  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
  labels = { environment = "test", generation = "gmov6ip0c", name = "GCPAPPTST03", granted_user = "pchen", granted_role = "editor" }
}

resource "google_compute_disk" "gmov6ip0c_disk_d" {
  name = "GCPAPPTST03-gmov6ip0c-disk-d"
  type = "pd-ssd"
  zone = "${var.gcp_region}-a"
  size = 50
  labels = { environment = "test", drive = "drive-d" }
}
resource "google_compute_disk" "gmov6ip0c_disk_e" {
  name = "GCPAPPTST03-gmov6ip0c-disk-e"
  type = "pd-ssd"
  zone = "${var.gcp_region}-a"
  size = 60
  labels = { environment = "test", drive = "drive-e" }
}
output "gmov6ip0c_names"        { value = google_compute_instance.gmov6ip0c[*].name }
output "gmov6ip0c_internal_ips" { value = google_compute_instance.gmov6ip0c[*].network_interface[0].network_ip }