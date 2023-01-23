variable "machine_type" {
  default = "b3c.4x16"
}

variable "hardware" {
  default = "shared"
}

variable "datacenter" {
  default = "dal10"
}

variable "default_pool_size" {
  default = "2"
}

variable "cluster_name" {
  default = "ak_openshift_tf"
}

variable "kube_version" {
  default = "4.11_openshift"
}

variable "cr_namespace" {
  default = "ak-tf-cr-ns"
}
