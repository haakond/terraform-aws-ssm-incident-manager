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


data "aws_iam_policy_document" "sns_topic_policy_for_aws_chatbot_forwarder" {
  policy_id = "__default_policy_ID"

  statement {
    sid    = "__default_statement_ID"
    effect = "Allow"
    actions = [
      "sns:Subscribe",
      "sns:SetTopicAttributes",
      "sns:RemovePermission",
      "sns:Receive",
      "sns:Publish",
      "sns:ListSubscriptionsByTopic",
      "sns:GetTopicAttributes",
      "sns:DeleteTopic",
      "sns:AddPermission",
    ]
    resources = [aws_sns_topic.sns_topic_forwarder_aws_chatbot.arn]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }

  }
  statement {
    sid    = "SSMIncidentManagerPublish"
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [aws_sns_topic.sns_topic_forwarder_aws_chatbot.arn]

    principals {
      type        = "Service"
      identifiers = ["ssm-incidents.amazonaws.com"]
    }
  }
}