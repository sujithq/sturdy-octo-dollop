#!/bin/bash

echo "Entering build.sh"

azureSubscriptionId=$1
repoPath=$2
environment=${3,,}
template_file_name=$4
vars_file_name=$5


if [ -z "$azureSubscriptionId" ]; then
  echo "No subscription Id specified."
  exit 1
fi

if [ -z "$repoPath" ]; then
  echo "No repo path specified."
  exit 1
fi

if [ -z "$environment" ]; then
  echo "No environment specified."
  exit 1
fi

if [ -z "$template_file_name" ]; then
  echo "No template specified."
  exit 1
fi
if [ -z "$vars_file_name" ]; then
  echo "No vars specified."
  exit 1
fi

template_file_path="$repoPath/pkr/$template_file_name"
echo "template_file_path: $template_file_path"

vars_file_path="$repoPath/pkr/parameters/$environment/$vars_file_name"
echo "vars_file_path: $vars_file_path"

echo "Run Packer Validate"

packer validate \
  -var "az_sub_id=$azureSubscriptionId" \
  -var-file "$vars_file_path" \
  $template_file_path

echo "Run Packer Build"

packer build \
    -force \
    -var "az_sub_id=$azureSubscriptionId" \
    -var-file "$vars_file_path" \
    $template_file_path