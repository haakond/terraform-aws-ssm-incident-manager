resource "aws_iam_role" "service_role_for_ssm_incident_manager" {
  name               = "aws-ssm-incident-manager-service-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_for_service_role_for_ssm_incident_manager.json
}
