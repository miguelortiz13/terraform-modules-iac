mock_provider "aws" {
  mock_resource "aws_organizations_account" {
    defaults = {
      id  = "111122223333"
      arn = "arn:aws:organizations::000000000000:account/o-abcdefghij/111122223333"
    }
  }
}

variables {
  name      = "demo"
  email     = "owner+aws-demo@example.com"
  parent_id = "ou-ab12-cd34ef56"
}

run "cuenta_en_ou" {
  command = apply

  assert {
    condition     = aws_organizations_account.this.parent_id == "ou-ab12-cd34ef56"
    error_message = "La cuenta debe quedar en la OU indicada."
  }

  assert {
    condition     = aws_organizations_account.this.close_on_deletion == false
    error_message = "Por defecto destroy no debe cerrar la cuenta."
  }

  assert {
    condition     = output.admin_role_arn == "arn:aws:iam::111122223333:role/OrganizationAccountAccessRole"
    error_message = "El ARN del rol de administración no es el esperado."
  }
}

run "correo_invalido" {
  command = plan

  variables {
    email = "no-es-correo"
  }

  expect_failures = [var.email]
}

run "padre_invalido" {
  command = plan

  variables {
    parent_id = "Workloads"
  }

  expect_failures = [var.parent_id]
}
