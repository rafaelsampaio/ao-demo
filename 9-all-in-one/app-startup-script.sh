#!/bin/bash
docker run -dit -p 8000:3000 registry.hub.docker.com/bkimminich/juice-shop
docker run -dit -p 8001:80 registry.hub.docker.com/vulnerables/web-dvwa
docker run -dit -p 8002:80 registry.hub.docker.com/ianwijaya/hackazon
docker run -dit -p 8003:8080 registry.hub.docker.com/webgoat/webgoat