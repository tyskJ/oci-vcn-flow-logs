/************************************************************
Log Group
************************************************************/
##### For VPC Flow Logs
resource "oci_logging_log_group" "lg_vpc_flow_logs" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "lg-vpc-flow-logs"
  description    = "For VPC Flow Logs"
}
