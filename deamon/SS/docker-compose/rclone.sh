# 获取token
rclone authorize "onedrive"
# 挂载 onedrive
yum install uzip
yum install fuse
curl https://rclone.org/install.sh | bash
rclone mount myone:Documents ~/one --allow-other --uid 33 --gid 33 --daemon
rclone mount dropbox:self ~/dropbox --allow-other --uid 33 --gid 33 --daemon
fusermount -u  ~/dropbox   #卸载