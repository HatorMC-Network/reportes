#!/usr/bin/env bash
#
# Crea el MISMO set de labels en el repo de reportes y en todos los repos de plugins.
#
# Por qué importa: al transferir un issue, GitHub solo conserva los labels que
# existen con el mismo nombre en el repo destino. Si el set no es idéntico,
# perdés el etiquetado en cada transferencia.
#
# Requiere: gh CLI autenticado con permisos de escritura en todos los repos.
#   gh auth login
#
# Uso:
#   chmod +x labels.sh
#   ./labels.sh            # aplica
#   ./labels.sh --dry-run  # muestra qué haría, sin tocar nada

set -euo pipefail

# ─────────────────────────────────────────────────────────────
# EDITAR: tus repos. El primero es el inbox, el resto los plugins.
# ─────────────────────────────────────────────────────────────
REPOS=(
  "HatorMC/reportes"
  "HatorMC/lightly"
  # "HatorMC/otro-plugin"
  # "HatorMC/otro-plugin-mas"
)

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# ─────────────────────────────────────────────────────────────
# Labels: "nombre|color|descripción"
# ─────────────────────────────────────────────────────────────
LABELS=(
  # Estado del triage
  "triage|FBCA04|Recién entró, sin revisar"
  "diagnóstico|FEF2C0|En análisis, todavía no se sabe de qué es"
  "necesita-info|D4C5F9|Falta información del que reportó"
  "confirmado|0E8A16|Reproducido y confirmado"
  "duplicado|CFD3D7|Ya estaba reportado"

  # Área — qué tipo de problema es
  "área:sin-determinar|EEEEEE|Todavía sin clasificar"
  "área:plugin|1D76DB|Código de un plugin propio (se transfiere)"
  "área:config|5319E7|Archivo de configuración, balance o permisos"
  "área:mundo|B60205|Datos del mundo, regiones, spawns, NBT"
  "área:infra|0052CC|Proxy, red, base de datos, panel, rendimiento"
  "área:externo|BFD4F2|Bug de un plugin de terceros"
  "área:no-es-bug|CFD3D7|Comportamiento esperado"

  # Prioridad
  "prio:P0|B60205|Crítico — servidor caído, dupe, pérdida de datos"
  "prio:P1|D93F0B|Alto — feature core rota, sin workaround"
  "prio:P2|FBCA04|Medio — roto pero con workaround"
  "prio:P3|C2E0C6|Bajo — cosmético o molestia menor"

  # Servidor afectado (paleta HatorMC)
  "servidor:survival|0CFFCE|Afecta a Survival"
  "servidor:lobby|0CFFCE|Afecta al Lobby"
  "servidor:practice|0CFFCE|Afecta a Practice"
  "servidor:builder|0CFFCE|Afecta al Builder"
  "servidor:proxy|128C74|Afecta a Velocity / toda la red"

  # Tipo
  "tipo:bug|D73A4A|Algo no funciona"
  "tipo:crash|B60205|Cierra el servidor o el cliente"
  "tipo:rendimiento|D93F0B|Lag, TPS bajo, freeze"
  "tipo:ux|C5DEF5|Texto, mensajes, GUI, claridad"
)

echo "Repos: ${#REPOS[@]} · Labels: ${#LABELS[@]}"
$DRY_RUN && echo "MODO DRY-RUN — no se aplica nada"
echo

for repo in "${REPOS[@]}"; do
  echo "→ $repo"
  for entry in "${LABELS[@]}"; do
    IFS='|' read -r name color desc <<< "$entry"
    if $DRY_RUN; then
      printf '    %-28s #%s\n' "$name" "$color"
    else
      gh label create "$name" \
        --repo "$repo" \
        --color "$color" \
        --description "$desc" \
        --force >/dev/null
      printf '    ✓ %s\n' "$name"
    fi
  done
  echo
done

echo "Listo."
$DRY_RUN || cat <<'EOF'

Pendiente a mano (una sola vez, en CADA repo):

  Settings → Features → Issues → Creation allowed by: Collaborators only

Esto vale también para los repos de plugins PÚBLICOS: deja los issues
habilitados (necesario para recibir transferencias y para el autoclose)
pero impide que gente de afuera abra issues salteándose el inbox.
EOF
