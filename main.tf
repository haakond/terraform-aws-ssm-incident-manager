# Systems Manager resources
resource "aws_ssmincidents_replication_set" "default" {
  region {
    name = local.current_region
  }
  region {
    name = var.replication_set_fallback_region
  }

  tags = {
    Name = "default"
  }
}

resource "aws_ssmcontacts_contact" "primary_contact" {
  alias        = var.primary_contact_alias
  display_name = var.primary_contact_display_name
  type         = "PERSONAL"

  tags = {
    key = "primary-contact"
  }
  depends_on = [aws_ssmincidents_replication_set.default]
}

resource "aws_ssmcontacts_contact_channel" "primary_contact_email" {
  contact_id = aws_ssmcontacts_contact.primary_contact.arn

  delivery_address {
    simple_address = var.primary_contact_email_address
  }

  name = "primary-contact-email"
  type = "EMAIL"
}

resource "aws_ssmcontacts_contact_channel" "primary_contact_sms" {
  contact_id = aws_ssmcontacts_contact.primary_contact.arn

  delivery_address {
    simple_address = var.primary_contact_phone_number
  }

  name = "primary-contact-sms"
  type = "SMS"
}

resource "aws_ssmcontacts_contact_channel" "primary_contact_voice" {
  contact_id = aws_ssmcontacts_contact.primary_contact.arn

  delivery_address {
    simple_address = var.primary_contact_phone_number
  }

  name = "primary-contact-voice"
  type = "VOICE"
}

resource "aws_ssmcontacts_plan" "primary_contact" {
  contact_id = aws_ssmcontacts_contact.primary_contact.arn

  stage {
    duration_in_minutes = 1

    target {
      channel_target_info {
        retry_interval_in_minutes = 5
        contact_channel_id        = aws_ssmcontacts_contact_channel.primary_contact_email.arn
      }
    }
  }
  stage {
    duration_in_minutes = 5

    target {
      channel_target_info {
        retry_interval_in_minutes = 5
        contact_channel_id        = aws_ssmcontacts_contact_channel.primary_contact_sms.arn
      }
    }
  }
  stage {
    duration_in_minutes = 10

    target {
      channel_target_info {
        retry_interval_in_minutes = 5
        contact_channel_id        = aws_ssmcontacts_contact_channel.primary_contact_voice.arn
      }
    }
  }
}

resource "aws_ssmincidents_response_plan" "critical_incident" {
  name = "critical-incident"

  incident_template {
    title  = "critical-incident"
    impact = "1"
    incident_tags = {
      Name = "critical-incident"
    }

    summary = "Follow Critical Incident process."
  }

  display_name = "critical-service-unavailable"
  chat_channel = [var.chatbot_sns_topic_notification_arn]
  engagements  = [awscc_ssmcontacts_contact.oncall_schedule.arn]

  action {
    ssm_automation {
      document_name    = aws_ssm_document.critical_incident_runbook.arn
      role_arn         = aws_iam_role.service_role_for_ssm_incident_manager.arn
      document_version = "$LATEST"
      target_account   = "RESPONSE_PLAN_OWNER_ACCOUNT"
      parameter {
        name   = "Environment"
        values = ["Production"]
      }
      dynamic_parameters = {
        resources   = "INVOLVED_RESOURCES"
        incidentARN = "INCIDENT_RECORD_ARN"
      }
    }
  }

  tags = {
    Name = "critical-incident-response-plan"
  }

  depends_on = [aws_ssmincidents_replication_set.default]
}

resource "awscc_ssmcontacts_contact" "oncall_schedule" {

  alias        = "default-schedule"
  display_name = "default-schedule"
  type         = "ONCALL_SCHEDULE"
  plan = [{
    rotation_ids = [aws_ssmcontacts_rotation.business_hours.id]
  }]
  depends_on = [aws_ssmincidents_replication_set.default]
}

resource "aws_ssmcontacts_rotation" "business_hours" {
  contact_ids = [
    aws_ssmcontacts_contact.primary_contact.arn
  ]

  name = "business-hours"

  recurrence {
    number_of_on_calls    = 1
    recurrence_multiplier = 1
    weekly_settings {
      day_of_week = "MON"
      hand_off_time {
        hour_of_day    = 09
        minute_of_hour = 00
      }
    }

    weekly_settings {
      day_of_week = "FRI"
      hand_off_time {
        hour_of_day    = 15
        minute_of_hour = 55
      }
    }

    shift_coverages {
      map_block_key = "MON"
      coverage_times {
        start {
          hour_of_day    = 08
          minute_of_hour = 30
        }
        end {
          hour_of_day    = 16
          minute_of_hour = 00
        }
      }
    }
    shift_coverages {
      map_block_key = "TUE"
      coverage_times {
        start {
          hour_of_day    = 08
          minute_of_hour = 30
        }
        end {
          hour_of_day    = 16
          minute_of_hour = 00
        }
      }
    }
    shift_coverages {
      map_block_key = "WED"
      coverage_times {
        start {
          hour_of_day    = 08
          minute_of_hour = 30
        }
        end {
          hour_of_day    = 16
          minute_of_hour = 00
        }
      }
    }
    shift_coverages {
      map_block_key = "THU"
      coverage_times {
        start {
          hour_of_day    = 08
          minute_of_hour = 30
        }
        end {
          hour_of_day    = 16
          minute_of_hour = 00
        }
      }
    }
    shift_coverages {
      map_block_key = "FRI"
      coverage_times {
        start {
          hour_of_day    = 08
          minute_of_hour = 30
        }
        end {
          hour_of_day    = 16
          minute_of_hour = 00
        }
      }
    }
  }

  start_time   = var.rotation_start_time
  time_zone_id = "Europe/Oslo"
  depends_on   = [aws_ssmincidents_replication_set.default]
}

resource "aws_ssm_document" "critical_incident_runbook" {
  name            = "critical_incident_runbook"
  document_type   = "Command"
  document_format = "YAML"
  content         = <<DOC
#
# Original source: AWSIncidents-CriticalIncidentRunbookTemplate
#
# Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
---
description: "This document is intended as a template for an incident response runbook in [Incident Manager](https://docs.aws.amazon.com/incident-manager/latest/userguide/index.html).\n\nFor optimal use, create your own automation document by copying the contents of this runbook template and customizing it for your scenario. Then, navigate to your [Response Plan](https://console.aws.amazon.com/systems-manager/incidents/response-plans/home) and associate it with your new automation document; your runbook is automatically started when an incident is created with the associated response plan. For more information, see [Incident Manager - Runbooks](https://docs.aws.amazon.com/incident-manager/latest/userguide/runbooks.html). \v\n\nSuggested customizations include:\n* Updating the text in each step to provide specific guidance and instructions, such as commands to run or links to relevant dashboards\n* Automating actions before triage or diagnosis to gather additional telemetry or diagnostics using aws:executeAwsApi\n* Automating actions in mitigation using aws:executeAutomation, aws:executeScript, or aws:invokeLambdaFunction\n"
schemaVersion: '0.3'
parameters:
  Environment:
    type: String
  incidentARN:
    type: String
  resources:
    type: String
mainSteps:
  - name: Triage
    action: 'aws:pause'
    inputs: {}
    description: |-
      **Determine customer impact**

      * View the **Metrics** tab of the incident or navigate to your [CloudWatch Dashboards](https://console.aws.amazon.com/cloudwatch/home#dashboards:) to find key performance indicators (KPIs) that show the extent of customer impact.
      * Use [CloudWatch Synthetics](https://console.aws.amazon.com/cloudwatch/home#synthetics:) and [Contributor Insights](https://console.aws.amazon.com/cloudwatch/home#contributorinsights:) to identify real-time failures in customer workflows.

      **Communicate customer impact**

      Update the following fields to accurately describe the incident:
      * **Title** - The title should be quickly recognizable by the team and specific to the particular incident.
      * **Summary** - The summary should contain the most important and up-to-date information to quickly onboard new responders to the incident.
      * **Impact** - Select one of the following impact ratings to describe the incident:
        * 1 – Critical impact, full application failure that impacts many to all customers.
        * 2 – High impact, partial application failure with impact to many customers.
        * 3 – Medium impact, the application is providing reduced service to many customers.
        * 4 – Low impact, the application is providing reduced service to few customers.
        * 5 – No impact, customers are not currently impacted but urgent action is needed to avoid impact.
  - name: Diagnosis
    action: 'aws:pause'
    inputs: {}
    description: |
      **Rollback**

      * Look for recent changes to the production environment that might have caused the incident. Engage the responsible team using the **Contacts** tab of the incident.
      * Rollback these changes if possible.

      **Locate failures**
      * Review metrics and alarms related to your [Application](https://console.aws.amazon.com/systems-manager/appmanager/applications). Add any related metrics and alarms to the **Metrics** tab of the incident.
      * Use [CloudWatch ServiceLens](https://console.aws.amazon.com/cloudwatch/home#servicelens:) to troubleshoot issues across multiple services.
      * Investigate the possibility of ongoing incidents across your organization. Check for known incidents and issues in AWS using [Personal Health Dashboard](https://console.aws.amazon.com/systems-manager/insights). Add related links to the **Related Items** tab of the incident.
      * Avoid going too deep in diagnosing the failure and focus on how to mitigate the customer impact. Update the **Timeline** tab of the incident when a possible diagnosis is identified.
  - name: Mitigation
    action: 'aws:pause'
    description: |-
      **Collaborate**
      * Communicate any changes or important information from the previous step to the members of the associated chat channel for this incident. Ask for input on possible ways to mitigate customer impact.
      * Engage additional contacts or teams using their escalation plan from the **Contacts** tab.
      * If necessary, prepare an emergency change request in [Change Manager](https://console.aws.amazon.com/systems-manager/change-manager).

      **Implement mitigation**
      * Consider re-routing customer traffic or throttling incoming requests to reduce customer impact.
      * Look for common runbooks in [Automation](https://console.aws.amazon.com/systems-manager/automation) or run commands using [Run Command](https://.console.aws.amazon.com/systems-manager/run-command).
      * Update the **Timeline** tab of the incident when a possible mitigation is identified. If needed, review the mitigation with others in the associated chat channel before proceeding.
    inputs: {}
  - name: Recovery
    action: 'aws:pause'
    inputs: {}
    description: |-
      **Monitor customer impact**
      * View the **Metrics** tab of the incident to monitor for recovery of your key performance indicators (KPIs).
      * Update the **Impact** field in the incident when customer impact has been reduced or resolved.

      **Identify action items**
      * Add entries in the **Timeline** tab of the incident to record key decisions and actions taken, including temporary mitigations that might have been implemented.
      * Create a **Post-Incident Analysis** when the incident is closed in order to identify and track action items in [OpsCenter](https://console.aws.amazon.com/systems-manager/opsitems).

DOC
}