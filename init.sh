#!/bin/bash
apt update
apt upgrade -y
apt install nodejs -y
apt install npm -y
cat <<EOF> /home/ubuntu/script.sh
#!/bin/bash
git clone https://github.com/scarabeo7/node-challenge-quote-server
cd node-challenge-quote-server
git checkout chizim-chinuru-node-w-1
npm install
npm start
EOF
bash /home/ubuntu/script.sh
