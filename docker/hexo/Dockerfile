FROM node:lts-alpine
LABEL description="Hexo 部署环境"
WORKDIR /hexo
RUN npm install hexo -g --registry=https://registry.npmmirror.com
RUN sed -i 's/dl-cdn.alpinelinux.org/opentuna.cn/g' /etc/apk/repositories && \
apk add --no-cache python3 git tzdata openssh-client-default && \
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

EXPOSE 4000
CMD [ "sh" ]