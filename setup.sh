#!/bin/bash

# ─────────────────────────────────────────────
#  BookStack Header Hacks — Module Installer
# ─────────────────────────────────────────────

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="$(pwd)"

# ── Colors & symbols ──────────────────────────
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
CYAN="\033[36m"
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
BG_CYAN="\033[46m\033[30m"

CHECK="[x]"
UNCHECK="[ ]"

# ── Module definitions ────────────────────────
MODULE_ORDER=(
  "header-anchor-link"
  "image-gallery"
  "LaTeX-support"
  "open-attachments"
  "pdf-embed"
  "pdf-export-clean"
  "preview-edit-page"
  "sort-tables-WYSIWYG"
  "sticky-table-heads"
  "toc-edit-mode"
  "url-edit-contrast"
  "wc-n-wpm-info"
  "global-hacks"
)

declare -A MODULE_DESC=(
  ["header-anchor-link"]="Clickable anchor links on page headers"
  ["image-gallery"]="Lightbox image gallery with Insert Gallery button"
  ["LaTeX-support"]="MathJax rendering for LaTeX equations"
  ["open-attachments"]="Open attachments in new tab instead of downloading"
  ["pdf-embed"]="Embed PDFs inline via pdf.js"
  ["pdf-export-clean"]="Hide revision/author metadata on PDF export"
  ["preview-edit-page"]="Preview button and quick-edit from preview"
  ["sort-tables-WYSIWYG"]="Double-click column header to sort tables"
  ["sticky-table-heads"]="Fix table headers while scrolling"
  ["toc-edit-mode"]="Table of contents in editor sidebar"
  ["url-edit-contrast"]="Better URL highlight visibility in dark mode"
  ["wc-n-wpm-info"]="Word count, char count and reading time per page"
  ["global-hacks"]="Miscellaneous global customizations"
)

MODULE_COUNT=${#MODULE_ORDER[@]}

# ── State ─────────────────────────────────────
declare -a SELECTED
for ((i = 0; i < MODULE_COUNT; i++)); do
  SELECTED[$i]=0
done
CURSOR=0

# ── Keys ──────────────────────────────────────
# Source: https://www.gnu.org/software/screen/manual/html_node/Input-Translation.html
KEY_UP=$'\033[A'
KEY_DOWN=$'\033[B'
KEY_UP_VIM='k'
KEY_DOWN_VIM='j'
KEY_TOGGLE=' '
KEY_SELECT_ALL='a'
KEY_DESELECT_ALL='n'
KEY_QUIT='q'
KEY_ENTER=''

# ── Terminal helpers ──────────────────────────
hide_cursor() { printf "\033[?25l"; }
show_cursor() { printf "\033[?25h"; }
clear_screen() { printf "\033[2J\033[H"; }

draw_menu() {
  clear_screen
  echo -e "${BOLD}${CYAN}  BookStack Header Hacks — Module Installer${RESET}"
  echo -e "${DIM}  Choose which modules to install.${RESET}"
  echo -e "${DIM}  Unselected modules and meta files (LICENSE, README.md, setup.sh) will be removed.${RESET}"
  echo ""
  echo -e "${DIM}  Installing to: ${DEST_DIR}${RESET}"
  echo ""
  echo -e "${DIM}  ↑↓/kj navigate   space toggle   a select all   n deselect all   enter install   q quit${RESET}"
  echo ""

  for ((i = 0; i < MODULE_COUNT; i++)); do
    local name="${MODULE_ORDER[$i]}"
    local desc="${MODULE_DESC[$name]}"
    local box

    if [ "${SELECTED[$i]}" -eq 1 ]; then
      box="${GREEN}${CHECK}${RESET}"
    else
      box="${DIM}${UNCHECK}${RESET}"
    fi

    if [ "$i" -eq "$CURSOR" ]; then
      echo -e "  ${box} ${BG_CYAN} ${name} ${RESET}  ${DIM}${desc}${RESET}"
    else
      if [ "${SELECTED[$i]}" -eq 1 ]; then
        echo -e "  ${box} ${GREEN}${name}${RESET}  ${DIM}${desc}${RESET}"
      else
        echo -e "  ${box} ${name}  ${DIM}${desc}${RESET}"
      fi
    fi
  done

  # Count selected
  local count=0
  for ((i = 0; i < MODULE_COUNT; i++)); do
    [ "${SELECTED[$i]}" -eq 1 ] && ((count++))
  done

  echo ""
  if [ "$count" -gt 0 ]; then
    echo -e "  ${GREEN}${BOLD}${count} module(s) selected${RESET}"
  else
    echo -e "  ${DIM}No modules selected${RESET}"
  fi
}

select_all() {
  for ((i = 0; i < MODULE_COUNT; i++)); do SELECTED[$i]=1; done
}

deselect_all() {
  for ((i = 0; i < MODULE_COUNT; i++)); do SELECTED[$i]=0; done
}

# ── Main loop ─────────────────────────────────
hide_cursor
trap 'show_cursor; clear_screen; echo -e "${YELLOW}Installation cancelled.${RESET}"; exit 0' INT TERM

draw_menu

while true; do
  IFS= read -rsn1 key

  if [[ "$key" == $'\033' ]]; then
    read -rsn2 -t 0.1 rest
    key="${key}${rest}"
  fi

  case "$key" in
    "$KEY_UP" | "$KEY_UP_VIM")
      ((CURSOR--))
      [ "$CURSOR" -lt 0 ] && CURSOR=$((MODULE_COUNT - 1))
      ;;
    "$KEY_DOWN" | "$KEY_DOWN_VIM")
      ((CURSOR++))
      [ "$CURSOR" -ge "$MODULE_COUNT" ] && CURSOR=0
      ;;
    "$KEY_TOGGLE")
      if [ "${SELECTED[$CURSOR]}" -eq 1 ]; then
        SELECTED[$CURSOR]=0
      else
        SELECTED[$CURSOR]=1
      fi
      ;;
    "$KEY_SELECT_ALL")
      select_all
      ;;
    "$KEY_DESELECT_ALL")
      deselect_all
      ;;
    "$KEY_QUIT")
      show_cursor
      clear_screen
      echo -e "${YELLOW}Installation cancelled.${RESET}"
      exit 0
      ;;
    "$KEY_ENTER")
      break
      ;;
  esac

  draw_menu
done

show_cursor
clear_screen

# ── Install ───────────────────────────────────

INSTALLED=()
FAILED=()
NOTHING=1

echo ""
echo -e "${BOLD}${CYAN}Installing${RESET}"

for ((i = 0; i < MODULE_COUNT; i++)); do
  if [ "${SELECTED[$i]}" -eq 1 ]; then
    NOTHING=0
    module="${MODULE_ORDER[$i]}"
    SRC="$REPO_DIR/$module"
    if [ -d "$SRC" ]; then
      echo -e "  ${DIM} $module...${RESET}"
      cp -r "$SRC" "$DEST_DIR/"
      INSTALLED+=("$module")
    else
      FAILED+=("$module")
    fi
  fi
done

# ── Cleanup Confirmation ──
echo ""
echo -e "${BOLD}${RED}Cleanup Confirmation${RESET}"
echo -e "${DIM}The following will be removed from the destination directory:${RESET}"
echo -e "${DIM}  - Unselected modules${RESET}"
echo -e "${DIM}  - Meta files: LICENSE, README.md, setup.sh${RESET}"
echo ""
read -r -p "Do you want to proceed with cleanup? [y/N] " confirm

case "$confirm" in
  [yY][eE][sS]|[yY])
    # ── Perform Cleanup ──
    for ((i = 0; i < MODULE_COUNT; i++)); do
      module="${MODULE_ORDER[$i]}"
      if [ "${SELECTED[$i]}" -eq 0 ]; then
        if [ -d "$DEST_DIR/$module" ]; then
          rm -rf "$DEST_DIR/$module"
        fi
      fi
    done

    # Remove meta files
    for f in LICENSE README.md setup.sh; do
      if [ -f "$DEST_DIR/$f" ]; then
        rm -f "$DEST_DIR/$f"
      fi
    done
    ;;
  *)
    echo -e "${YELLOW}Cleanup cancelled. No files were removed.${RESET}"
    ;;
esac

# ── Summary ────────────────────────────────────
if [ "$NOTHING" -eq 1 ]; then
  echo -e "${YELLOW}No modules selected. Nothing was installed.${RESET}"
  exit 0
fi

echo -e "${BOLD}${CYAN}Installation summary${RESET}"
echo ""

if [ ${#INSTALLED[@]} -gt 0 ]; then
  echo -e "${GREEN}${BOLD}Installed:${RESET}"
  for m in "${INSTALLED[@]}"; do
    echo -e "  ${GREEN}✓${RESET} $m"
  done
fi

if [ ${#FAILED[@]} -gt 0 ]; then
  echo ""
  echo -e "${RED}${BOLD}Failed (source folder not found):${RESET}"
  for m in "${FAILED[@]}"; do
    echo -e "  ${RED}✗${RESET} $m"
  done
fi

echo ""
echo -e "${DIM}Installed to: ${DEST_DIR}${RESET}"