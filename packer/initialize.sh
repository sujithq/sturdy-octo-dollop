#!/bin/bash
TEMPLATE_FILE=$1

if [ -z "$TEMPLATE_FILE" ]; then
  echo "No template file specified."
  exit 1
fi

echo "Initialize Packer (install plugins) $TEMPLATE_FILE"
packer init $TEMPLATE_FILE
