from os import system, remove
from random import randint
from sys import argv
from pathlib import Path
import csv
from random import randint, sample
from string import ascii_letters, digits
from json import load, dump

if Path('result.csv').exists():
    print("检测到新配置，正在执行更新...")
    cfg = {"servers": [{}, {}, {}, {}, {}, {}, {}, {}]}
    with open('service-config.json', 'r', encoding='utf-8') as conf:
        cfg = load(conf)
        print("检测到旧配置文件，读取完成。")

    with open('result.csv', 'r', encoding='utf-8') as csvfile:
        ip_list = [row['IP 地址'] for row in csv.DictReader(csvfile)]
        for id in range(0, 8):
            ip = ip_list[id]
            path = ''.join(sample(ascii_letters + digits, randint(9, 15)))
            cfg['servers'][id]['address'] = ip
            cfg['servers'][id]['port'] = 443
            cfg['servers'][id]['password'] = ""
            cfg['servers'][id]['method'] = "none"
            cfg['servers'][id]['plugin'] = "v2ray-plugin"
            cfg['servers'][id]['plugin_opts'] = 'tls;host=fake.local;path=/' + path
    #remove('result.csv')

    with open('service-config.json', 'w', encoding='utf-8') as f:
        dump(cfg, f, indent=4, ensure_ascii=False)
