variable "project-id" {
  type        = string
  description = "project id"
  default     = "odin-thirteen"
}

variable "is-network-created" {
  type        = bool
  default     = false
  description = "is network created; if yes the name will be vpc-{project-id}"
}

variable "regions" {
  type        = list(string)
  default     = [] //"us-central1", "us-west1"
  description = "subnet region"
}

variable "ip-cidrs" {
  type    = list(string)
  default = ["10.0.120.0/24", "10.0.192.0/24"]
}

variable "source-tags" {
  type    = list(any)
  default = []
}

variable "target-tags" {
  type    = list(any)
  default = []
}

variable "enable-advanced-features" {
  type        = bool
  default     = false
  description = "flag which when set to true will create NAT and other advanced network features"
}