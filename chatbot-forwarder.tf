# SNS topic resource to forward AWS Chatbot notifications to central account SNS topic, since some resources can't post to SNS topics in external accounts
resource "aws_sns_topic" "sns_topic_forwarder_aws_chatbot" {
  #checkov:skip=CKV_AWS_26:
  name = "aws-chatbot-notifications-forwarder"
  tags = {
    Name    = "aws-chatbot-notifications-forwarder"
    Service = "monitoring"
  }
}

resource "aws_sns_topic_policy" "sns_topic_policy_for_aws_chatbot_forwarder" {
  arn    = aws_sns_topic.sns_topic_forwarder_aws_chatbot.arn
  policy = data.aws_iam_policy_document.sns_topic_policy_for_aws_chatbot_forwarder.json
}

module "aws_chatbot_notification_forwarder_lambda" {
  #checkov:skip=CKV_AWS_50: "X-ray tracing is not required"
  #checkov:skip=CKV_AWS_115: "There are no sensitive environment variables"
  #checkov:skip=CKV_AWS_117: "There is no incoming data from external network"
  #checkov:skip=CKV_AWS_173: "KMS encryption is not required"
  #checkov:skip=CKV_AWS_116: "DLQ is not required"
  #checkov:skip=CKV_AWS_272: "Code-signing is not required"
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-lambda.git?ref=3aa5b7ef58095ab1217c81a756f54501dd21d9e1"

  function_name                   = "aws-chatbot-notification-forwarder"
  description                     = "Forwards messages from local SNS to central SNS."
  handler                         = "index.lambda_handler"
  runtime                         = "python3.12"
  source_path                     = "${path.module}/src/lambda-sns-forwarder/index.py"
  timeout                         = 30
  cloudwatch_logs_log_group_class = "INFREQUENT_ACCESS"
  architectures                   = ["x86_64"]
  attach_policy_statements        = true
  policy_statements = {
    dynamodb = {
      effect    = "Allow",
      actions   = ["lambda:InvokeFunction"],
      resources = [aws_sns_topic.sns_topic_forwarder_aws_chatbot.arn]
    }
  }
  environment_variables = {
    subscribed_sns_topic_arn = aws_sns_topic.sns_topic_forwarder_aws_chatbot.arn
    target_sns_topic_arn     = var.sns_topic_notification_arn
  }
  tags = {
    Name = "LambdaFunctionUrlDemo"
  }
}

resource "aws_lambda_permission" "aws_chatbot_notification_forwarder_lambda_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.aws_chatbot_notification_forwarder_lambda.lambda_function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.sns_topic_forwarder_aws_chatbot.arn
}

resource "aws_sns_topic_subscription" "sns_subscription_for_aws_chatbot_forwarder" {
  topic_arn  = aws_sns_topic.sns_topic_forwarder_aws_chatbot.arn
  endpoint   = module.aws_chatbot_notification_forwarder_lambda.lambda_function_arn
  protocol   = "lambda"
  depends_on = [module.aws_chatbot_notification_forwarder_lambda.lambda_function_arn]
}
