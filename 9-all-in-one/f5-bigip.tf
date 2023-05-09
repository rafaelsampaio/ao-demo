# BIG-IP
# Setup Onboarding scripts
locals {

  runtime-init-script-vars = {
    do-file              = local.do-file
    ts-config            = local.ts-file
    as3-shared           = local.as3-shared-file
    as3-juiceshop        = local.as3-juiceshop-file
    as3-vampi            = local.as3-vampi-file
    runtime-init-conf    = local.runtime-init-conf-file
    runtime-init-version = "1.6.1"
  }

  runtime-init-conf-vars = {
    mgmt-cidr    = var.mgmt_cidr
    mgmt-self    = var.bigip_mgmt_self
    mgmt-gateway = google_compute_subnetwork.mgmt_subnet.gateway_address
  }

  do-vars = {
    hostname         = "${var.prefix}-${var.bigip_name}"
    passwd           = var.bigip_passwd
    timezone         = var.bigip_timezone
    external-cidr    = var.external_cidr
    external-self    = var.bigip_external_self
    external-gateway = google_compute_subnetwork.external_subnet.gateway_address
    internal-cidr    = var.internal_cidr
    internal-self    = var.bigip_internal_self
    internal-gateway = google_compute_subnetwork.internal_subnet.gateway_address
  }

  ts-vars = {
    logstash_ts_host = var.logstash-ts-host
    es_host          = var.es-host
    es_username      = var.es-username
    es_password      = var.es-password
  }

  juiceshop-vars = {
    app_tag             = "${var.prefix}-juiceshop"
    app_region          = var.gcp_region
    app_certificate     = replace(tls_self_signed_cert.juiceshop_cert.cert_pem, "/\n/", "\\n")
    app_private_key     = replace(tls_private_key.juiceshop_key.private_key_pem, "/\n/", "\\n")
    app_tenant          = "juiceshop"
    app_name            = "juiceshop"
    app_address         = google_compute_address.juiceshop.address
    app_node_port       = 8000
    network_dos_vectors = local.dos-network-vectors-settings
  }

  vampi-vars = {
    app_tag             = "${var.prefix}-vampi"
    app_region          = var.gcp_region
    app_certificate     = replace(tls_self_signed_cert.vampi_cert.cert_pem, "/\n/", "\\n")
    app_private_key     = replace(tls_private_key.vampi_key.private_key_pem, "/\n/", "\\n")
    app_tenant          = "vampi"
    app_name            = "vampi"
    app_address         = google_compute_address.vampi.address
    app_node_port       = 8005
    network_dos_vectors = local.dos-network-vectors-settings
  }

  runtime-init-script-file = templatefile("${path.module}/f5-runtime-init-script.sh.tftpl", local.runtime-init-script-vars)
  runtime-init-conf-file   = templatefile("${path.module}/f5-runtime-init-conf.yaml.tftpl", local.runtime-init-conf-vars)
  do-file                  = templatefile("${path.module}/f5-do.json.tftpl", local.do-vars)
  ts-file                  = templatefile("${path.module}/f5-ts.json.tftpl", local.ts-vars)
  as3-shared-file          = file("${path.module}/f5-as3-shared.json")
  as3-juiceshop-file       = templatefile("${path.module}/f5-as3-tls-sd-waf-ts.json.tftpl", local.juiceshop-vars)
  as3-vampi-file           = templatefile("${path.module}/f5-as3-tls-sd-waf-ts.json.tftpl", local.vampi-vars)
}

# Create F5 BIG-IP VMs
resource "google_compute_instance" "f5_bigip" {
  name         = "${var.prefix}-${var.bigip_name}"
  machine_type = var.bigip_machine
  zone         = var.gcp_zone

  #Ensure that IP forwarding is not enabled on Instances
  can_ip_forward = false

  labels = local.general_labels

  boot_disk {
    initialize_params {
      image = var.bigip_image
      size  = "128"
    }
  }

  #nic0 Management interface
  network_interface {
    network    = google_compute_network.mgmt_net.name
    subnetwork = google_compute_subnetwork.mgmt_subnet.name
    network_ip = var.bigip_mgmt_self
    access_config {}
  }

  #nic1 Data interface 1.1 - external
  network_interface {
    network    = google_compute_network.external_net.name
    subnetwork = google_compute_subnetwork.external_subnet.name
    network_ip = var.bigip_external_self
    access_config {}
  }

  #nic2 Data interface 1.2 - internal
  network_interface {
    network    = google_compute_network.internal_net.name
    subnetwork = google_compute_subnetwork.internal_subnet.name
    network_ip = var.bigip_internal_self
  }

  metadata = {
    startup-script = local.runtime-init-script-file

    #Ensure 'Enable connecting to serial ports' is not enabled for VM Instance
    serial-port-enable = false
    #Ensure "Block Project-wide SSH keys" enabled for VM instances
    block-project-ssh-keys = true
    #Ensure oslogin is enabled for a Project
    enable-oslogin = true
  }

  service_account {
    email  = var.gcp_svc_acct
    scopes = ["cloud-platform"]
  }
}
