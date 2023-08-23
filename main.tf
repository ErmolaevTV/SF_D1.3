terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.65.0"
    }
  }
}
provider "yandex" {
  service_account_key_file = "key/key.json"
  cloud_id  = "b1gnlqmvass68p525ioo"
  folder_id = "b1gao9tkcei1b1u4b575"
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "sf-d13-swarm-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "sf-d13-swarm-subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

module "swarm_cluster" {
  source        = "./modules/instance"
  vpc_subnet_id = yandex_vpc_subnet.subnet.id
  managers      = 1
  workers       = 2
}

