# Cuenta miembro de AWS Organizations: una por proyecto, como las suscripciones
# en Azure. Crear cuentas no cuesta; lo que se despliega dentro, sí.

resource "aws_organizations_account" "this" {
  name                       = var.name
  email                      = var.email
  parent_id                  = var.parent_id
  role_name                  = var.admin_role_name
  iam_user_access_to_billing = "ALLOW"
  close_on_deletion          = var.close_on_deletion
  tags                       = var.tags

  lifecycle {
    # AWS no devuelve role_name después de crear la cuenta: sin esto, una cuenta
    # importada se reemplazaría (y se cerraría) en el siguiente apply.
    ignore_changes = [role_name]
  }
}
