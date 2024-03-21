# custom-linux.

Para instalar (Debian 12 mínimo con XFCE):

** Es necesario tener instalado wget:

echo 'Contraseña de root:' ;su -c 'apt update;apt-get -yqq install wget curl'

cd /tmp ; wget https://raw.githubusercontent.com/brunxor/custom-linux/main/scripts/install-base.sh ; chmod +x install-base.sh

./install-base.sh 
