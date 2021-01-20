terraform {
	required_providers {
		ontap = {
			version = "0.1"
			source = "netapp.com/warrenb/ontap"
		}
	}
}

provider "ontap" {
	username = "admin"
	password = "Netapp1!"
	cluster = "10.216.2.130"
}

data "ontap_cluster" "cluster" {}

resource "ontap_svm" "svm" {
	name = "svm2"
	dns_domains = [ "csopslabs.netapp.com" ]
	dns_servers = [ "10.61.80.122" ]

	ip_interface {
		name = "iscsi_a"
		ip_address = "10.216.2.132"
		ip_netmask = 24
		home_node = data.ontap_cluster.cluster.nodes[0].name		
		service_policy = "default-data-blocks"
	}

	ip_interface {
		name = "iscsi_b"
		ip_address = "10.216.2.133"
		ip_netmask = 24
		home_node = data.ontap_cluster.cluster.nodes[0].name
		service_policy = "default-data-blocks"
	}	

	route {
		destination_address = "0.0.0.0"
		destination_netmask = 0
		gateway = "10.216.2.1"
	}
}
