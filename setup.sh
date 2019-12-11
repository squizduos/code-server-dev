#/bin/bash


function install_cpp {
    bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
}

function install_docker {
    apt-get update 
    apt-get install -y docker.io

    usermod -aG docker dev
}

function install_golang {
    curl -sS https://storage.googleapis.com/golang/go1.13.linux-amd64.tar.gz | tar -C /usr/local -xzf -

    export GOROOT=/usr/local/go
    export PATH=$PATH:/usr/local/go/bin

    go get -u -v github.com/ramya-rao-a/go-outline
    go get -u -v github.com/acroca/go-symbols
    go get -u -v github.com/nsf/gocode
    go get -u -v github.com/rogpeppe/godef
    go get -u -v golang.org/x/tools/cmd/godoc
    go get -u -v github.com/zmb3/gogetdoc
    go get -u -v golang.org/x/lint/golint
    go get -u -v github.com/fatih/gomodifytags
    go get -u -v github.com/uudashr/gopkgs/cmd/gopkgs
    go get -u -v golang.org/x/tools/cmd/gorename
    go get -u -v sourcegraph.com/sqs/goreturns
    go get -u -v github.com/cweill/gotests/...
    go get -u -v golang.org/x/tools/cmd/guru
    go get -u -v github.com/josharian/impl
    go get -u -v github.com/haya14busa/goplay/cmd/goplay
    go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct
}

function install_java {
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
    
    apt-get update
    apt-get -y install openjdk-8-jdk
}

function install_ngrok {
    curl -Lo /tmp/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
    unzip -o /tmp/ngrok.zip -d /usr/local/bin
    rm -f /tmp/ngrok.zip
}

function install_nodejs {
    # Install Node.js
    curl -sL https://deb.nodesource.com/setup_11.x | bash -

    # Install Yarn
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

    apt-get update 
    apt-get install -y yarn nodejs
}

function install_python {
    apt-get update
    apt-get install -y python3 python3-dev python3-pip python3-venv
    pip3 install python-language-server pipenv pylint
}

function install_rclone {
    curl https://rclone.org/install.sh | sudo bash	
}


install_cpp
install_docker
install_golang
install_java
install_ngrok
install_nodejs
install_python
install_rclone
