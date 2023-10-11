# Declaring variables for user-defined parameters

# variable "token" {
#   type = string
#   default = ""
#   description = "from env: export YC_TOKEN=$(yc iam create-token)"
# } 

variable "cloud_id" {
  type = string
  default = "b1gso2vle70451bc3egm"
  description = "from env: export TF_VAR_cloud_id=$(yc config get cloud-id)"
}

variable "folder_id" {
  type = string
  default = "b1ga4u00jltahn3l6fp9"
  description = "from env: export TF_VAR_folder_id=$(yc config get folder-id)"
}

variable "ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

# Adding other parameters

locals {
  network_name     = "k8s-net"
  subnet-pub-1     = "public-subnet-a"
  subnet-pub-2     = "public-subnet-b"
  subnet-pub-3     = "public-subnet-c"
  
  zone-1           = "ru-central1-a"
  zone-2           = "ru-central1-b"
  zone-3           = "ru-central1-c"
  
  vm_public_name   = "public-v1"
  vm_image_id      = "fd8t08ih94rivuk5q46j" # ubuntu-2004-lts
}
