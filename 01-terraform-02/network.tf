# Creating a cloud network

data "yandex_vpc_network" "network" {
  name = local.network_name
}

# Creating subnets

data "yandex_vpc_subnet" "subnet-1" {
  name = local.subnet-pub-1
}

data "yandex_vpc_subnet" "subnet-2" {
  name = local.subnet-pub-2
}

data "yandex_vpc_subnet" "subnet-3" {
  name = local.subnet-pub-3
}