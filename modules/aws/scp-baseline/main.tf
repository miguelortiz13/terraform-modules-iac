# SCP de base para las cuentas de proyecto: el equivalente en AWS de
# azure/policy-baseline, pero en modo bloqueo (las SCP no tienen modo auditoría).
# Cada SCP admite como máximo 5120 caracteres y cada destino 5 SCP (incluida
# FullAWSAccess), por eso son 4 políticas y no una por regla.

locals {
  # Servicios globales o que solo operan en us-east-1: quedan fuera del bloqueo
  # de regiones (lista basada en el ejemplo de la documentación de AWS).
  global_actions = [
    "account:*", "acm:*", "aws-marketplace:*", "aws-portal:*", "billing:*",
    "budgets:*", "ce:*", "cloudfront:*", "cur:*", "directconnect:*",
    "ec2:DescribeRegions", "freetier:*", "globalaccelerator:*", "health:*",
    "iam:*", "identitystore:*", "invoicing:*", "kms:*", "networkmanager:*",
    "organizations:*", "payments:*", "pricing:*", "route53:*", "route53domains:*",
    "s3:GetAccountPublic*", "s3:ListAllMyBuckets", "s3:PutAccountPublic*",
    "shield:*", "sso:*", "sts:*", "support:*", "tax:*", "trustedadvisor:*",
    "waf:*", "wafv2:*", "wellarchitected:*",
  ]

  org_statements = concat(
    var.deny_leave_organization ? [{
      Sid      = "NoSalirDeLaOrganizacion"
      Effect   = "Deny"
      Action   = ["organizations:LeaveOrganization"]
      Resource = "*"
    }] : [],
    var.deny_root_user ? [{
      Sid       = "SinUsuarioRaiz"
      Effect    = "Deny"
      Action    = "*"
      Resource  = "*"
      Condition = { ArnLike = { "aws:PrincipalArn" = ["arn:aws:iam::*:root"] } }
    }] : [],
  )

  size_statements = concat(
    length(var.allowed_ec2_instance_types) > 0 ? [{
      Sid       = "SoloInstanciasEC2Pequenas"
      Effect    = "Deny"
      Action    = ["ec2:RunInstances"]
      Resource  = "arn:aws:ec2:*:*:instance/*"
      Condition = { StringNotEquals = { "ec2:InstanceType" = var.allowed_ec2_instance_types } }
    }] : [],
    length(var.allowed_rds_instance_classes) > 0 ? [{
      Sid       = "SoloClasesRDSPequenas"
      Effect    = "Deny"
      Action    = ["rds:CreateDBInstance", "rds:ModifyDBInstance"]
      Resource  = "*"
      Condition = { StringNotEquals = { "rds:DatabaseClass" = var.allowed_rds_instance_classes } }
    }] : [],
  )

  candidate_policies = {
    proteccion-org = {
      description = "Impide salir de la organización y usar el usuario raíz."
      statements  = local.org_statements
    }
    regiones = {
      description = "Solo regiones permitidas: ${join(", ", var.allowed_regions)}."
      statements = length(var.allowed_regions) > 0 ? [{
        Sid       = "SoloRegionesPermitidas"
        Effect    = "Deny"
        NotAction = local.global_actions
        Resource  = "*"
        Condition = { StringNotEquals = { "aws:RequestedRegion" = var.allowed_regions } }
      }] : []
    }
    servicios-caros = {
      description = "Bloquea servicios de pago, compromisos de compra y recursos con costo fijo alto."
      statements = length(var.denied_actions) > 0 ? [{
        Sid      = "SinServiciosCaros"
        Effect   = "Deny"
        Action   = var.denied_actions
        Resource = "*"
      }] : []
    }
    tamanos = {
      description = "Limita EC2 y RDS a tamaños de la capa gratuita o cercanos."
      statements  = local.size_statements
    }
  }

  policies = {
    for k, p in local.candidate_policies : k => p if length(p.statements) > 0
  }

  attachments = {
    for pair in setproduct(keys(local.policies), keys(var.target_ids)) :
    "${pair[0]}/${pair[1]}" => { policy = pair[0], target = pair[1] }
  }
}

resource "aws_organizations_policy" "this" {
  for_each = local.policies

  name        = "${var.name_prefix}-${each.key}"
  description = each.value.description
  type        = "SERVICE_CONTROL_POLICY"
  content     = jsonencode({ Version = "2012-10-17", Statement = each.value.statements })
  tags        = var.tags

  lifecycle {
    precondition {
      condition     = length(jsonencode({ Version = "2012-10-17", Statement = each.value.statements })) <= 5120
      error_message = "La SCP ${each.key} supera los 5120 caracteres que admite AWS."
    }
  }
}

resource "aws_organizations_policy_attachment" "this" {
  for_each = local.attachments

  policy_id = aws_organizations_policy.this[each.value.policy].id
  target_id = var.target_ids[each.value.target]
}
