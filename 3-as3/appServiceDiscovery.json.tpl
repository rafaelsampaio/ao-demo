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
                    "label": "${app_name}-service",
                    "remark": "${app_name}-HTTP-service",
                    "allowVlans": [
                        "external"
                    ],
                    "virtualAddresses": [
                        "${app_address}"
                    ],
                    "profileAnalytics": {
                        "use": "${app_name}-analytics-http"
                    },
                    "profileAnalyticsTcp": {
                        "use": "${app_name}-analytics-tcp"
                    },
                    "pool": "${app_name}-pool-sd",
                    "snat": "auto",
                    "policyWAF": {
                        "use": "${app_name}-waf-policy"
                    }
                },

                "${app_name}-pool-sd": {
                    "class": "Pool",
                    "monitors": [
                        "http"
                    ],
                    "members": [
                        {
                            "servicePort": ${app_node_port},
                            "addressDiscovery": "gce",
                            "updateInterval": 30,
                            "tagKey": "application",
                            "tagValue": "${app_tag}",
                            "addressRealm": "private",
                            "region": "${app_region}"
                        }
                    ]
                },

                "aot-app-analytics-http": {
                    "class": "Analytics_Profile",
                    "collectClientSideStatistics": true,
                    "collectedStatsInternalLogging": true,
                    "collectGeo": true,
                    "collectIp": true,
                    "collectMaxTpsAndThroughput": true,
                    "collectMethod": true,
                    "collectOsAndBrowser": true,
                    "collectPageLoadTime": true,
                    "collectResponseCode": true,
                    "collectSubnet": true,
                    "collectUrl": true,
                    "collectUserAgent": true,
                    "collectUserSession": true,
                    "publishIruleStatistics": true
                },

                "aot-app-analytics-tcp": {
                    "class": "Analytics_TCP_Profile",
                    "collectCity": true,
                    "collectContinent": true,
                    "collectCountry": true,
                    "collectedByClientSide": true,
                    "collectedByServerSide": true,
                    "collectedStatsInternalLogging": true,
                    "collectNexthop": true,
                    "collectPostCode": true,
                    "collectRegion": true,
                    "collectRemoteHostIp": true,
                    "collectRemoteHostSubnet": true
                },
                
                "${app_name}-waf-policy": {
                    "class": "WAF_Policy",
                    "remark": "${app_name}-WAF-policy",
                    "label": "${app_name}-WAF-policy",
                    "url": "https://raw.githubusercontent.com/xxxxxxxxxxx/waf-policy.xml",
                    "ignoreChanges": true
                }
            }
        }
    }
}