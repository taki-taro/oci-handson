resource "oci_core_vcn" "test_vcn" {
    compartment_id = local.compartment_id
    cidr_blocks = local.vcn_cidr
    display_name = "terraform_test_vcn"
    dns_label = local.dns_label
    freeform_tags = {
        "Env"= "terraform"
    }
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
    compartment_id = local.compartment_id
    vcn_id = oci_core_vcn.test_vcn.id
    enabled = "true"
    display_name = "terraform_test_internet_gateway"
    freeform_tags = {
        "Env"= "terraform"
    }
}

resource "oci_core_route_table" "test_route_table" {
    compartment_id = local.compartment_id
    vcn_id = oci_core_vcn.vcn.id
    display_name = "terraform_test_route_subnet_public"
    freeform_tags = {
        "Env"= "terraform"
    }
    route_rules {
        network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
        cidr_block = "0.0.0.0/0"
        description = "default Route"
    }
}

resource "oci_core_subnet" "test_subnet_public" {
    cidr_block = local.vcn_subnet_cidr
    compartment_id = local.compartment_id
    vcn_id = oci_core_vcn.vcn.id
    display_name = "terraform_test_subnet"
    dns_label = local.dns_label
    freeform_tags = {
        "Env"= "terraform"
    }
    prohibit_public_ip_on_vnic = "assignPublicIp"
    route_table_id = oci_core_route_table.test_route_table.id
}

resource "oci_core_network_security_group" "test_network_security_group" {
    #Required
    compartment_id = local.compartment_id
    vcn_id = oci_core_vcn.test_vcn.id

    #Optional
    display_name = "terraform_test_security_group"
    freeform_tags = {
        "Env"= "terraform"
    }
}

resource "oci_core_network_security_group_security_rule" "test_network_security_group_security_rule" {
    #Required
    network_security_group_id = oci_core_network_security_group.test_network_security_group.id
    direction = "INGRESS"
    protocol = "TCP"

    #Optional
    destination_type = var.network_security_group_security_rule_destination_type
    source = "119.173.43.178/32"
}

