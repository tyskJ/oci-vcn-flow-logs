/************************************************************
Log Group
************************************************************/
##### For VCN Flow Logs
resource "oci_logging_log_group" "lg_vcn_flow_logs" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "lg-vcn-flow-logs"
  description    = "For VCN Flow Logs"
}

/************************************************************
Capture Filter - Flow log
************************************************************/
resource "oci_core_capture_filter" "cf_vcn_flow_logs" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "cf-vcn-flow-logs"
  filter_type    = "FLOWLOG"
  # ICMP Rule
  flow_log_capture_filter_rules {
    priority         = 0
    sampling_rate    = 1
    is_enabled       = true
    flow_log_type    = "ALL"
    rule_action      = "INCLUDE"
    source_cidr      = "0.0.0.0/0"
    destination_cidr = "10.0.0.0/16"
    protocol         = "1"
  }
}

/************************************************************
Logs
************************************************************/
##### VCN Flow Logs
resource "oci_logging_log" "vcn_flow_logs" {
  display_name = "logs-vcn-flow-logs-points-vcn"
  is_enabled   = true
  log_type     = "SERVICE"
  configuration {
    # 対象リソース及びキャプチャフィルタのコンパートメントが一致していること
    compartment_id = oci_identity_compartment.workload.id
    source {
      source_type = "OCISERVICE"
      service     = "flowlogs"
      category    = "vcn"
      resource    = oci_core_vcn.vcn.id
      parameters = {
        capture_filter = oci_core_capture_filter.cf_vcn_flow_logs.id
      }
    }
  }
  log_group_id       = oci_logging_log_group.lg_vcn_flow_logs.id
  retention_duration = 30
}

/************************************************************
Exec (Local)
************************************************************/
##### TimeWait
# cloud-init実行によりComputeが再起動するため
resource "terraform_data" "wait_oracle" {
  input = oci_core_instance.oracle_instance.id
}

resource "time_sleep" "wait_oracle_cloud_init_finish" {
  depends_on      = [terraform_data.wait_oracle]
  create_duration = "5m"
}

##### Ping
resource "terraform_data" "local_exec_ping" {
  depends_on = [
    time_sleep.wait_oracle_cloud_init_finish,
    oci_core_route_table_attachment.attachment,
    oci_core_network_security_group_security_rule.sg_rule_2,
    oci_logging_log.vcn_flow_logs
  ]
  provisioner "local-exec" {
    command = <<EOT
      echo Test Ping
      ping ${oci_core_instance.oracle_instance.public_ip} -c 5
    EOT
  }
}