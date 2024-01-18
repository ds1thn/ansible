# pan1c/ansible

## How to use

### для работы через контейнер на  локальной машине
### переходим в новую папку и копируем свой приватный ключ (чтобы избежать возможных его потерь)

    mkdir .ssh
    cp -a ~/.ssh/id_rsa .ssh/
    sudo chown -R root:root .ssh

### клюнируем инфру
    git clone git@bitbucket.org:/infra.git

### генерируем локальные конфигурационные файлы и секреты
    cd infra
    sed "s/USER/whoami/g" ssh.cfg.tmpl > ssh.cfg
    sed "s/USER/whoami/g" ansible.cfg.tmpl > ansible.cfg
    echo "password" > pass
    cd ..

### назначаем права
    sudo chown -R root:root infra
    sudo chmod o-w infra

### запускаем контейнер, где будем запускать все
    docker run --rm -it -v `pwd`/.ssh:/root/.ssh -v `pwd`/infra:/work pan1c/ansible:1.0.0 bash

### опционально (внутри контейнера), если приватный ключ запаролен
    eval `ssh-agent`
    ssh-add
