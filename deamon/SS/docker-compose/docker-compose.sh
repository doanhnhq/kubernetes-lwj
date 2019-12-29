#!/bin/sh -e

domain="xg.lloveu.cn"
mainDomain="lloveu.com"

# 挂载 onedrive
# yum install uzip
# yum install fuse
# curl https://rclone.org/install.sh | bash
# rclone mount myone:Documents ~/one --allow-other --uid 33 --gid 33 --daemon

if [ ! -d ~/app ]; then 
  mkdir ~/app
else
  echo '已经存在项目~/app，如需更新，请先删除'
fi

if [ ! -f ~/app/config.json ]; then
  touch ~/app/config.json
  echo '{
    "inbounds": [
      {
        "listen": "0.0.0.0",
        "streamSettings": {
          "network": "ws",
          "wsSettings": {
            "path": "/l-ray"
          },
          "security": "auto"
        },
        "settings": {
          "clients": [
            {
              "id": "68ab8722-b3ba-4897-89b0-a02cb480ab4e",
              "alterId": 4
            }
          ]
        },
        "protocol": "vmess",
        "port": 44222
      },
      {
        "listen": "0.0.0.0",
        "streamSettings": {
          "network": "ws",
          "wsSettings": {
            "path": "/l-ss"
          },
          "security": "auto"
        },
        "protocol": "shadowsocks",
        "port": 44333,
        "settings": {
          "method": "chacha20-ietf-poly1305",
          "password": "Lwj123456",
          "network": "tcp,udp"
        }
      }
    ],
    "outbounds": [
      {
        "tag": "direct",
        "settings": {},
        "protocol": "freedom"
      }
    ]
  }'>>~/app/config.json;
fi

if [ ! -f ~/app/Caddyfile ]; then
  touch ~/app/Caddyfile
  echo "
${domain} {
    gzip
    tls a10247107@gmail.com
    proxy /l-ray v2ray:44222 {
        websocket
        header_upstream -Origin
    }
    proxy /l-ss v2ray:44333 {
        websocket
        header_upstream -Origin
    }
    proxy /ss ss:44444 {
        websocket
        header_upstream -Origin
    }
    proxy / https://waylau.com
        # write log to stdout for docker
        log stdout
        errors stdout
}


http://*.ngrok.${mainDomain}{
    gzip
    proxy / ngrok:80 {
        header_upstream Host {host}
        header_upstream X-Real-IP {remote}
        header_upstream X-Forwarded-For {remote}
        header_upstream X-Forwarded-Proto {scheme}
    }
}

*.ngrok.${mainDomain} {
    gzip
    tls a10247107@gmail.com {
        dns cloudflare
    }
    proxy / ngrok:80 {
        header_upstream Host {host}
        header_upstream X-Real-IP {remote}
        header_upstream X-Forwarded-For {remote}
        header_upstream X-Forwarded-Proto {scheme}
    }
}">>~/app/Caddyfile;
fi

if [ ! -f ~/app/ss-config.json ]; then
  touch ~/app/ss-config.json
  echo '
{
    "server":"0.0.0.0",
    "server_port":44444,
    "method":"chacha20-ietf-poly1305",
    "timeout":300,
    "password":"Lwj123456",
    "fast_open":false,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"v2ray-plugin",
    "plugin_opts":"server;path=/ss",
    "或者":"server;mux=0"
}'>>~/app/ss-config.json;
fi

if [ ! -f ~/app/docker-compose.yml ]; then
  touch ~/app/docker-compose.yml
  echo '
version: '3'
    
services:
  v2ray:
    container_name: v2ray
    # image: v2ray/official
    image: registry.ap-southeast-1.aliyuncs.com/jay_liu/wray:1.0.0
    restart: always
    volumes:
    - ./config.json:/etc/v2ray/config.json
    expose:
    - "44222"
    - "44333" 
    # ports:
    # - "44333"

  ss:
    container_name: ss
    image: registry.ap-southeast-1.aliyuncs.com/jay_liu/ss-libev:1.0.0
    restart: always
    volumes:
    - ./ss-config.json:/etc/shadowsocks-libev/config.json
    expose:
    - "44444"
 
  ngrok:
    container_name: ngrok
    image: registry.ap-southeast-1.aliyuncs.com/jay_liu/ngrok:1.0.3
    restart: always
    expose:
    - "80"
    - "443"
    ports:
    - "543:4443"

  caddy:
    container_name: caddy
    # image: abiosoft/caddy
    image: registry.ap-southeast-1.aliyuncs.com/jay_liu/caddy:1.0.0
    restart: always
    volumes:
    - ./Caddyfile:/etc/Caddyfile:ro
    - ./caddyCertificates:/root/.caddy
    environment:
    - ACME_AGREE=true
    - CLOUDFLARE_EMAIL=a10247107@gmail.com
    - CLOUDFLARE_API_KEY=b001150308f7679665b84672d1639dab9de49
    ports:
    - "80:80"
    - "443:443"'>>~/app/docker-compose.yml;
fi

docker --version
if [ $? -ne 0 ]; then
    # docker 安装
    curl -fsSL get.docker.com -o ~/app/get-docker.sh
    sh ~/app/get-docker.sh --mirror Aliyun
    #docker-compose
    #1、安装python-pip
    yum --version
    if [ $? -ne 0 ]; then
       apt-get -y install epel-release
       apt-get -y install python-pip
    else
       yum -y install epel-release
       yum -y install python-pip
    fi
   
    #2、安装docker-compose
    pip install docker-compose
    #待安装完成后，执行查询版本的命令，即可安装docker-compose
    docker-compose version
fi

