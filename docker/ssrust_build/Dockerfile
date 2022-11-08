FROM  rust:1.61.0-alpine
LABEL description="ss rust 编译环境"
RUN sed -i 's/dl-cdn.alpinelinux.org/opentuna.cn/g' /etc/apk/repositories && \
apk add --no-cache mingw-w64-gcc build-base && rustup target add x86_64-pc-windows-gnu
WORKDIR /build
