# linux
```
rm -rf /tmp/jdkconf/ && git clone --depth 1 https://github.com/jdkang/conf.git /tmp/jdkconf && bash /tmp/jdkconf/linux/run.sh
```

# windows
```
rm -recurse -force -ea 0 -path "${ENV:TEMP}\jdkconf" ; git clone --depth 1 https://github.com/jdkang/conf.git "${ENV:TEMP}\jdkconf" ; & "${ENV:TEMP}\jdkconf\windows\run.ps1"
```