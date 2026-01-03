/************************************************************
Compartment - workload
************************************************************/
resource "oci_identity_compartment" "workload" {
  compartment_id = var.tenancy_ocid
  name           = "vpc-flow-logs"
  description    = "For VPC Flow Logs"
  enable_delete  = true
}