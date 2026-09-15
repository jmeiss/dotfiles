#!/bin/bash
input=$(cat)
MODEL=$(printf '%s' "$input" | jq -r '.model.display_name')
EFFORT=$(printf '%s' "$input" | jq -r '.effort.level // empty')
[ -n "$EFFORT" ] && echo "$MODEL ($EFFORT)" || echo "$MODEL"
