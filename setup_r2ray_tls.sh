# exec this file by:
#
#   bash <(curl -L https://raw.githubusercontent.com/tatwd/dotfiles/master/setup_r2ray_tls.sh)
#

ehco "Download v2ray from github and install"
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

cat <<EOF > /usr/local/etc/v2ray/config.json
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
						"id": "f81913a5-ba26-4042-9822-77e9d2bfabbf"
					}
				]
			},
			"streamSettings": {
				"network": "tcp",
				"security": "tls",
				"tlsSettings": {
					"certificates": [
						{
							"certificateFile": "/usr/local/etc/v2ray/v2ray.crt",
							"keyFile": "/usr/local/etc/v2ray/v2ray.key"
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

cp /etc/systemd/system/v2ray.service /etc/systemd/system/v2ray.service.nobody
cat /etc/systemd/system/v2ray.service | sed 's/User=nobody/User=root/g' >/etc/systemd/system/v2ray@.service
cp /etc/systemd/system/v2ray@.service /etc/systemd/system/v2ray.service


firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
systemctl restart firewalld

# config ssl crt
myemail="tatwdo@outlook.com"
mydomain="zero.tatwd.me"
yum -q -y install openssl crontabs socat curl
curl https://get.acme.sh | sh -s email=$myemail
source ~/.bashrc
~/.acme.sh/acme.sh --issue -d $mydomain --standalone --keylength ec-256 --force &&
~/.acme.sh/acme.sh --installcert -d $mydomain --ecc \
    --fullchain-file /usr/local/etc/v2ray/v2ray.crt \
    --key-file /usr/local/etc/v2ray/v2ray.key


systemctl enable v2ray
systemctl start v2ray



