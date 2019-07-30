# docker 安装
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh --mirror Aliyun
#docker-compose
#1、安装python-pip
yum -y install epel-release
yum -y install python-pip
#2、安装docker-compose
pip install docker-compose
#待安装完成后，执行查询版本的命令，即可安装docker-compose
docker-compose version

## 校验服务器时间
timedatectl set-timezone Asia/Shanghai
or
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime


wget "https://raw.githubusercontent.com/cx9208/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
脚本执行后，选择2安装内核，重启后执行脚本选择7，安装BBR Plus加速模块


shadowsocks=vip2.lloveu.cn:443, method=chacha20-ietf-poly1305, password=Lwj123456, obfs=wss, obfs-host=vip2.lloveu.cn, obfs-uri=/l-ss, fast-open=true, udp-relay=true, tag=ss-ws-tls