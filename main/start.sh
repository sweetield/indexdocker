
UUID="1eb6e917774b4a84aff6b058577c60a5"
CADDYIndexPage="https://www.free-css.com/assets/files/free-css-templates/download/page265/shree.zip"
export PORT=${PORT-8080}
export PATH_vless=${PATH_vless-/$UUID-vless}
export PATH_trojan=${PATH_trojan-/$UUID-trojan}
export PATH_vmess=${PATH_vmess-/$UUID-vmess}
export PATH_shadowsocks=${PATH_shadowsocks-/$UUID-shadowsocks}

#CADDYIndexPage-configs
wget --quiet $CADDYIndexPage -O /main/index.html && unzip -qo /main/index.html -d ./ && mkdir page && mv ./*/* ./page/
rm -f /main/index.html

chmod +x ./caddy
./caddy start

echo '
 {
    "log": {"loglevel": "warning"},
    "inbounds": [
        {
            "port": 4000,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "'$UUID'"
                    }
                ],
                "decryption": "none",
                "fallbacks": [
                    {
                        "path": "'${PATH_vless}'",
                        "dest": 4001
                    },{
                        "path": "'${PATH_trojan}'",
                        "dest": 4002
                    },{
                        "path": "'${PATH_vmess}'",
                        "dest": 4003
                    },{
                        "path": "'${PATH_shadowsocks}'",
                        "dest": 4004
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp"
            }
        },{
            "port": 4001,
            "listen": "127.0.0.1",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "'$UUID'"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "'${PATH_vless}'"
                }
            }
        },{
            "port": 4002,
            "listen": "127.0.0.1",
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password": "'$UUID'"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "'${PATH_trojan}'"
                }
            }
        },{
            "port": 4003,
            "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "'$UUID'"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "'${PATH_vmess}'"
                }
            }
        },{
          "port": 4004,
          "protocol": "shadowsocks",
          "settings": {
            "method": "2022-blake3-aes-128-gcm",
            "password": "'$UUID'",
            "network": "tcp,udp"
          },
          "streamSettings": {
            "network": "ws",
            "security": "none",
            "wsSettings": {
                "path": "'${PATH_shadowsocks}'"
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
' > conf.json
chmod +x ./cctv
./cctv -config=conf.json
