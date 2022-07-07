variable "region" {
  description = "GCP region"
  default     = "europe-west1"
}

variable "instance_type"{
  description = "Instance Type"
  default = "e2-medium"
}

variable "instance_name"{
  description = "VM Name"
  default = "vm-default"
}
