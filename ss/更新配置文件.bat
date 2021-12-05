@echo off
CloudflareST.exe -sl 5 -tl 300 -n 500 -t 10
set https_proxy=http://127.0.0.1:2333
python genacl_proxy_gfw_bypass_china_ip.py gfw.acl
python make_conf.py
cd WinSW
WinSW.exe restart ss-rust.xml