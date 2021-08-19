# exec this file by:
#
#   bash <(curl -L https://raw.githubusercontent.com/tatwd/dotfiles/master/setup_r2ray.sh)
#

# $config_dir=/user/local/etc/v2ray
#echo "Create v2ray config folder"
#sudo mkdir -p $config_dir

ehco "Download v2ray from github and install"
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

sudo systemctl enable v2ray

cat <<EOF > /usr/local/etc/v2ray/config.json
{
    "inbounds": [
        {
            "port": 10086,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "f81913a5-ba26-4042-9822-77e9d2bfabbf"
                    }
                ]
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

sudo systemctl start v2ray

sudo firewall-cmd --zone=public --add-port=10086/tcp --permanent
sudo systemctl restart firewalld