output "resource_group_name" {
  description = "Name of the main resource group."
  value       = azurerm_resource_group.main.name
}

output "storage_account_name" {
  description = "Name of the storage account."
  value       = azurerm_storage_account.main.name
}

output "key_vault_name" {
  description = "Name of the Key Vault."
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault."
  value       = azurerm_key_vault.main.vault_uri
}
