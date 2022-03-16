{
    "$schema": "https://github.com/F5Networks/f5-declarative-onboarding/raw/master/src/schema/latest/base.schema.json",
    "schemaVersion": "1.27.0",
    "class": "Device",
    "async": true,
    "Common": {
        "class": "Tenant",
        "mySystem": {
            "class": "System",
            "hostname": "${hostname}.local",
            "cliInactivityTimeout": 1200,
            "consoleInactivityTimeout": 1200,
            "autoCheck": true,
            "autoPhonehome": false
        },
        
        "myNtp": {
            "class": "NTP",
            "timezone": "${timezone}"
        },

        "myProvisioning": {
            "class": "Provision",
            "asm": "nominal",
            "avr": "nominal",
            "ltm": "nominal"
        },

        "dbVars": {
            "class": "DbVariables",
            "provision.extramb": 1000,
            "restjavad.useextramb": true,
            "ui.advisory.enabled": true,
            "ui.advisory.color": "green",
            "ui.advisory.text": "Automation and Orchestration Toolchain Demo",
            "config.allow.rfc3927": "enable"
        },

        "admin": {
            "class": "User",
            "userType": "regular",
            "password": "${passwd}",
            "shell": "bash"
        }
    }
}