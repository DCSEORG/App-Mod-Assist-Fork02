#!/bin/bash

# Azure Deployment Script for Expense Management System
# This script deploys the complete application to Azure

set -e  # Exit on error

echo "=== Azure Expense Management System Deployment ==="
echo ""

# Variables
RESOURCE_GROUP="expense-mgmt-rg"
LOCATION="uksouth"
TEMPLATE_FILE="./infra/app-service.bicep"
ZIP_FILE="./app.zip"

# Check if user is logged in to Azure
echo "Checking Azure login status..."
az account show > /dev/null 2>&1 || { echo "Please login to Azure using 'az login'"; exit 1; }

echo "Azure login confirmed."
echo ""

# Create Resource Group
echo "Creating resource group: $RESOURCE_GROUP in $LOCATION..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION \
  --output table

echo ""

# Deploy Infrastructure (App Service)
echo "Deploying App Service infrastructure using Bicep..."
DEPLOYMENT_OUTPUT=$(az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --template-file $TEMPLATE_FILE \
  --query 'properties.outputs' \
  --output json)

APP_SERVICE_NAME=$(echo $DEPLOYMENT_OUTPUT | jq -r '.appServiceName.value')
APP_SERVICE_URL=$(echo $DEPLOYMENT_OUTPUT | jq -r '.appServiceUrl.value')

echo "App Service deployed: $APP_SERVICE_NAME"
echo "URL: $APP_SERVICE_URL"
echo ""

# Deploy Application Code
echo "Deploying application code from $ZIP_FILE..."
az webapp deploy \
  --resource-group $RESOURCE_GROUP \
  --name $APP_SERVICE_NAME \
  --src-path $ZIP_FILE \
  --type zip \
  --async false

echo ""
echo "=== Deployment Complete ==="
echo ""
echo "Application URL: $APP_SERVICE_URL"
echo "Resource Group: $RESOURCE_GROUP"
echo ""
echo "To view your application, visit: $APP_SERVICE_URL"
echo "To delete all resources, run: az group delete --name $RESOURCE_GROUP --yes"
