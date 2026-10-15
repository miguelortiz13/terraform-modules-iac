output "policy_ids" {
  description = "IDs de las SCP creadas, por clave (`proteccion-org`, `regiones`, `servicios-caros`, `tamanos`)."
  value       = { for k, p in aws_organizations_policy.this : k => p.id }
}

output "policy_contents" {
  description = "JSON de cada SCP, para revisarlo en el plan."
  value       = { for k, p in aws_organizations_policy.this : k => p.content }
}
