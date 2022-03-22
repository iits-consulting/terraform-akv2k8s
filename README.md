## Auto Create ArgoCD

Usage example with automatic service principal creation:

```hcl
module "akv2k8s" {
  source = "git::https://github.com/iits-consulting/terraform-akv2k8s.git"
  
  keyvault_id = var.keyvault_id
}
```

Usage example with existing service principal credentials:
```hcl
module "akv2k8s" {
  source = "git::https://github.com/iits-consulting/terraform-akv2k8s.git"

  keyvault_id                              = var.keyvault_id
  keyvault_service_principal_create        = false

  keyvault_service_principal_app_id   = "8f712ad5-f6f6-4e0d-b86d-94cc1057740b"
  keyvault_service_principal_password = "tQv2N~vV5DKggyAi3KAIUPW1uWU-2FjyQ0AN3"
}
```
Usage example with existing service principal credentials from Azure Key Vault:
```hcl
module "akv2k8s" {
  source = "git::https://github.com/iits-consulting/terraform-akv2k8s.git"

  keyvault_id                              = var.keyvault_id
  keyvault_service_principal_create        = false
  keyvault_service_principal_from_keyvault = true

  keyvault_service_principal_app_id_secret   = "ak2k8sAppId"
  keyvault_service_principal_password_secret = "ak2k8sAppSecret"
}
```