
#================== -MASTERS- =========================

resource "yandex_compute_instance_group" "control-plane" {
  name                = "k8s-control-plane"
  folder_id           = var.folder_id
  service_account_id  = data.yandex_iam_service_account.sa.id
  deletion_protection = false # защита_от_удаления:_true_или_false
 
  instance_template {
    platform_id = "standard-v1"
    name        = "master-{instance.index}"
    resources {
      memory = local.master_memory[terraform.workspace] # объем_RAM_в_ГБ
      cores  = local.master_cores[terraform.workspace] # количество_ядер_vCPU
      core_fraction = local.master_core_fraction[terraform.workspace] # базовая  производительность в процентах
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd81n0sfjm6d5nq6l05g"
        size     = local.master_disk_size[terraform.workspace]
        type     = local.master_disk_type[terraform.workspace]
      }
    }

    network_interface {
      network_id = data.yandex_vpc_network.network.id
      subnet_ids = [
        data.yandex_vpc_subnet.subnet-1.id,
        data.yandex_vpc_subnet.subnet-2.id,
        data.yandex_vpc_subnet.subnet-3.id,
      ]
      nat = true
    }
    metadata = { user-data = "#cloud-config\nusers:\n  - name: ${var.vm_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
    }
  }
  scale_policy {
    fixed_scale {
      size = local.master_group_size[terraform.workspace] # количество_ВМ_в_группе
    }
  }
  
  allocation_policy {
    zones = [
      local.zone-1,
      local.zone-2,
      local.zone-3
    ]
  }
  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

}

#================== -WORKERS- =========================
resource "yandex_compute_instance_group" "worker-nodes" {
  name                = "k8s-workers"
  folder_id           = var.folder_id
  service_account_id  = data.yandex_iam_service_account.sa.id
  deletion_protection = false # защита_от_удаления:_true_или_false
 
  instance_template {
    platform_id = "standard-v1"
    name        = "worker-{instance.index}"
    resources {
      memory = 2 # объем_RAM_в_ГБ
      cores  = 2 # количество_ядер_vCPU
      core_fraction = 100 # базовая  производительность в процентах
    }

    boot_disk {
      mode       = "READ_WRITE"
      initialize_params {
        image_id = "fd81n0sfjm6d5nq6l05g"
        size     = "20"
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id = data.yandex_vpc_network.network.id
      subnet_ids = [
        data.yandex_vpc_subnet.subnet-1.id,
        data.yandex_vpc_subnet.subnet-2.id,
        data.yandex_vpc_subnet.subnet-3.id,
      ]
      nat = true
    }
    metadata = { user-data = "#cloud-config\nusers:\n  - name: ${var.vm_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
    }
  }
  scale_policy {
    fixed_scale {
      size = local.worker_group_size[terraform.workspace] # количество_ВМ_в_группе
    }
  }
  
  allocation_policy {
    zones = [
      local.zone-1,
      local.zone-2,
      local.zone-3
    ]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  # load_balancer {
  #   target_group_name        = "target-group"
  #   target_group_description = "load balancer target group"
  # }
}

#================== -LOAD BALANCER- =========================

# resource "yandex_lb_network_load_balancer" "lb-1" {
#   name = "network-load-balancer-1"

#   listener {
#     name = "network-load-balancer-1-listener"
#     port = 80
#     external_address_spec {
#       ip_version = "ipv4"
#       address = "158.160.55.118"
#     }
#   }

#   attached_target_group {
#     target_group_id = yandex_compute_instance_group.worker-nodes.load_balancer.0.target_group_id

#     healthcheck {
#       name = "http"
#       http_options {
#         port = 80
#         path = "/index.html"
#       }
#     }
#   }
#   depends_on = [
#     yandex_compute_instance_group.worker-nodes
#   ]
# }