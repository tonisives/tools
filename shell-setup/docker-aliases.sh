#!/bin/bash

# Docker aliases and functions

# pods
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dcud='docker compose up -d'
alias dcp='docker compose ps'
alias dcr='docker compose restart'
alias dcs='docker compose start'
alias dck='docker compose kill'

dcu() {
  local file_flag=""
  local other_flags=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -f | --file)
      file_flag="-f$2"
      shift 2
      ;;
    *)
      other_flags+=("$1")
      shift
      ;;
    esac
  done

  docker compose $file_flag up "${other_flags[@]}"
}

dcd() {
  docker compose $@ down
}

dcl() {
  docker compose $@ logs -f
} 