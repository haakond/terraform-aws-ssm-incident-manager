# Use aws and awscc providers to provision SSM Incident Manager
# Ref. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/using-aws-with-awscc-provider
# Refers to output from the previous module provision for AWS Chatbot.
# Find relevant commit hash from https://github.com/haakond/terraform-aws-ssm-incident-manager/commits/main/
module "ssm_incident_manager" {
  source = "git::https://github.com/haakond/terraform-aws-ssm-incident-manager.git?ref=0207532049b386d9038ec10aa735c737cba76748"
  providers = {
    aws   = aws
    awscc = awscc
  }
  primary_contact_alias              = "primary-contact"
  primary_contact_display_name       = "Firstname Lastname"
  primary_contact_email_address      = "alpha.bravo@charlie-company.com"
  primary_contact_phone_number       = "+4799887766"
  chatbot_sns_topic_notification_arn = module.aws_chatbot_slack.chatbot_sns_topic_arn_primary_region
  rotation_start_time                = "2024-06-24T07:00:00+00:00"
}