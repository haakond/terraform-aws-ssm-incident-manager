
output "critical_incident_response_plan_arn" {
  value       = aws_ssmincidents_response_plan.critical_incident.arn
  description = "SSM Incident Manager Response Plan ARN - Can be configured as actions with CloudWatch Alarms etc."
  sensitive   = false
}