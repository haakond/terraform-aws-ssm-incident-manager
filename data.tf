data "aws_caller_identity" "current" {}
data "aws_canonical_user_id" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "policy_for_service_role_for_ssm_incident_manager" {
  statement {
    sid    = "ServiceRoleForIncidentManager1"
    effect = "Allow"
    actions = [
      "ssm:StartAutomationExecution",
    ]
    resources = [
      "arn:aws:ssm:*:${local.aws_account_id}:automation-definition/AWSIncidents-CriticalIncidentRunbookTemplate:*",
      "arn:aws:ssm:*:${local.aws_account_id}:document/AWSIncidents-CriticalIncidentRunbookTemplate:*",
      "arn:aws:ssm:*::automation-definition/AWSIncidents-CriticalIncidentRunbookTemplate:*",
      "arn:aws:ssm:eu-central-1:594179624893:automation-definition/${aws_ssm_document.critical_incident_runbook.name}:*",
      "arn:aws:ssm:*:${local.aws_account_id}:document/${aws_ssm_document.critical_incident_runbook.name}:*",
    ]
  }
}

data "aws_iam_policy_document" "assume_role_policy_for_service_role_for_ssm_incident_manager" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ssm-incidents.amazonaws.com"]
    }
  }
}
