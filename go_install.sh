
# go to https://go.dev/dl/ to download the latest 

rm -rf /usr/local/go

tar -C /usr/local -xzf ~/Downloads/go1.24.2.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin

go version