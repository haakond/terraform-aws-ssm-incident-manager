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
      document_name    = "AWSIncidents-CriticalIncidentRunbookTemplate"
      role_arn         = aws_iam_role.service_role_for_ssm_incident_manager.arn
      document_version = "$LATEST"
      target_account   = "RESPONSE_PLAN_OWNER_ACCOUNT"
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