#!/usr/bin/env bash
sudo apt update -y
sudo apt install nginx -y
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
# sudo ufw enable
