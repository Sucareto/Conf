@echo off
docker build -t segatools_build -f sgt_build-alpine .
docker run -it --rm -v  %~dp0:"/segatools" -v "build32_tmp":"/segatools/build/build32" -v "build64_tmp":"/segatools/build/build64" segatools_build make dist
pause
docker image prune -f