resource "google_project_iam_member" "sa_member" {
  count   = length(var.role_list)
  project = var.project_id
  role    = var.role_list[count.index]
  member  = "serviceAccount:${google_service_account.generic_service_account.email}"
}