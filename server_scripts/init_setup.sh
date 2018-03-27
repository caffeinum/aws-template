# check ubuntu ?

if [[ $OSTYPE != 'linux-gnu' ]]; then
  echo This is not Linux. Exiting...
  exit
fi

echo +++
echo +++ INSTALL NODEJS
echo +++
# install nodejs

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

source load_nvm.sh

nvm install 9.4

# setup .bashrc
touch ~/.temp_bashrc
echo 'export NVM_DIR="$HOME/.nvm"' > ~/.temp_bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.temp_bashrc
echo '' >> ~/.temp_bashrc

(cat ~/.bashrc) >> ~/.temp_bashrc
mv ~/.temp_bashrc ~/.bashrc

#
# install mongodb

# Ubuntu/Debian:
sudo apt-get update
sudo apt-get install mongodb

# TODO: add auth!
sudo sed -i -- "s/^bind_ip = 127.0.0.1$/bind_ip = 0.0.0.0/g" /etc/mongodb.conf

sudo service mongodb restart

#
# install nginx

sudo apt-get install nginx

# configure nginx

export NGINX_DIR=/etc/nginx
export PROJECT_ROOT=~/project
sudo cp $PROJECT_ROOT/server_scripts/project-nginx-conf $NGINX_DIR/sites-available/project

sudo rm $NGINX_DIR/sites-enabled/*
sudo ln -s $NGINX_DIR/sites-available/project $NGINX_DIR/sites-enabled/project

echo \[CONFIG\] nginx project config:
cat $NGINX_DIR/
sudo service nginx restart


# 
# install packages for nodejs

sudo apt-get install python make g++

# configure
cd ~/project

npm install

# port for nodejs
export PORT=9000

# run forever
npm run pm2
npx pm2 startup
sudo env PATH=$PATH:/home/ubuntu/.nvm/versions/node/v9.4.0/bin /home/ubuntu/project/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu

npx pm2 save
