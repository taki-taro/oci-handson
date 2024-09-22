resource "oci_core_instance" "test_instance" {
    #Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = local.compartment_id
    shape = "VM.Standard.E2.1.Micro"
    preserve_boot_volume = false

    create_vnic_details {

        #Optional
        assign_private_dns_record = true
        assign_public_ip = true
        freeform_tags = {
        "Env"= "terraform"
        }
        nsg_ids = oci_core_network_security_group.test_network_security_group.id
        subnet_id = oci_core_subnet.test_subnet_public.id
    }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}