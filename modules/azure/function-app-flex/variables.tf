variable "name" {
  description = "Nombre de la Function App (global; usa `module.naming.names.function_app`)."
  type        = string
}

variable "service_plan_name" {
  description = "Nombre del plan FC1 (usa `module.naming.names.service_plan`)."
  type        = string
}

variable "resource_group_name" {
  description = "Grupo de recursos."
  type        = string
}

variable "location" {
  description = "Región con Flex Consumption disponible."
  type        = string
}

variable "tags" {
  description = "Etiquetas."
  type        = map(string)
}

variable "storage_account_id" {
  description = "ID de la cuenta donde se guarda el paquete de despliegue."
  type        = string
}

variable "storage_blob_endpoint" {
  description = "Endpoint de blobs de esa cuenta (`https://<cuenta>.blob.core.windows.net/`)."
  type        = string
}

variable "runtime_name" {
  description = "Runtime: `node`, `python`, `dotnet-isolated`, `java` o `powershell`."
  type        = string

  validation {
    condition     = contains(["node", "python", "dotnet-isolated", "java", "powershell"], var.runtime_name)
    error_message = "runtime_name no soportado por Flex Consumption."
  }
}

variable "runtime_version" {
  description = "Versión del runtime (p. ej. `22` para node, `3.12` para python)."
  type        = string
}

variable "instance_memory_in_mb" {
  description = "Memoria por instancia: 512, 2048 o 4096."
  type        = number
  default     = 2048

  validation {
    condition     = contains([512, 2048, 4096], var.instance_memory_in_mb)
    error_message = "instance_memory_in_mb debe ser 512, 2048 o 4096."
  }
}

variable "maximum_instance_count" {
  description = "Tope de instancias: limita el costo ante picos o abusos."
  type        = number
  default     = 10
}

variable "app_settings" {
  description = "Configuración de la app. No incluyas `AzureWebJobsStorage`: Flex lo gestiona."
  type        = map(string)
  default     = {}
}

variable "application_insights_connection_string" {
  description = "Cadena de conexión de Application Insights (opcional)."
  type        = string
  default     = null
  sensitive   = true
}

variable "cors_allowed_origins" {
  description = "Orígenes CORS permitidos."
  type        = list(string)
  default     = []
}

variable "identity_ids" {
  description = "Identidades adicionales para la app (p. ej. para leer Key Vault)."
  type        = list(string)
  default     = []
}
