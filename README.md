# About
Terraform AWS sample module to demonstrate AWS Systems Manager - Incident Manager as explained at https://hedrange.com/ .

## Usage

See [examples/main.tf](examples/main.tf) and [examples/provider.tf](examples/provider.tf).
Do take note that this module depends on both the aws and awscc Terraform providers.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.53.0 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | ~> 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.53.0 |
| <a name="provider_awscc"></a> [awscc](#provider\_awscc) | ~> 1.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policy_for_service_role_for_ssm_incident_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.service_role_for_ssm_incident_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.service_role_for_ssm_incident_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_ssm_document.critical_incident_runbook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [aws_ssmcontacts_contact.primary_contact](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_contact) | resource |
| [aws_ssmcontacts_contact_channel.primary_contact_email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_contact_channel) | resource |
| [aws_ssmcontacts_contact_channel.primary_contact_sms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_contact_channel) | resource |
| [aws_ssmcontacts_contact_channel.primary_contact_voice](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_contact_channel) | resource |
| [aws_ssmcontacts_plan.primary_contact](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_plan) | resource |
| [aws_ssmcontacts_rotation.business_hours](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_rotation) | resource |
| [aws_ssmincidents_replication_set.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmincidents_replication_set) | resource |
| [aws_ssmincidents_response_plan.critical_incident](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmincidents_response_plan) | resource |
| [awscc_ssmcontacts_contact.oncall_schedule](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/ssmcontacts_contact) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |
| [aws_iam_policy_document.assume_role_policy_for_service_role_for_ssm_incident_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.policy_for_service_role_for_ssm_incident_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chatbot_sns_topic_notification_arn"></a> [chatbot\_sns\_topic\_notification\_arn](#input\_chatbot\_sns\_topic\_notification\_arn) | Full ARN to SNS topic for AWS Chatbot notifications. | `string` | n/a | yes |
| <a name="input_primary_contact_alias"></a> [primary\_contact\_alias](#input\_primary\_contact\_alias) | Primary contact alias. | `string` | n/a | yes |
| <a name="input_primary_contact_display_name"></a> [primary\_contact\_display\_name](#input\_primary\_contact\_display\_name) | Primary contact display name. | `string` | n/a | yes |
| <a name="input_primary_contact_email_address"></a> [primary\_contact\_email\_address](#input\_primary\_contact\_email\_address) | Valid email address (required). | `string` | n/a | yes |
| <a name="input_primary_contact_phone_number"></a> [primary\_contact\_phone\_number](#input\_primary\_contact\_phone\_number) | Valid phone number in format '+' followed by the country code and phone number. | `string` | n/a | yes |
| <a name="input_rotation_start_time"></a> [rotation\_start\_time](#input\_rotation\_start\_time) | SSM Incident Manager rotation schedule start time in ISO8601 format. Example. "2024-06-24T08:00:00+00:00". | `string` | n/a | yes |
| <a name="input_replication_set_fallback_region"></a> [replication\_set\_fallback\_region](#input\_replication\_set\_fallback\_region) | Replication set fallback region. | `string` | `"eu-west-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_critical_incident_response_plan_arn"></a> [critical\_incident\_response\_plan\_arn](#output\_critical\_incident\_response\_plan\_arn) | SSM Incident Manager Response Plan ARN - Can be configured as actions with CloudWatch Alarms etc. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

**Note**: The inputs and outputs sections are automatically generated by terraform-docs in a git pre-commit hook. This requires setup of [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform) . Follow the install instructions to use, including the dependencies setup. pre-commit ensures correct formatting, linting and generation of documentation. It also check's for trailing whitespace, merge conflics and mixed line endings. See [.pre-commit-config.yaml](./.pre-commit-config.yaml) for more information. A full guide to the pre-commit framework can be found [here](https://pre-commit.com/).

## Authors/contributors

See [contributors.](https://github.com/haakond/terraform-aws-lambda-function-url/graphs/contributors)

## License

MIT licensed. See [LICENSE](LICENSE). Feel free to fork and make use of what you want.
