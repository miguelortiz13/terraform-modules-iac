mock_provider "aws" {}

variables {
  target_ids = {
    workloads = "ou-ab12-cd34ef56"
    sandbox   = "ou-ab12-gh78ij90"
  }
}

run "linea_base_completa" {
  command = plan

  assert {
    condition     = length(aws_organizations_policy.this) == 4
    error_message = "Por defecto deben crearse 4 SCP."
  }

  assert {
    condition     = length(aws_organizations_policy_attachment.this) == 8
    error_message = "Cada SCP debe adjuntarse a cada destino (4 x 2)."
  }

  assert {
    condition     = alltrue([for p in aws_organizations_policy.this : length(p.content) <= 5120])
    error_message = "Ninguna SCP puede superar 5120 caracteres."
  }

  assert {
    condition     = contains(jsondecode(aws_organizations_policy.this["servicios-caros"].content).Statement[0].Action, "guardduty:CreateDetector")
    error_message = "La SCP de servicios caros debe bloquear GuardDuty."
  }

  assert {
    condition     = jsondecode(aws_organizations_policy.this["regiones"].content).Statement[0].Condition.StringNotEquals["aws:RequestedRegion"] == ["us-east-1"]
    error_message = "La región permitida por defecto debe ser us-east-1."
  }
}

run "sin_restricciones_opcionales" {
  command = plan

  variables {
    allowed_regions              = []
    denied_actions               = []
    allowed_ec2_instance_types   = []
    allowed_rds_instance_classes = []
    deny_root_user               = false
    deny_leave_organization      = false
  }

  assert {
    condition     = length(aws_organizations_policy.this) == 0
    error_message = "Sin reglas no debe crearse ninguna SCP."
  }
}

run "destino_invalido" {
  command = plan

  variables {
    target_ids = { workloads = "Workloads" }
  }

  expect_failures = [var.target_ids]
}
