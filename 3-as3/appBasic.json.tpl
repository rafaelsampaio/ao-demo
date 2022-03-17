{
    "class": "AS3",
    "action": "deploy",
    "logLevel": "debug",
    "persist": true,
    "declaration": {
        "class": "ADC",
        "schemaVersion": "3.34.0",
        "$schema": "https://raw.githubusercontent.com/F5Networks/f5-appsvcs-extension/master/schema/latest/as3-schema.json",
        "${app_tenant}": {
            "class": "Tenant",
            "${app_name}": {
                "class": "Application",

                "${app_name}-http-80": {
                    "class": "Service_HTTP",
                    "remark": "${app_name}-HTTP-service",
                    "allowVlans": [
                        "external"
                    ],
                    "virtualAddresses": [
                        "${app_address}"
                    ],
                    "pool": "${app_name}-pool",
                    "snat": "auto"
                },
                
                "${app_name}-pool": {
                    "class": "Pool",
                    "monitors": [
                        "http"
                    ],
                    "members": [
                        {
                            "servicePort": ${app_node_port},
                            "serverAddresses": [
                                "${app_node_ip}"
                            ]
                        }
                    ]
                }
            }
        }
    }
}