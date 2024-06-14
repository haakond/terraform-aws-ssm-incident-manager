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
