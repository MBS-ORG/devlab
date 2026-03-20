# Terraform Azure Template

Starter Terraform configuration for Azure resources: Resource Group, Storage Account, and Key Vault.

## Resources Provisioned

| Resource | Description |
|---|---|
| `azurerm_resource_group` | Main resource group |
| `azurerm_storage_account` | Blob storage (GRS in prod, LRS otherwise) |
| `azurerm_key_vault` | Key Vault with soft-delete and purge protection |

## Prerequisites

- Terraform >= 1.7.0
- Azure CLI authenticated (`az login`)
- Contributor role on target subscription

## Quick Start

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars

terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Remote State (Recommended for Teams)

Uncomment the `backend "azurerm"` block in `main.tf` and pre-create the storage account:

```bash
az group create -n rg-terraform-state -l westeurope
az storage account create -n stterraformstate -g rg-terraform-state --sku Standard_LRS
az storage container create -n tfstate --account-name stterraformstate
```

## Security Notes

- `terraform.tfvars` is listed in `.gitignore` — never commit it.
- Key Vault has network ACLs set to `Deny` by default; add your IPs via `allowed_ip_ranges`.
- Purge protection is enabled automatically in `prod` environments.
- Storage Account disables shared access keys; use Azure AD auth.
