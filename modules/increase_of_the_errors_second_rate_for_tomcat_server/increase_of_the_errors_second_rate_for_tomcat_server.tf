resource "shoreline_notebook" "increase_of_the_errors_second_rate_for_tomcat_server" {
  name       = "increase_of_the_errors_second_rate_for_tomcat_server"
  data       = file("${path.module}/data/increase_of_the_errors_second_rate_for_tomcat_server.json")
  depends_on = [shoreline_action.invoke_tomcat_usage_check,shoreline_action.invoke_tomcat_diagnosis,shoreline_action.invoke_tomcat_logs_analysis,shoreline_action.invoke_check_deployed_app]
}

resource "shoreline_file" "tomcat_usage_check" {
  name             = "tomcat_usage_check"
  input_file       = "${path.module}/data/tomcat_usage_check.sh"
  md5              = filemd5("${path.module}/data/tomcat_usage_check.sh")
  description      = "The host machine running the Tomcat server is experiencing high CPU or memory usage, causing the server to become unresponsive and generate errors."
  destination_path = "/agent/scripts/tomcat_usage_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "tomcat_diagnosis" {
  name             = "tomcat_diagnosis"
  input_file       = "${path.module}/data/tomcat_diagnosis.sh"
  md5              = filemd5("${path.module}/data/tomcat_diagnosis.sh")
  description      = "A software update or configuration change was made to the Tomcat server that caused it to malfunction and produce errors."
  destination_path = "/agent/scripts/tomcat_diagnosis.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "tomcat_logs_analysis" {
  name             = "tomcat_logs_analysis"
  input_file       = "${path.module}/data/tomcat_logs_analysis.sh"
  md5              = filemd5("${path.module}/data/tomcat_logs_analysis.sh")
  description      = "Check the server logs to determine the cause of the errors and identify any patterns or trends that may be contributing to the increase in errors."
  destination_path = "/agent/scripts/tomcat_logs_analysis.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_deployed_app" {
  name             = "check_deployed_app"
  input_file       = "${path.module}/data/check_deployed_app.sh"
  md5              = filemd5("${path.module}/data/check_deployed_app.sh")
  description      = "Check the deployed application to ensure that it is functioning correctly and that there are no coding errors or configuration issues."
  destination_path = "/agent/scripts/check_deployed_app.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_tomcat_usage_check" {
  name        = "invoke_tomcat_usage_check"
  description = "The host machine running the Tomcat server is experiencing high CPU or memory usage, causing the server to become unresponsive and generate errors."
  command     = "`chmod +x /agent/scripts/tomcat_usage_check.sh && /agent/scripts/tomcat_usage_check.sh`"
  params      = ["CPU_THRESHOLD","NODE_NAME","MEMORY_THRESHOLD"]
  file_deps   = ["tomcat_usage_check"]
  enabled     = true
  depends_on  = [shoreline_file.tomcat_usage_check]
}

resource "shoreline_action" "invoke_tomcat_diagnosis" {
  name        = "invoke_tomcat_diagnosis"
  description = "A software update or configuration change was made to the Tomcat server that caused it to malfunction and produce errors."
  command     = "`chmod +x /agent/scripts/tomcat_diagnosis.sh && /agent/scripts/tomcat_diagnosis.sh`"
  params      = ["TOMCAT_POD_NAME","TOMCAT_CONFIG_FILE","EXPECTED_TOMCAT_SETTINGS"]
  file_deps   = ["tomcat_diagnosis"]
  enabled     = true
  depends_on  = [shoreline_file.tomcat_diagnosis]
}

resource "shoreline_action" "invoke_tomcat_logs_analysis" {
  name        = "invoke_tomcat_logs_analysis"
  description = "Check the server logs to determine the cause of the errors and identify any patterns or trends that may be contributing to the increase in errors."
  command     = "`chmod +x /agent/scripts/tomcat_logs_analysis.sh && /agent/scripts/tomcat_logs_analysis.sh`"
  params      = ["TOMCAT_POD_NAME","TOMCAT_CONTAINER_NAME"]
  file_deps   = ["tomcat_logs_analysis"]
  enabled     = true
  depends_on  = [shoreline_file.tomcat_logs_analysis]
}

resource "shoreline_action" "invoke_check_deployed_app" {
  name        = "invoke_check_deployed_app"
  description = "Check the deployed application to ensure that it is functioning correctly and that there are no coding errors or configuration issues."
  command     = "`chmod +x /agent/scripts/check_deployed_app.sh && /agent/scripts/check_deployed_app.sh`"
  params      = ["SERVICE_IP","DEPLOYMENT_NAME","SERVICE_NAME","PORT"]
  file_deps   = ["check_deployed_app"]
  enabled     = true
  depends_on  = [shoreline_file.check_deployed_app]
}

