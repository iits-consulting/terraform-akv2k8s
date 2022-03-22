resource "helm_release" "akv2k8s" {
  name                  = "akv2k8s"
  repository            = "https://charts.spvapi.no"
  chart                 = "akv2k8s"
  version               = "2.1.0"
  namespace             = var.namespace
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 900 // 15 Minutes
  render_subchart_notes = true
  dependency_update     = true
  values = [yamlencode(sensitive({
    global = {
      logFormat    = "json"
      keyVaultAuth = "environment"
      env = {
        AZURE_TENANT_ID     = data.azurerm_client_config.current.tenant_id
        AZURE_CLIENT_ID     = local.service_principal_app_id
        AZURE_CLIENT_SECRET = local.service_principal_password
    } }
    akv2k8s = {
      controller = {
        logFormat = "json"
    } }
  }))]
}
