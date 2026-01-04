/************************************************************
Compartment - workload
************************************************************/
resource "oci_identity_compartment" "workload" {
  compartment_id = var.tenancy_ocid
  name           = "vcn-flow-logs"
  description    = "For VCN Flow Logs"
  enable_delete  = true
}