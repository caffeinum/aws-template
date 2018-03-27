export NGINX_DIR=/etc/nginx
export PROJECT_ROOT=~/project
sudo cp $PROJECT_ROOT/server_scripts/project-nginx-conf $NGINX_DIR/sites-available/project

sudo rm $NGINX_DIR/sites-enabled/*
sudo ln -s $NGINX_DIR/sites-available/project $NGINX_DIR/sites-enabled/project

echo \[CONFIG\] nginx project config:
cat $NGINX_DIR/sites-enabled/project
sudo service nginx restart
