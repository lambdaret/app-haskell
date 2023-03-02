# app-haskell

```
wget -qO- https://get.haskellstack.org/ | sh
stack upgrade
stack new app-haskell

cd app-haskell
stack build
stack exec my-project-exe

stack run
```

```
# s3.amazonaws.com 에 접속이 안될때 (docker container 내에서 접속 오류)
# /etc/resolv.conf 추가
nameserver 192.168.xx.x
nameserver 8.8.8.8          <--- 추가
```
