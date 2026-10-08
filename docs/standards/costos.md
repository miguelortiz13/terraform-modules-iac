# Costos y capa gratuita

Objetivo: cada proyecto cuesta USD 0 mientras sea un portafolio o una demo, y
se puede escalar cambiando variables, no reescribiendo la infraestructura.

## Cupos gratis que usan los módulos

| Servicio | Cupo | Alcance |
|---|---|---|
| Container Apps (consumo) | 180.000 vCPU-s, 360.000 GiB-s y 2 M solicitudes al mes | **por suscripción** |
| Azure SQL Database (oferta gratuita) | 100.000 vCore-s y 32 GB por base al mes, hasta 10 bases | **por suscripción** |
| Static Web Apps Free | 100 GB de transferencia al mes | por app |
| Log Analytics | 5 GB de ingesta al mes | por cuenta de facturación |
| Azure Functions Flex | 100.000 GB-s y 250.000 ejecuciones al mes | por suscripción |
| GHCR | Ilimitado para paquetes públicos | GitHub |

Por eso **cada proyecto vive en su propia suscripción**: no compite por los
cupos con los demás.

## Equivalencias útiles

- Container App de 0.5 vCPU / 1 GiB: el cupo cubre ~100 horas activas al mes.
  Después cuesta ~USD 0,054 por hora activa.
- Una réplica mínima siempre encendida (`min_replicas = 1`) consume el cupo en
  ~4 días a 0.5 vCPU; a 0.25 vCPU / 0.5 GiB queda en ~USD 4-14/mes según cuánto
  tiempo esté activa.
- Azure SQL gratis: la base se pausa tras 60 minutos sin conexiones. Cada
  despertar consume al menos ~1.800 vCore-s (≈ 55 despertares al mes).

## Qué evitar

| Recurso | Costo aproximado | Alternativa |
|---|---|---|
| ACR Basic | USD 5/mes | GHCR |
| Entorno de Container Apps con workload profiles | ~USD 73/mes de gestión | Entorno solo de consumo |
| Private endpoints | ~USD 7/mes cada uno | Entra ID + RBAC + TLS |
| MySQL/PostgreSQL Flexible B1ms | ~USD 15/mes | Azure SQL gratis, o un proveedor externo gratuito |
| NAT Gateway, Application Gateway, Firewall, Bastion | USD 30-900/mes | No usar sin justificación; bloqueados por política |
| Defender for Cloud (planes de pago) | variable | Solo planes gratuitos (Foundational CSPM) |

La línea base de Azure Policy (`policy-baseline`) bloquea los tipos de
recurso más caros y los tamaños de VM grandes.
