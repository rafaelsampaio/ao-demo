data "template_file" "app-declaration" {
  #Demo 1: Basic app (appBasic.json.tpl)
  template = file("${path.module}/appBasic.json.tpl")

  #Demo 2: App with Service Discovery (appServiceDiscovery.json.tpl)
  #template = file("${path.module}/appServiceDiscovery.json.tpl")

  #Demo 3: App with Service Discovery and TLS (appServiceDiscoveryTLS.json.tpl)
  #template = file("${path.module}/appServiceDiscoveryTLS.json.tpl")

  vars = {
    #Demo 1: Basic app (appBasic.json.tpl)
    app_node_ip = var.app-node-ip

    #Demo 2: App with Service Discovery (appServiceDiscovery.json.tpl)
    #app_tag         = var.app-tag
    #app_region      = var.app-region

    #Demo 3: App with Service Discovery and TLS (appServiceDiscoveryTLS.json.tpl)
    #app_certificate = replace(tls_self_signed_cert.app-certificate.cert_pem,"/\n/","\\n")
    #app_private_key = replace(tls_private_key.app-private-key.private_key_pem,"/\n/","\\n")

    app_tenant    = var.app-tenant
    app_name      = var.app-name
    app_address   = var.app-address
    app_node_port = var.app-node-port
  }
}

resource "bigip_as3" "as3-app" {
  as3_json = data.template_file.app-declaration.rendered
}

