# Presupuesto mensual con alertas por gasto real y pronosticado.
#
# Es un control detectivo: Azure no corta el gasto al llegar al tope, solo
# avisa. Las alertas pronosticadas dan margen para reaccionar antes del cierre.

locals {
  is_resource_group = can(regex("/resourceGroups/", var.scope_id))

  notifications = concat(
    [for t in var.actual_thresholds : { threshold = t, type = "Actual" }],
    [for t in var.forecast_thresholds : { threshold = t, type = "Forecasted" }],
  )

  start_date = coalesce(var.start_date, formatdate("YYYY-MM-01'T'00:00:00Z", plantimestamp()))
}

resource "azurerm_consumption_budget_subscription" "this" {
  count = local.is_resource_group ? 0 : 1

  name            = var.name
  subscription_id = var.scope_id
  amount          = var.amount
  time_grain      = "Monthly"

  time_period {
    start_date = local.start_date
  }

  dynamic "filter" {
    for_each = length(var.resource_group_filter) + length(var.tag_filter) > 0 ? [1] : []
    content {
      dynamic "dimension" {
        for_each = length(var.resource_group_filter) > 0 ? [1] : []
        content {
          name   = "ResourceGroupName"
          values = var.resource_group_filter
        }
      }

      dynamic "tag" {
        for_each = var.tag_filter
        content {
          name   = tag.key
          values = tag.value
        }
      }
    }
  }

  dynamic "notification" {
    for_each = local.notifications
    content {
      enabled        = true
      threshold      = notification.value.threshold
      threshold_type = notification.value.type
      operator       = "GreaterThan"
      contact_emails = var.contact_emails
    }
  }

  lifecycle {
    ignore_changes = [time_period]
  }
}

resource "azurerm_consumption_budget_resource_group" "this" {
  count = local.is_resource_group ? 1 : 0

  name              = var.name
  resource_group_id = var.scope_id
  amount            = var.amount
  time_grain        = "Monthly"

  time_period {
    start_date = local.start_date
  }

  dynamic "notification" {
    for_each = local.notifications
    content {
      enabled        = true
      threshold      = notification.value.threshold
      threshold_type = notification.value.type
      operator       = "GreaterThan"
      contact_emails = var.contact_emails
    }
  }

  lifecycle {
    ignore_changes = [time_period]
  }
}
