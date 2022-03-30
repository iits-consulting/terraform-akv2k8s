data "azurerm_client_config" "current" {
}

data "azurerm_key_vault_secret" "akv2k8sClientId" {
  count        = var.keyvault_service_principal_from_keyvault ? 1 : 0
  key_vault_id = var.keyvault_id
  name         = var.keyvault_service_principal_app_id_secret_name

  depends_on = [errorcheck_is_valid.keyvault_service_principal_app_id_secret_name_validation]
}

data "azurerm_key_vault_secret" "akv2k8sClientSecret" {
  count        = var.keyvault_service_principal_from_keyvault ? 1 : 0
  key_vault_id = var.keyvault_id
  name         = var.keyvault_service_principal_password_secret_name

  depends_on = [errorcheck_is_valid.keyvault_service_principal_password_secret_name_validation]
}

data "azuread_service_principal" "akv2k8s" {
  count          = !var.keyvault_service_principal_create ? 1 : 0
  application_id = var.keyvault_service_principal_from_keyvault ? data.azurerm_key_vault_secret.akv2k8sClientId[0].value : var.keyvault_service_principal_app_id

  depends_on = [errorcheck_is_valid.keyvault_service_principal_app_id_validation]
}


resource "azuread_application" "akv2k8s" {
  count        = var.keyvault_service_principal_create ? 1 : 0
  display_name = var.keyvault_service_principal_app_name
}

resource "azuread_service_principal" "akv2k8s" {
  count          = var.keyvault_service_principal_create ? 1 : 0
  application_id = azuread_application.akv2k8s[0].application_id
}

resource "azuread_service_principal_password" "akv2k8s" {
  count                = var.keyvault_service_principal_create ? 1 : 0
  service_principal_id = azuread_service_principal.akv2k8s[0].object_id
}


locals {
  service_principal_app_id    = var.keyvault_service_principal_create ? azuread_application.akv2k8s[0].application_id : (var.keyvault_service_principal_from_keyvault ? data.azurerm_key_vault_secret.akv2k8sClientId[0].value : var.keyvault_service_principal_app_id)
  service_principal_password  = var.keyvault_service_principal_create ? azuread_service_principal_password.akv2k8s[0].value : (var.keyvault_service_principal_from_keyvault ? data.azurerm_key_vault_secret.akv2k8sClientSecret[0].value : var.keyvault_service_principal_password)
  service_principal_object_id = var.keyvault_service_principal_create ? azuread_service_principal.akv2k8s[0].object_id : data.azuread_service_principal.akv2k8s[0].object_id
}

resource "azurerm_key_vault_access_policy" "als_vault_service_principal" {
  key_vault_id        = var.keyvault_id
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = local.service_principal_object_id
  key_permissions     = ["Get", "List"]
  secret_permissions  = ["Get", "List"]
  storage_permissions = ["Get", "List"]
}
