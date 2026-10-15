# Presupuesto mensual de costo con alertas reales y pronosticadas. Se crea en la
# cuenta de administración y filtra por cuenta miembro: así la cuenta del
# proyecto no necesita permisos ni recursos propios para tener su alerta.

locals {
  notifications = concat(
    [for t in var.actual_thresholds : { type = "ACTUAL", threshold = t }],
    [for t in var.forecast_thresholds : { type = "FORECASTED", threshold = t }],
  )
}

resource "aws_budgets_budget" "this" {
  name         = var.name
  budget_type  = "COST"
  limit_amount = format("%.2f", var.amount)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"
  tags         = var.tags

  dynamic "cost_filter" {
    for_each = length(var.linked_account_ids) > 0 ? [1] : []
    content {
      name   = "LinkedAccount"
      values = var.linked_account_ids
    }
  }

  dynamic "notification" {
    for_each = local.notifications
    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value.threshold
      threshold_type             = "PERCENTAGE"
      notification_type          = notification.value.type
      subscriber_email_addresses = var.contact_emails
    }
  }
}
