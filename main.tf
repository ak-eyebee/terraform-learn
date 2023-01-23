# Get ankit-katba-rg
data "ibm_resource_group" "resource_group" {
  name = "ankit-katba-rg"
}

# OCP Cluster - single zone
resource "ibm_container_cluster" "cluster" {
  name              = "${var.cluster_name}${random_id.name.hex}"
  datacenter        = var.datacenter
  default_pool_size = var.default_pool_size
  machine_type      = var.machine_type
  hardware          = var.hardware
  kube_version      = var.kube_version
  resource_group_id = data.ibm_resource_group.resource_group.id
  private_vlan_id   = "3157108"
  public_vlan_id    = "3046978"
}

# Attach zone
resource "ibm_container_worker_pool_zone_attachment" "dal12" {
  cluster           = ibm_container_cluster.cluster.id
  worker_pool       = ibm_container_cluster.cluster.worker_pools.0.id
  zone              = "dal12"
  private_vlan_id   = "2852299"
  public_vlan_id    = "2852297"
  resource_group_id = data.ibm_resource_group.resource_group.id
}

# Attach zone
# resource "ibm_container_worker_pool_zone_attachment" "dal13" {
#   cluster           = ibm_container_cluster.cluster.id
#   worker_pool       = ibm_container_cluster.cluster.worker_pools.0.id
#   zone              = "dal13"
#   private_vlan_id   = "2846244"
#   public_vlan_id    = "3046972"
#   resource_group_id = data.ibm_resource_group.resource_group.id
# }

# Generate random id
resource "random_id" "name" {
  byte_length = 4
}

# CR namespace
resource "ibm_cr_namespace" "cr_namespace" {
  name              = var.cr_namespace
  resource_group_id = data.ibm_resource_group.resource_group.id
}

# CR namespace image retention policy
resource "ibm_cr_retention_policy" "cr_retention_policy" {
  namespace       = ibm_cr_namespace.cr_namespace.id
  images_per_repo = 10 #means retain 10 images in this CR ns
}

# IAM policy to user for CR namespace
resource "ibm_iam_user_policy" "policy" {
  ibm_id = "ankit.katba@ibm.com"
  roles  = ["Manager"]

  resources {
    service       = "container-registry"
    resource      = ibm_cr_namespace.cr_namespace.id
    resource_type = "namespace"
    region        = var.region
  }
}
