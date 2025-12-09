#! /usr/bin/env bash
# check-commit-message
# Copyright (c) 2025 Adam Perkowski

set -eo pipefail

NAME='check-commit-message'

if [ "$#" -ne 1 ]; then
  echo "usage: $NAME <message>"
  exit 1
fi

if [ -z "$SCOPES" ]; then
  echo "SCOPES environment variable is not set. all scopes allowed."
fi

INPUT="$1"
ALLOWED_SCOPES="$SCOPES"

check_message() {
  local message="$1"
  local scope="${message%%:*}"
  local msg_full="${message#*: }"
  readarray -t msg <<<"$msg_full"

  if ((${#msg[0]} > 50)); then
    echo "header cannot exceed 50 characters"
    return 1
  fi

  if [[ -z "$msg_full" ]] || [[ "$msg_full" == "$message" ]]; then
    echo "message cannot be empty or same as scope"
    return 1
  fi

  if [[ "$msg_full" =~ ';' ]]; then
    echo "message cannot contain semicolons"
    return 1
  fi

  if [[ -n "$ALLOWED_SCOPES" ]] && [[ ! " ${ALLOWED_SCOPES[*]} " =~ ${scope} ]]; then
    echo "invalid scope:  ${scope}"
    echo "allowed scopes: ${ALLOWED_SCOPES[*]}"
    return 1
  fi

  if [[ ! "${msg[0]}" =~ ^[a-z] ]] || ! [[ "${msg: -1}" =~ [a-z0-9]$ ]]; then
    echo "message must start with a lowercase letter and end with a lowercase letter or number"
    return 1
  fi

  if [[ "${msg[1]}" != "" ]]; then
    echo "second line must be empty"
    return 1
  fi

  if [[ -z "${msg[2]}" ]]; then
    return 0
  fi

  for line in "${msg[@]:2}"; do
    if ((${#line} > 72)); then
      echo "body lines cannot exceed 72 characters"
      return 1
    fi
  done

  return 0
}

MESSAGES=()
while [[ "$INPUT" ]]; do
  if ! [[ "$INPUT" =~ '; ' ]]; then
    MESSAGES+=("$INPUT")
    break
  fi

  MESSAGES+=("${INPUT%%; *}")
  INPUT="${INPUT#*; }"
done

for message in "${MESSAGES[@]}"; do
  echo "checking '$message'"

  if ! check_message "$message"; then
    exit 1
  fi
done

echo "all good :3"
exit 0
