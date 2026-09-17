# Guía de triage (interna)

No es para el staff. Es el procedimiento tuyo y de Koyere.

## El flujo

```
Issue nuevo en HatorMC/reportes  →  label: triage + área:sin-determinar
   │
   ├─ 1. ¿Es reproducible?
   │     NO  → label: necesita-info, pedir lo que falta, cerrar a los 15 días sin respuesta
   │     SÍ  → sigue
   │
   ├─ 2. ¿Es un bug real o comportamiento esperado?
   │     Esperado → área:no-es-bug, cerrar explicando (no cerrar en silencio)
   │
   ├─ 3. Poner prioridad (P0..P3) y área
   │
   └─ 4. ¿De qué es?
         ├─ Plugin propio con repo     → TRANSFERIR al repo del plugin
         ├─ Config / mundo / infra     → se queda acá, se resuelve acá
         └─ Plugin de terceros         → se queda acá como tracking + reporte upstream
```

## Prioridades

Las ponés vos, nunca el staff.

| Prio | Criterio | Tiempo objetivo |
|---|---|---|
| `prio:P0` | Servidor caído, crash provocable, dupe, pérdida de datos, exploit de economía | Ya |
| `prio:P1` | Una feature core rota para todos los jugadores, sin workaround | Esta semana |
| `prio:P2` | Roto pero con workaround, o afecta a pocos jugadores | Este mes |
| `prio:P3` | Cosmético, texto mal, molestia menor | Cuando haya tiempo |

Regla práctica: si no sabés si es P1 o P2, es P2. Si todo es P1, nada es P1.

## Áreas

| Label | Cuándo |
|---|---|
| `área:sin-determinar` | Lo pone el formulario. Sale de acá apenas lo diagnosticás. |
| `área:plugin` | Es código nuestro. **Se transfiere.** |
| `área:config` | Un `.yml` mal puesto, balance, permisos de Helium. Se queda. |
| `área:mundo` | Datos del mundo, regiones, spawns, NBT. Se queda. |
| `área:infra` | Velocity, proxy, Mongo, Redis, red, lag, Pterodactyl. Se queda. |
| `área:externo` | Bug de un plugin de terceros. Se queda como tracking + se reporta upstream. |
| `área:no-es-bug` | Comportamiento esperado. Se cierra explicando. |

## Antes de transferir un issue

1. **Dejá un comentario con el diagnóstico.** Si el repo destino es privado, el que reportó pierde el acceso al hilo. El comentario es lo último que lee.
2. Verificá que el label que querés conservar **exista con el mismo nombre en el repo destino**. Si no existe, se pierde en la transferencia. Por eso el set de labels se mantiene idéntico en todos los repos (ver `labels.sh`).
3. El número del issue cambia. La URL vieja redirige, pero si alguien citó "#47" en Discord, deja de coincidir.
4. Los milestones solo se conservan si coinciden en nombre **y** fecha de vencimiento.

Transferir: botón en la barra lateral derecha del issue → *Transfer issue*. O por CLI:

```bash
gh issue transfer <numero> HatorMC/<repo-destino>
```

## Cerrar automáticamente

Una vez transferido, el issue vive en el repo del plugin y el autoclose nativo funciona:

```
git commit -m "Arregla el chequeo de distancia en pushPlayerOut

Fixes #123"
```

También sirve poniendo `Fixes #123` en la descripción del PR: se cierra solo al mergear.

Desde otro repositorio se puede usar `Fixes HatorMC/lightly#123`, pero depende de que quien mergea tenga permisos en ambos repos. Preferí transferir antes que depender de eso.

## Higiene

- **Duplicados:** cerrar el nuevo con un comentario que linkee al original (`Duplicado de #12`), nunca cerrarlo pelado.
- **`necesita-info` sin respuesta:** cerrar a los 15 días. Es el único caso donde se cierra por inactividad — el backlog viejo pero válido no se toca.
- **Repo público:** si alguien pega una IP, credenciales o un exploit, editá el comentario **y** el historial de edición no alcanza: considerá el dato comprometido y rotalo.
