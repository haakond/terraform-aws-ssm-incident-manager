# Systems Manager resources
resource "aws_ssmincidents_replication_set" "default" {
  region {
    name = "eu-central-1"
  }
  region {
    name = "eu-west-1"
  }

  tags = {
    Name = "default"
  }
}

resource "aws_ssmcontacts_contact" "primary_contact" {
  alias        = "primary-contact"
  display_name = var.primary_contact_display_name
  type         = "PERSONAL"

  tags = {
    key = "primary-contact"
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
        hour_of_day    = 8
        minute_of_hour = 00
      }
    }

    weekly_settings {
      day_of_week = "FRI"
      hand_off_time {
        hour_of_day    = 16
        minute_of_hour = 00
      }
    }

    shift_coverages {
      map_block_key = "MON"
      coverage_times {
        start {
          hour_of_day    = 9
          minute_of_hour = 0
        }
        end {
          hour_of_day    = 16
          minute_of_hour = 00
        }
      }
    }
  }
  start_time   = "2024-06-11T00:00:00+00:00"
  time_zone_id = "Europe/Oslo"
  depends_on   = [aws_ssmincidents_replication_set.default]
}

resource "aws_ssmincidents_response_plan" "critical_response_plan_service_unavailable" {
  name = "critical-service-unavailable"

  incident_template {
    title         = "critical-service-unavailable"
    impact        = "1"
    dedupe_string = "critical-service-unavailable"
    incident_tags = {
      Name = "critical-service-unavailable"
    }

    #notification_target {
    #  sns_topic_arn = var.sns_topic_notification_arn
    #}

    summary = "Follow Critical Incident Service Unavailable process."
  }

  display_name = "critical-service-unavailable"
  #chat_channel = [var.sns_topic_notification_arn]
  engagements = [aws_ssmcontacts_contact.primary_contact.arn]

  action {
    ssm_automation {
      document_name    = "AWSIncidents-CriticalIncidentRunbookTemplate"
      role_arn         = "arn:aws:iam::${local.aws_account_id}:role/aws-service-role/ssm-incidents.amazonaws.com/AWSServiceRoleForIncidentManager"
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
    Name = "critical-service-unavailable-response-plan"
  }

  depends_on = [aws_ssmincidents_replication_set.default]
}

resource "aws_ssmincidents_response_plan" "critical_response_plan_security_hub" {
  name = "Critical-SecurityHub"

  incident_template {
    title         = "critical-security-hub"
    impact        = "1"
    dedupe_string = "critical-incident-security-hub"
    incident_tags = {
      Name = "critical-incident-security-hub"
    }

    #notification_target {
    #  sns_topic_arn = var.sns_topic_notification_arn
    #}

    summary = "Follow Critical Incident for Security Hub alert process."
  }

  display_name = "critical-incident-security-hub"
  #chat_channel = [var.sns_topic_notification_arn]
  engagements = [aws_ssmcontacts_contact.primary_contact.arn]

  action {
    ssm_automation {
      document_name  = "AWSIncidents-CriticalIncidentRunbookTemplate"
      role_arn       = "arn:aws:iam::${local.aws_account_id}:role/service-role/IncidentManagerIncidentAccessServiceRole"
      target_account = "RESPONSE_PLAN_OWNER_ACCOUNT"
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
    Name = "critical-incident-security-hub-response-plan"
  }

  depends_on = [aws_ssmincidents_replication_set.default]
}
