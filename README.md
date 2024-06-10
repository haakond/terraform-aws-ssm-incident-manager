# About
Terraform AWS sample module to demonstrate AWS Chatbot and Systems Manager - Incident Manager as explained at https://hedrange.com/ .

## Usage

See [examples/main.tf](examples/main.tf).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.51.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.51.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssmcontacts_contact.primary_contact](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_contact) | resource |
| [aws_ssmcontacts_contact_channel.primary_contact_email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_contact_channel) | resource |
| [aws_ssmcontacts_contact_channel.primary_contact_sms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_contact_channel) | resource |
| [aws_ssmcontacts_contact_channel.primary_contact_voice](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_contact_channel) | resource |
| [aws_ssmcontacts_plan.primary_contact](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_plan) | resource |
| [aws_ssmincidents_replication_set.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmincidents_replication_set) | resource |
| [aws_ssmincidents_response_plan.critical_response_plan_security_hub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmincidents_response_plan) | resource |
| [aws_ssmincidents_response_plan.critical_response_plan_service_unavailable](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmincidents_response_plan) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_escalation_contact_display_name"></a> [escalation\_contact\_display\_name](#input\_escalation\_contact\_display\_name) | Escalation contact display name. | `string` | n/a | yes |
| <a name="input_escalation_contact_email_address"></a> [escalation\_contact\_email\_address](#input\_escalation\_contact\_email\_address) | Valid email address (required). | `string` | n/a | yes |
| <a name="input_primary_contact_display_name"></a> [primary\_contact\_display\_name](#input\_primary\_contact\_display\_name) | Primary contact display name. | `string` | n/a | yes |
| <a name="input_primary_contact_email_address"></a> [primary\_contact\_email\_address](#input\_primary\_contact\_email\_address) | Valid email address (required). | `string` | n/a | yes |
| <a name="input_primary_contact_phone_number"></a> [primary\_contact\_phone\_number](#input\_primary\_contact\_phone\_number) | Valid phone number in format '+' followed by the country code and phone number. | `string` | n/a | yes |
| <a name="input_sns_topic_notification_arn"></a> [sns\_topic\_notification\_arn](#input\_sns\_topic\_notification\_arn) | Full ARN to SNS topic for notifications. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

**Note**: The inputs and outputs sections are automatically generated by terraform-docs in a git pre-commit hook. This requires setup of [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform) . Follow the install instructions to use, including the dependencies setup. pre-commit ensures correct formatting, linting and generation of documentation. It also check's for trailing whitespace, merge conflics and mixed line endings. See [.pre-commit-config.yaml](./.pre-commit-config.yaml) for more information. A full guide to the pre-commit framework can be found [here](https://pre-commit.com/).

## Authors/contributors

See [contributors.](https://github.com/haakond/terraform-aws-lambda-function-url/graphs/contributors)

## License

MIT licensed. See [LICENSE](LICENSE). Feel free to fork and make use of what you want.
