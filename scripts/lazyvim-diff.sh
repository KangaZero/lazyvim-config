#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)"

UPSTREAM_URL="https://github.com/LazyVim/LazyVim.git"
UPSTREAM_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/lazyvim-upstream"
UPSTREAM_REF="main"
UPSTREAM_DIR="${LAZYVIM_UPSTREAM_DIR:-}"
MODE="diff"

usage() {
  cat <<'EOF'
Usage:
  scripts/lazyvim-diff.sh [--list] [--ref <ref>] [--repo <path>] [file ...]

What it does:
  - maps local files in this repo back to their original LazyVim distro file
  - fetches the upstream LazyVim repo (or uses a local clone)
  - prints git diffs between upstream and local files

Options:
  --list         Print local -> upstream mappings instead of diffs
  --ref <ref>    Compare against a specific upstream ref (default: main)
  --repo <path>  Use an existing local LazyVim git checkout instead of fetching
  --help         Show this help

Examples:
  scripts/lazyvim-diff.sh
  scripts/lazyvim-diff.sh lua/plugins/core/treesitter.lua
  scripts/lazyvim-diff.sh lua/config/options.lua
  LAZYVIM_UPSTREAM_DIR="$HOME/.local/share/nvim/lazy/LazyVim" scripts/lazyvim-diff.sh --list
EOF
}

ensure_upstream_repo() {
  if [ -n "$UPSTREAM_DIR" ]; then
    printf '%s\n' "$UPSTREAM_DIR"
    return 0
  fi

  mkdir -p "$(dirname "$UPSTREAM_CACHE")"

  if [ ! -d "$UPSTREAM_CACHE/.git" ]; then
    git clone --filter=blob:none "$UPSTREAM_URL" "$UPSTREAM_CACHE" >/dev/null
  fi

  git -C "$UPSTREAM_CACHE" fetch --quiet origin
  git -C "$UPSTREAM_CACHE" checkout --quiet "$UPSTREAM_REF"

  printf '%s\n' "$UPSTREAM_CACHE"
}

normalize_path() {
  local path="$1"
  path="${path#"$REPO_ROOT"/}"
  path="${path#./}"
  printf '%s\n' "$path"
}

unique_upstream_plugin_match() {
  local rel="$1"
  local upstream_root="$2"
  local base
  local count=0
  local last=""

  base="$(basename "$rel")"

  while IFS= read -r match; do
    [ -n "$match" ] || continue
    count=$((count + 1))
    last="$match"
  done < <(cd "$upstream_root" && find lua/lazyvim/plugins -type f -name "$base" | sort)

  if [ "$count" -eq 1 ]; then
    printf '%s\n' "$last"
    return 0
  fi

  return 1
}

map_to_upstream() {
  local rel="$1"
  local upstream_root="$2"

  case "$rel" in
  lua/config/init.lua) printf 'lua/lazyvim/config/init.lua\n' ;;
  lua/config/options.lua) printf 'lua/lazyvim/config/options.lua\n' ;;
  lua/config/keymaps.lua) printf 'lua/lazyvim/config/keymaps.lua\n' ;;
  lua/config/autocmds.lua) printf 'lua/lazyvim/config/autocmds.lua\n' ;;
  lua/config/health.lua) printf 'lua/lazyvim/health.lua\n' ;;
  lua/config/types.lua) printf 'lua/lazyvim/types.lua\n' ;;
  lua/config/util/*) printf 'lua/lazyvim/util/%s\n' "${rel#lua/config/util/}" ;;
  lua/plugins/core/*) printf 'lua/lazyvim/plugins/%s\n' "${rel#lua/plugins/core/}" ;;
  lua/plugins/nvim-lspconfig.lua) printf 'lua/lazyvim/plugins/lsp/init.lua\n' ;;
  lua/plugins/blink-cmp.lua) printf 'lua/lazyvim/plugins/extras/coding/blink.lua\n' ;;
  lua/plugins/mini-snippets.lua) printf 'lua/lazyvim/plugins/extras/coding/mini-snippets.lua\n' ;;
  lua/plugins/dashboard-nvim.lua) printf 'lua/lazyvim/plugins/extras/ui/dashboard-nvim.lua\n' ;;
  lua/plugins/mini-animate.lua) printf 'lua/lazyvim/plugins/extras/ui/mini-animate.lua\n' ;;
  lua/plugins/mini-indentscope.lua) printf 'lua/lazyvim/plugins/extras/ui/mini-indentscope.lua\n' ;;
  lua/plugins/smear-cursor.lua) printf 'lua/lazyvim/plugins/extras/ui/smear-cursor.lua\n' ;;
  lua/plugins/overseer.lua) printf 'lua/lazyvim/plugins/extras/editor/overseer.lua\n' ;;
  lua/plugins/typescript.lua) printf 'lua/lazyvim/plugins/extras/lang/typescript.lua\n' ;;
  lua/plugins/colorscheme.lua) printf 'lua/lazyvim/plugins/colorscheme.lua\n' ;;
  lua/plugins/xtras.lua) printf 'lua/lazyvim/plugins/xtras.lua\n' ;;
  lua/plugins/*.lua)
    unique_upstream_plugin_match "$rel" "$upstream_root" || return 1
    ;;
  *)
    return 1
    ;;
  esac
}

default_local_files() {
  {
    printf '%s\n' \
      lua/config/init.lua \
      lua/config/options.lua \
      lua/config/keymaps.lua \
      lua/config/autocmds.lua \
      lua/config/health.lua \
      lua/config/types.lua

    find "$REPO_ROOT/lua/config/util" -type f -name '*.lua' | sed "s#^$REPO_ROOT/##" | sort
    find "$REPO_ROOT/lua/plugins/core" -type f -name '*.lua' | sed "s#^$REPO_ROOT/##" | sort
    find "$REPO_ROOT/lua/plugins" -maxdepth 1 -type f -name '*.lua' | sed "s#^$REPO_ROOT/##" | sort
  } | awk '!seen[$0]++'
}

print_mapping() {
  local rel="$1"
  local upstream_rel="$2"
  printf '%s -> %s\n' "$rel" "$upstream_rel"
}

print_diff() {
  local rel="$1"
  local upstream_rel="$2"
  local upstream_root="$3"

  local local_file="$REPO_ROOT/$rel"
  local upstream_file="$upstream_root/$upstream_rel"

  if [ ! -f "$local_file" ]; then
    printf 'Skipping missing local file: %s\n' "$rel" >&2
    return 0
  fi

  if [ ! -f "$upstream_file" ]; then
    printf 'Skipping missing upstream file: %s\n' "$upstream_rel" >&2
    return 0
  fi

  if git --no-pager diff --quiet --no-index -- "$upstream_file" "$local_file"; then
    return 0
  fi

  printf '\n===== %s =====\n' "$rel"
  printf 'upstream: %s\n\n' "$upstream_rel"
  git --no-pager diff --no-index -- "$upstream_file" "$local_file" || true
}

ARGS=()

while [ "$#" -gt 0 ]; do
  case "$1" in
  --list)
    MODE="list"
    shift
    ;;
  --ref)
    UPSTREAM_REF="${2:-}"
    shift 2
    ;;
  --repo)
    UPSTREAM_DIR="${2:-}"
    shift 2
    ;;
  --help | -h)
    usage
    exit 0
    ;;
  *)
    ARGS+=("$1")
    shift
    ;;
  esac
done

UPSTREAM_ROOT="$(ensure_upstream_repo)"

if [ "${#ARGS[@]}" -eq 0 ]; then
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    if upstream_rel="$(map_to_upstream "$rel" "$UPSTREAM_ROOT")"; then
      if [ "$MODE" = "list" ]; then
        print_mapping "$rel" "$upstream_rel"
      else
        print_diff "$rel" "$upstream_rel" "$UPSTREAM_ROOT"
      fi
    fi
  done < <(default_local_files)
else
  for arg in "${ARGS[@]}"; do
    rel="$(normalize_path "$arg")"
    if ! upstream_rel="$(map_to_upstream "$rel" "$UPSTREAM_ROOT")"; then
      printf 'No upstream LazyVim mapping for: %s\n' "$rel" >&2
      continue
    fi

    if [ "$MODE" = "list" ]; then
      print_mapping "$rel" "$upstream_rel"
    else
      print_diff "$rel" "$upstream_rel" "$UPSTREAM_ROOT"
    fi
  done
fi
