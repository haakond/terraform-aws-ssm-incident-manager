module "chatbot_incident_manager" {
  # Check https://github.com/haakond/terraform-aws-chatbot-ssm-incident-manager/commits/main/ for the latest hash and update accordingly.
  source = "git::https://github.com/haakond/terraform-aws-chatbot-ssm-incident-manager?ref=250fa4335eaff852ddc7d9fc40b7e62aea8ab1e6"
}