# Expense Management System - Azure Deployment

This is a modernized cloud-native version of a legacy Expense Management System, deployed to Azure using ASP.NET Core and Azure App Service.

## Application Overview

The Expense Management System provides three main features:

1. **Add Expense** - Submit new expense claims with amount, date, category, and description
2. **Expenses** - View all submitted expenses with filtering capability
3. **Approve Expenses** - Review and approve pending expense claims

![Legacy Application](https://github.com/user-attachments/assets/d4b92457-cdda-47c0-aa63-ccdbcc41848c)

## Architecture

- **Frontend**: ASP.NET Core 8.0 Razor Pages
- **Infrastructure**: Azure App Service (Linux)
- **IaC**: Azure Bicep
- **Deployment**: Azure CLI

## Prerequisites

- Azure CLI installed and configured
- .NET 8.0 SDK (for local development)
- Active Azure subscription

## Quick Deployment

This application follows Azure best practices for quick POC deployment using local Azure CLI:

### One-Line Deployment

```bash
./deploy.sh
```

This script will:
1. Create a resource group in UK South
2. Deploy the App Service infrastructure using Bicep
3. Deploy the application code as a zip file

### Manual Deployment Steps

If you prefer to run steps manually:

1. **Login to Azure**
   ```bash
   az login
   az account set --subscription <your-subscription-id>
   ```

2. **Create Resource Group**
   ```bash
   az group create --name expense-mgmt-rg --location uksouth
   ```

3. **Deploy Infrastructure**
   ```bash
   az deployment group create \
     --resource-group expense-mgmt-rg \
     --template-file ./infra/app-service.bicep
   ```

4. **Deploy Application**
   ```bash
   az webapp deploy \
     --resource-group expense-mgmt-rg \
     --name <app-service-name> \
     --src-path ./app.zip \
     --type zip
   ```

## Project Structure

```
.
├── deploy.sh                    # Main deployment script
├── app.zip                      # Deployable application package
├── infra/
│   └── app-service.bicep       # Azure App Service infrastructure
├── src/
│   └── ExpenseManagement/      # ASP.NET Core application
│       └── ExpenseManagement/
│           ├── Pages/          # Razor Pages
│           │   ├── AddExpense.cshtml
│           │   ├── Expenses.cshtml
│           │   └── ApproveExpenses.cshtml
│           └── Program.cs
└── README-DEPLOYMENT.md        # This file
```

## Local Development

1. **Build the application**
   ```bash
   cd src/ExpenseManagement/ExpenseManagement
   dotnet build
   ```

2. **Run locally**
   ```bash
   dotnet run
   ```

3. **Publish for deployment**
   ```bash
   dotnet publish -c Release -o ../../../publish
   cd ../../../
   zip -r app.zip publish/
   ```

## Configuration

### App Service SKU
The default configuration uses the F1 (Free) tier for development. To change:

Edit `infra/app-service.bicep` and modify:
```bicep
param appServicePlanSku string = 'F1'
param appServicePlanTier string = 'Free'
```

For production, consider:
- B1 (Basic): Low-cost production tier
- S1 (Standard): Production with auto-scaling
- P1V2 (Premium): Enhanced performance

### Location
Default location is UK South. To change, edit `deploy.sh`:
```bash
LOCATION="uksouth"  # Change to your preferred region
```

## Resource Cleanup

To delete all Azure resources:

```bash
az group delete --name expense-mgmt-rg --yes
```

## Features

### Current Implementation (POC)
- ✅ Add expense form with validation
- ✅ View expenses list
- ✅ Approve expenses interface
- ✅ Responsive Bootstrap UI
- ✅ Azure App Service deployment

### Future Enhancements (Production)
- Database integration (Azure SQL)
- User authentication (Azure AD)
- API backend
- Blob storage for receipts
- Application Insights for monitoring
- CI/CD with GitHub Actions

## Azure Best Practices Applied

1. **Security**
   - HTTPS only enabled
   - TLS 1.2 minimum
   - FTP disabled

2. **Cost Optimization**
   - Free tier for POC/Development
   - Linux App Service (lower cost)
   - No always-on for Free tier

3. **Infrastructure as Code**
   - Bicep templates for reproducibility
   - Parameterized deployments
   - Output values for automation

4. **Deployment**
   - Zip deployment for simplicity
   - Azure CLI for quick setup
   - No complex pipeline setup needed

## Support

For issues or questions about this POC deployment, please refer to Azure App Service documentation:
- https://learn.microsoft.com/azure/app-service/
- https://learn.microsoft.com/azure/azure-resource-manager/bicep/

## License

This is a workshop/POC template. Please review LICENSE file for details.
