#!/bin/bash
docker run -dit -p 8000:3000 registry.hub.docker.com/bkimminich/juice-shop:v14.5.1
docker run -dit -p 8001:80 registry.hub.docker.com/vulnerables/web-dvwa
docker run -dit -p 8002:80 registry.hub.docker.com/ianwijaya/hackazon
docker run -dit -p 8003:8080 registry.hub.docker.com/webgoat/webgoat:v8.1.0
docker run -dit -p 8004:8080 registry.hub.docker.com/mendhak/http-https-echo:28
docker run -dit -p 8005:5000 registry.hub.docker.com/erev0s/vampi
