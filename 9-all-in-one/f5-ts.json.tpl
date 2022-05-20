{
    "$schema": "https://github.com/F5Networks/f5-telemetry-streaming/raw/master/src/schema/latest/base_schema.json",
    "schemaVersion": "1.28.0",
    "class": "Telemetry",
    "My_System": {
        "class": "Telemetry_System",
        "systemPoller": {
            "interval": 60
        }
    },
    "My_Controls": {
        "class": "Controls",
        "logLevel": "info",
        "debug": false
    },
    "My_Listener": {
        "class": "Telemetry_Listener",
        "port": 6514
    },
    "ElasticSearch": {
        "class": "Telemetry_Consumer",
        "type": "ElasticSearch",
        "host": "${elastic_server}",
        "index": "bigip-ts",
        "port": 9200,
        "protocol": "http",
        "apiVersion": "8.1.0"
    }    
}