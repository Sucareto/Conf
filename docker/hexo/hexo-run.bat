@echo off
docker build -t hexo .
docker run -tid -v %~dp0:"/hexo" -v "hexo_node_modules:/hexo/node_modules" --name hexo_tmp --rm -p 4000:4000 hexo
docker exec hexo_tmp sh -c "mkdir -p /root/.ssh && cp ./ssh/hexo_rw /root/.ssh/id_rsa && chmod -R 400 /root/.ssh/*"
docker exec hexo_tmp sh -c "npm install --registry=https://registry.npmmirror.com"
docker exec hexo_tmp sh -c "hexo g"
docker attach hexo_tmp
pause
docker stop hexo_tmp
docker image prune -f