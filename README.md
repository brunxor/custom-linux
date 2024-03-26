# custom-linux.

Para instalar (Debian 12 sólo con XFCE):

---

** Es necesario tener instalado wget:

`echo 'Contraseña de root:' ;su -c 'apt update;apt-get -yqq install wget curl'`

** Instalador en una línea:

`cd /tmp ; wget https://raw.githubusercontent.com/brunxor/custom-linux/main/install-base.sh ; chmod +x install-base.sh ; ./install-base.sh ; cd -`


