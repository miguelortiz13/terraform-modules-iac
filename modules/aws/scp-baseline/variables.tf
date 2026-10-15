variable "name_prefix" {
  description = "Prefijo de los nombres de las SCP."
  type        = string
  default     = "baseline"
}

variable "target_ids" {
  description = "OU, cuentas o raíz donde se adjuntan las SCP, con claves estables (p. ej. `{ workloads = \"ou-...\" }`). Las SCP no afectan a la cuenta de administración."
  type        = map(string)

  validation {
    condition     = alltrue([for id in values(var.target_ids) : can(regex("^(r-[0-9a-z]{4,32}|ou-[0-9a-z]{4,32}-[a-z0-9]{8,32}|[0-9]{12})$", id))])
    error_message = "Cada destino debe ser una OU (ou-...), la raíz (r-...) o una cuenta (12 dígitos)."
  }
}

variable "deny_leave_organization" {
  description = "Impide que una cuenta salga de la organización (y de sus SCP)."
  type        = bool
  default     = true
}

variable "deny_root_user" {
  description = "Bloquea al usuario raíz de las cuentas miembro; se entra con IAM Identity Center."
  type        = bool
  default     = true
}

variable "allowed_regions" {
  description = "Regiones permitidas. Los servicios globales (IAM, Organizations, facturación, CloudFront, Route 53...) quedan exentos. Lista vacía = sin restricción."
  type        = list(string)
  default     = ["us-east-1"]
}

variable "denied_actions" {
  description = "Acciones prohibidas por costo: servicios de seguridad de pago, compromisos de compra y recursos con costo fijo alto. Lista vacía = sin esta SCP."
  type        = list(string)
  default = [
    # Servicios de seguridad que cobran tras la prueba
    "guardduty:CreateDetector",
    "securityhub:EnableSecurityHub",
    "config:PutConfigurationRecorder",
    "config:StartConfigurationRecorder",
    "macie2:EnableMacie",
    "inspector2:Enable",
    "detective:CreateGraph",
    "shield:CreateSubscription",
    # Compromisos de compra
    "ec2:PurchaseReservedInstancesOffering",
    "ec2:PurchaseHostReservation",
    "ec2:AllocateHosts",
    "rds:PurchaseReservedDBInstancesOffering",
    "savingsplans:CreateSavingsPlan",
    "aws-marketplace:Subscribe",
    "route53domains:RegisterDomain",
    "route53domains:TransferDomain",
    # Costo fijo alto aunque no se use
    "ec2:CreateNatGateway",
    "eks:CreateCluster",
  ]
}

variable "allowed_ec2_instance_types" {
  description = "Tipos de instancia EC2 permitidos. Lista vacía = sin restricción."
  type        = list(string)
  default     = ["t3.micro", "t3.small", "t4g.micro", "t4g.small"]
}

variable "allowed_rds_instance_classes" {
  description = "Clases de instancia RDS permitidas. Lista vacía = sin restricción."
  type        = list(string)
  default     = ["db.t3.micro", "db.t4g.micro"]
}

variable "tags" {
  description = "Etiquetas de las políticas."
  type        = map(string)
  default     = {}
}
