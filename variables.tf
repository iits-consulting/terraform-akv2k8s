variable "keyvault_id" {
  type        = string
  description = "Azure Key Vault resource object_id."
}

variable "namespace" {
  type        = string
  default     = "keyvault"
  description = "Namespace to use for akv2k8s chart."
}

variable "keyvault_service_principal_create" {
  type        = bool
  default     = true
  description = "Create a new application service principal for akv2k8s chart. (default: true)"
}

variable "keyvault_service_principal_app_name" {
  type        = string
  default     = "akv2k8s"
  description = "Name of the newly created application service principal for akv2k8s chart. (default: akv2k8s)"
}



variable "keyvault_service_principal_from_keyvault" {
  type        = bool
  default     = false
  description = "Import service principal credentials for akv2k8s from Azure Key Vault. (default: false)"
}

resource "errorcheck_is_valid" "keyvault_service_principal_selector_validation" {
  name = "Keyvault Service Principal Selector Validation"
  test = {
    assert        = !var.keyvault_service_principal_create || !var.keyvault_service_principal_from_keyvault
    error_message = "keyvault_service_principal_create and keyvault_service_principal_from_keyvault can not be enabled at the same time!"
  }
}

variable "keyvault_service_principal_app_id_secret" {
  type        = string
  default     = ""
  description = "Azure Key Vault secret name for service principal ID."
}

variable "keyvault_service_principal_password_secret" {
  type        = string
  default     = ""
  description = "Azure Key Vault secret name for service principal password."
}

resource "errorcheck_is_valid" "keyvault_service_principal_app_id_secret_validation" {
  name = "Keyvault Service Principal App ID Secret Validation"
  test = {
    assert        = length(var.keyvault_service_principal_app_id_secret) != 0 || !var.keyvault_service_principal_from_keyvault
    error_message = "The variable keyvault_service_principal_app_id_secret can not be empty if keyvault_service_principal_from_keyvault is enabled!"
  }
  depends_on = [errorcheck_is_valid.keyvault_service_principal_selector_validation]
}

resource "errorcheck_is_valid" "keyvault_service_principal_password_secret_validation" {
  name = "Keyvault Service Principal Password Secret Validation"
  test = {
    assert        = length(var.keyvault_service_principal_password_secret) != 0 || !var.keyvault_service_principal_from_keyvault
    error_message = "The variable keyvault_service_principal_password_secret can not be empty if keyvault_service_principal_from_keyvault is enabled!"
  }
  depends_on = [errorcheck_is_valid.keyvault_service_principal_selector_validation]
}

variable "keyvault_service_principal_app_id" {
  type        = string
  default     = ""
  description = "Service principal app ID."
}

variable "keyvault_service_principal_password" {
  type        = string
  default     = ""
  description = "Service principal password."
}

resource "errorcheck_is_valid" "keyvault_service_principal_app_id_validation" {
  name = "Keyvault Service Principal App ID Validation"
  test = {
    assert        = length(var.keyvault_service_principal_app_id) != 0 || var.keyvault_service_principal_create || var.keyvault_service_principal_from_keyvault
    error_message = "The variable keyvault_service_principal_app_id can not be empty if both keyvault_service_principal_create and keyvault_service_principal_from_keyvault is disabled!"
  }
  depends_on = [errorcheck_is_valid.keyvault_service_principal_selector_validation]
}

resource "errorcheck_is_valid" "keyvault_service_principal_password_validation" {
  name = "Keyvault Service Principal Password Validation"
  test = {
    assert        = length(var.keyvault_service_principal_password) != 0 || var.keyvault_service_principal_create || var.keyvault_service_principal_from_keyvault
    error_message = "The variable keyvault_service_principal_password can not be empty if both keyvault_service_principal_create and keyvault_service_principal_from_keyvault is disabled!"
  }
  depends_on = [errorcheck_is_valid.keyvault_service_principal_selector_validation]
}
