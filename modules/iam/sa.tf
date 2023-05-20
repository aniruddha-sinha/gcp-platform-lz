resource "google_service_account" "generic_service_account" {
  account_id   = var.service_account_id
  project      = var.project_id
  display_name = var.service_account_display_name
}