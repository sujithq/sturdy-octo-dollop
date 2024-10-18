#!/bin/bash
echo "Fetching subscription details..."
azureSubscriptionId=$(az account show --query id --output tsv)
echo "##vso[task.setvariable variable=azureSubscriptionId]$azureSubscriptionId"
export azureSubscriptionId