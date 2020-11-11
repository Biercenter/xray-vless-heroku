#!/bin/sh

# Download and install ngweb
mkdir /tmp/ngweb
curl -L -H "Cache-Control: no-cache" -o /tmp/ngweb/ngweb.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/ngweb/ngweb.zip -d /tmp/ngweb
base64 > /tmp/ngweb/config << EOF
{
    "log": {
        "access": "none"
    }, 
    "inbounds": [
        {
            "port": $PORT, 
            "protocol": "vless", 
            "settings": {
                "decryption": "none", 
                "clients": [
                    {
                        "id": "$UUID"
                    }
                ]
            }, 
            "streamSettings": {
                "network": "ws", 
                "wsSettings": {
                    "path": "/4za406jj"
                }
            }
        }
    ], 
    "outbounds": [
        {
            "protocol": "freedom", 
            "settings": { }
        }
    ]
}
EOF

base64 -d /tmp/ngweb/config | /tmp/ngweb/v2ctl config stdin: | base64 > /tmp/ngweb/ngweb.config
install -m 755 /tmp/ngweb/v2ray /usr/local/bin/ngweb
install -m 644 /tmp/ngweb/ngweb.config /usr/local/bin/ngweb.config

# Remove temporary directory
rm -rf /tmp/ngweb

# Run V2Ray
base64 -d /usr/local/bin/ngweb.config | /usr/local/bin/ngweb -format=pb -c=stdin:
