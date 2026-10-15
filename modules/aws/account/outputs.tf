output "id" {
  description = "ID de la cuenta (12 dígitos)."
  value       = aws_organizations_account.this.id
}

output "arn" {
  description = "ARN de la cuenta en Organizations."
  value       = aws_organizations_account.this.arn
}

output "admin_role_arn" {
  description = "ARN del rol de administración que se asume desde la cuenta de administración."
  value       = "arn:aws:iam::${aws_organizations_account.this.id}:role/${var.admin_role_name}"
}
