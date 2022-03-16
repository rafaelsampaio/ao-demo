data "template_file" "app-declaration" {
  template = file("${path.module}/appSimple.json.tpl")
  vars = {
    app_tenant    = var.app-tenant
    app_name      = var.app-name
    app_address   = var.app-address
    app_tag       = var.app-tag
    app_region    = var.app-region
    app_node_port = var.app-node-port
    app_node_ip   = var.app-node-ip
  }
}

resource "bigip_as3" "as3-app" {
  as3_json = data.template_file.app-declaration.rendered
}

