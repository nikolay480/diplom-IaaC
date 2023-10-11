resource "yandex_compute_instance" "gitlab" {
name = "gitlab"
zone = local.zone-1

resources {
    core_fraction = 20
    cores  = 4
    memory = 8
}

boot_disk {
    initialize_params {
    image_id = "fd8f7ls8nshv4lfmp0rn"
    }
}

network_interface {
    subnet_id = data.yandex_vpc_subnet.subnet-3.id
    nat       = true
}

metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
}
}