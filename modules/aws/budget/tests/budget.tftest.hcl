mock_provider "aws" {}

variables {
  name           = "budget-demo"
  amount         = 5
  contact_emails = ["owner@example.com"]
}

run "presupuesto_por_cuenta" {
  command = plan

  variables {
    linked_account_ids = ["111122223333"]
  }

  assert {
    condition     = length(aws_budgets_budget.this.notification) == 3
    error_message = "Por defecto debe haber 2 alertas reales y 1 pronosticada."
  }

  assert {
    condition     = aws_budgets_budget.this.limit_amount == "5.00"
    error_message = "El monto debe ir con dos decimales."
  }

  assert {
    condition     = tolist(one(aws_budgets_budget.this.cost_filter).values) == tolist(["111122223333"])
    error_message = "El presupuesto debe filtrar por la cuenta miembro."
  }
}

run "presupuesto_de_organizacion" {
  command = plan

  assert {
    condition     = length(aws_budgets_budget.this.cost_filter) == 0
    error_message = "Sin cuentas no debe haber filtro."
  }
}

run "cuenta_invalida" {
  command = plan

  variables {
    linked_account_ids = ["123"]
  }

  expect_failures = [var.linked_account_ids]
}
