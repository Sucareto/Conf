@echo off
set FEATURE=local-dns
set RELEASE=--release
docker build -t ssrust_build .
docker run -itd --rm -v "cargo_tmp":"/usr/local/cargo/registry" --name ssrust_build ssrust_build
docker cp src.tar.gz ssrust_build:/root/
docker exec ssrust_build sh -c "tar -xaf /root/src.tar.gz -C /build/ --strip-components=1"
docker exec ssrust_build sh -c "time cargo build %RELEASE% --features \"%FEATURE%\" --target x86_64-pc-windows-gnu"

docker cp ssrust_build:/build/target/x86_64-pc-windows-gnu/release/ssservice.exe ./ssservice.exe
docker cp ssrust_build:/build/target/x86_64-pc-windows-gnu/debug/ssservice.exe ./ssservice-debug.exe
docker attach ssrust_build
pause
docker image prune -f