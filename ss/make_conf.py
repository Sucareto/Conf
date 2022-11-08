from random import randint
from csv import DictReader
from random import randint, sample
from string import ascii_letters, digits
from json import dump
from urllib import request
from datetime import datetime

# https://docs.rs/shadowsocks-rust/1.8.23/shadowsocks/acl/struct.AccessControl.html
# https://github.com/pmkol/easymosdns/tree/rules
CHINA_IP_LIST = "https://raw.githubusercontent.com/pmkol/easymosdns/rules/china_ip_list.txt"

CUSTOM_BYPASS = [
    "127.0.0.1",
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
    "fd00::/8",
]
CUSTOM_PROXY = [

]

try:
    now = datetime.now()
    with open("bypass.acl", 'wb') as fp:
        fp.write("# Time: {}\n".format(now.isoformat()).encode("utf-8"))
        fp.write(b"\n")
        fp.write(b"[proxy_all]\n")

        # 忽略地址列表
        fp.write(b"\n[bypass_list]\n")
        fp.write(request.urlopen(CHINA_IP_LIST).read())
        fp.write(b"\n")

        if len(CUSTOM_BYPASS) > 0:
            for a in CUSTOM_BYPASS:
                fp.write(a.encode("utf-8"))
                fp.write(b"\n")
        print("ACL更新完成。")
except:
    print("ACL更新失败。")

cfg = {
    "no_delay": True,
    "dns": "google",
    "mode": "tcp_only",
    "timeout": 2000,
    "runtime": {
        "mode": "single_thread"
    },
    "locals": [
        {  # 本地 dns 服务，需要编译时启用 local-dns
            "protocol": "dns",
            "local_address": "127.0.0.1",
            "local_port": 53,
            "local_dns_address": "223.5.5.5",
            "local_dns_port": 53,
            "remote_dns_address": "8.8.8.8",
            "remote_dns_port": 53
        },
        {  # 本地 http 代理
            "protocol": "http",
            "local_address": "127.0.0.1",
            "local_port": 19810
        },
        {  # 本地 SOCKS5, SOCKS4/4a 代理
            "protocol": "socks",
            "local_address": "127.0.0.1",
            "local_port": 1080
        }
    ],
    "servers": []
}
ip_list = []

with open('result.csv', 'r', encoding='utf-8') as csvfile:
    csv_ip = [row['IP 地址'] for row in DictReader(csvfile)]
    for i in range(0, 4):
        ip_list.append(csv_ip[i])


for ip in ip_list:
    id = len(cfg['servers'])
    path = ''.join(sample(ascii_letters + digits, randint(5, 15)))
    cfg['servers'].append(
        {
            "address": ip,
            "port": 443,
            "password": path,
            "method": "none",
            "plugin": "v2ray-plugin",
            "plugin_opts": "loglevel=none;tls;host=fake.local;path=/" + path
        }
    )


with open('service-config.json', 'w', encoding='utf-8') as f:
    dump(cfg, f, indent=4, ensure_ascii=False)
    print("配置更新完成。")
