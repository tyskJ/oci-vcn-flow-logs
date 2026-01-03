/************************************************************
VCN
************************************************************/
resource "oci_core_vcn" "vcn" {
  compartment_id = oci_identity_compartment.workload.id
  cidr_block     = "10.0.0.0/16"
  display_name   = "vcn"
  dns_label      = "vcn"
}

/************************************************************
Security List
************************************************************/
resource "oci_core_security_list" "sl" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "nothing-security-list"
}

/************************************************************
Subnet
************************************************************/
resource "oci_core_subnet" "public" {
  compartment_id             = oci_identity_compartment.workload.id
  vcn_id                     = oci_core_vcn.vcn.id
  cidr_block                 = "10.0.1.0/24"
  display_name               = "public"
  dns_label                  = "public"
  security_list_ids          = [oci_core_security_list.sl.id]
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
}

/************************************************************
Internet Gateway
************************************************************/
resource "oci_core_internet_gateway" "igw" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "igw"
}

/************************************************************
Route Table
************************************************************/
resource "oci_core_route_table" "rtb" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "rtb"
  route_rules {
    network_entity_id = oci_core_internet_gateway.igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_route_table_attachment" "attachment" {
  subnet_id      = oci_core_subnet.public.id
  route_table_id = oci_core_route_table.rtb.id
}

/************************************************************
Network Security Group
************************************************************/
resource "oci_core_network_security_group" "sg" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "sg"
}

resource "oci_core_network_security_group_security_rule" "sg_rule_1" {
  network_security_group_id = oci_core_network_security_group.sg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.source_ip
  stateless                 = false
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "sg_rule_2" {
  network_security_group_id = oci_core_network_security_group.sg.id
  protocol                  = "1"
  direction                 = "INGRESS"
  source                    = var.source_ip
  stateless                 = false
  source_type               = "CIDR_BLOCK"
}

resource "oci_core_network_security_group_security_rule" "sg_rule_3" {
  network_security_group_id = oci_core_network_security_group.sg.id
  protocol                  = "all"
  direction                 = "EGRESS"
  destination               = "0.0.0.0/0"
  stateless                 = false
  destination_type          = "CIDR_BLOCK"
}