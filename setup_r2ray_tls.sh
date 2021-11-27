# exec this file by:
#
#   bash <(curl -L https://raw.githubusercontent.com/tatwd/dotfiles/master/setup_r2ray_tls.sh)
#
myemail="tatwdo@outlook.com"
mydomain="zero.tatwd.me"

v2ray_crt="/usr/local/etc/v2ray/v2ray.crt"
v2ray_key="/usr/local/etc/v2ray/v2ray.key"
v2ray_cfg="/usr/local/etc/v2ray/config.json"
v2ray_srv="etc/systemd/system/v2ray.service"

client_id=$(uuidgen)
echo "Create a client id: $client_id"


ehco "Download v2ray from github and install"
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

cat <<EOF > $v2ray_cfg
{
	"log": {
		"loglevel": "info"
	},
	"inbounds": [
		{
			"port": 443,
			"protocol": "vmess",
			"settings": {
				"clients": [
					{
						"id": "$client_id"
					}
				]
			},
			"streamSettings": {
				"network": "tcp",
				"security": "tls",
				"tlsSettings": {
					"certificates": [
						{
							"certificateFile": "$v2ray_crt",
							"keyFile": "$v2ray_key"
						}
					]
				}
			}
		}
	],
	"outbounds": [
		{
			"protocol": "freedom"
		}
	]
}
EOF


systemctl disable v2ray

# cp /etc/systemd/system/v2ray.service /etc/systemd/system/v2ray.service.nobody
# cat /etc/systemd/system/v2ray.service | sed 's/User=nobody/User=root/g' >/etc/systemd/system/v2ray@.service
# cp /etc/systemd/system/v2ray@.service /etc/systemd/system/v2ray.service
cp $v2ray_srv "$v2ray_srv.nobody"
sed -i 's/User=nobody/User=root/g' $v2ray_srv


firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
systemctl restart firewalld

# config ssl crt
yum -q -y install openssl crontabs socat curl
curl https://get.acme.sh | sh -s email=$myemail
source ~/.bashrc
~/.acme.sh/acme.sh --issue -d $mydomain --standalone --keylength ec-256 --force &&
~/.acme.sh/acme.sh --installcert -d $mydomain --ecc \
    --fullchain-file $v2ray_crt \
    --key-file $v2ray_key


systemctl enable v2ray
systemctl start v2ray



