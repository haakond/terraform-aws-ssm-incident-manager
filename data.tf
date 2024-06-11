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
      "arn:aws:ssm:*::automation-definition/AWSIncidents-CriticalIncidentRunbookTemplate:*"
    ]
  }
  statement {
    sid    = "ServiceRoleForIncidentManager2"
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    resources = [
      "arn:aws:iam::*:role/AWS-SystemsManager-AutomationExecutionRole"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:CalledViaLast"
      values   = ["ssm.amazonaws.com"]
    }
  }
}
