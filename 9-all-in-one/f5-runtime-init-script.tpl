#! /bin/bash
echo ""
echo "*** Starting startup script ***"
echo "*** Setting log to console ***"
mkdir -p  /var/log/cloud
LOG_FILE=/var/log/cloud/startup-script.log
npipe=/tmp/$$.tmp
trap "rm -f $npipe" EXIT
mknod $npipe p
tee <$npipe -a $LOG_FILE /dev/ttyS0 &
exec 1>&-
exec 1>$npipe
exec 2>&1

mkdir -p /config/cloud
echo "*** Creating DO file ***"
cat << 'EOF' > /config/cloud/do.json
${do-file}
EOF

echo "*** Creating AS3 Juice Shop file ***"
cat << 'EOF' > /config/cloud/as3-juiceshop.json
${as3-juiceshop-file}
EOF

echo "*** Creating AS3 DVWA file ***"
cat << 'EOF' > /config/cloud/as3-dvwa.json
${as3-dvwa-file}
EOF

echo "*** Creating AS3 Hackazon file ***"
cat << 'EOF' > /config/cloud/as3-hackazon.json
${as3-hackazon-file}
EOF

echo "*** Creating runtime init with YAML file  ***"
cat << 'EOF' > /config/cloud/runtime-init-conf.yaml
---
bigip_ready_enabled:
  - name: management-network-settings
    type: inline
    commands:
      - tmsh modify sys db provision.1nicautoconfig value disable
      - tmsh modify sys global-settings mgmt-dhcp disabled
      - tmsh delete sys management-route all
      - tmsh delete sys management-ip all
      - tmsh create sys management-ip ${mgmt-self}/32
      - tmsh create sys management-route mgmt_gw network ${mgmt-gateway}/32 type interface
      - tmsh create sys management-route mgmt_net network ${mgmt-cidr} gateway ${mgmt-gateway}
      - tmsh create sys management-route default gateway ${mgmt-gateway}
  - name: external-network-settings
    type: inline
    commands:
      - tmsh create net vlan external interfaces add { 1.1 } mtu 1460
      - tmsh create net self external-self address ${external-self}/32 vlan external allow-service default
      - tmsh create net route external-gw network ${external-gateway}/32 interface external
      - tmsh create net route external-network network ${external-cidr} gw ${external-gateway}
      - tmsh create net route default gw ${external-gateway}      
  - name: internal-network-settings
    type: inline
    commands:
      - tmsh create net vlan internal interfaces add { 1.2 } mtu 1460
      - tmsh create net self internal-self address ${internal-self}/32 vlan internal allow-service default
      - tmsh create net route internal-gw network ${internal-gateway}/32 interface internal
      - tmsh create net route internal-network network ${internal-cidr} gw ${internal-gateway}
  - name: gcp-settings
    type: inline
    commands:
      - tmsh modify sys global-settings remote-host add { metadata.google.internal { hostname metadata.google.internal addr 169.254.169.254 } }
      - tmsh modify sys dns name-servers add { 169.254.169.254 }
extension_packages:
  install_operations:
    - extensionType: do
      extensionVersion: 1.29.0
    - extensionType: as3
      extensionVersion: 3.36.0
    - extensionType: fast
      extensionVersion: 1.17.0
    - extensionType: ts
      extensionVersion: 1.28.0
    - extensionType: cf
      extensionVersion: 1.10.0
extension_services:
  service_operations:
    - extensionType: do
      type: url
      value: file:///config/cloud/do.json
    - extensionType: as3
      type: url
      value: file:///config/cloud/as3-juiceshop.json
    - extensionType: as3
      type: url
      value: file:///config/cloud/as3-dvwa.json
    - extensionType: as3
      type: url
      value: file:///config/cloud/as3-hackazon.json      
EOF

echo "*** Downloading runtime init ***"
curl https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.4.1/dist/f5-bigip-runtime-init-1.4.1-1.gz.run -o f5-bigip-runtime-init-1.4.1-1.gz.run && bash f5-bigip-runtime-init-1.4.1-1.gz.run -- '--cloud gcp'

echo "*** Running runtime init with YAML file ***"
/usr/local/bin/f5-bigip-runtime-init --config-file /config/cloud/runtime-init-conf.yaml

echo "*** Done startup script ***"