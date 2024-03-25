#!/bin/bash
PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

cd /tmp/

sudoer () {
    echo "Root password:"
    su -c " echo '$USER  ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers" 
}

apt_sources () {
    sudo sed -i "/ main /s/contrib non-free//g" /etc/apt/sources.list  # eliminamos si ya existe
    sudo sed -i "/ main/s/$/ contrib non-free/" /etc/apt/sources.list  # añadimos las opciones
}

inst_paquetes_iniciales () {
    sudo apt-get update
    sudo apt -yqq install net-tools vim vim-gtk3 iotop atop htop bmon curl wget pwgen lm-sensors pv sudo  dmidecode openssl bzip2 x11-xkb-utils python3-pip p7zip-full xfce4-whiskermenu-plugin git screen tmux apt-transport-https default-jdk mugshot iptables sqlite3 gcc make cmake build-essential bat neofetch kitty aptitude gpg locate zsh zplug bat tree
}

inst_navegadores () {
    # Repositorios de Google Chrome
    curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg >> /dev/null
    echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list

    # Repositorios de Opera
    curl -fSsL https://deb.opera.com/archive.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/opera.gpg >> /dev/null
    echo deb [arch=amd64 signed-by=/usr/share/keyrings/opera.gpg] https://deb.opera.com/opera-stable/ stable non-free | sudo tee /etc/apt/sources.list.d/opera.list

    sudo apt-get update
    sudo apt-get install -y opera-stable google-chrome-stable

    # Reparar opera (winedevine-drs-html5)
    cd /opt
    sudo git clone https://github.com/Ld-Hagen/fix-opera-linux-ffmpeg-widevine.git
    #(Optional) Run script. And if it works well go to next step.
    sudo /opt/fix-opera-linux-ffmpeg-widevine/scripts/fix-opera.sh
    #sudo /opt/fix-opera-linux-ffmpeg-widevine/install.sh
    cd -
}

inst_vs () {
    # Repositorios de Microsoft Visual Studio Code
    curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-archive-keyring.gpg >> /dev/null
    echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list 
    #sudo apt-get update
    #sudo apt-get install -y code

    sudo apt-get update
    sudo apt-get install -y code
}

inst_nvim () {
    # Instalar nvim - Ultima version (GIT)
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    sudo ln -s /opt/nvim-linux64/bin/nvim /bin/nvim
}

inst_kali_repo () {
    # Instalacion repositorios KALI
    curl -fSsL https://archive.kali.org/archive-key.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/kali.gpg >> /dev/null
    echo 'deb [signed-by=/usr/share/keyrings/kali.gpg] https://http.kali.org/kali kali-rolling main non-free contrib' | sudo tee /etc/apt/sources.list.d/kali.list

    # le indicamos que tiene menos prioridad que los paquetes de Debian
    sudo sh -c "echo 'Package: *'>/etc/apt/preferences.d/kali.pref; echo 'Pin: release a=kali-rolling'>>/etc/apt/preferences.d/kali.pref; echo 'Pin-Priority: 50'>>/etc/apt/preferences.d/kali.pref"

    #sudo apt-get update
    sudo su -c ' echo "aptitude -t kali-rolling \$@" > /usr/bin/apt-kali ' ; sudo chmod +x /usr/bin/apt-kali
    sudo su -c ' echo "aptitude -t bookworm \$@" > /usr/bin/apt-deb ' ; sudo chmod +x /usr/bin/apt-deb

    #Para instalar:
    #apt-kali install PACKAGE-NAME
    #apt-deb install PACKAGE-NAME
}

inst_fuentes () {
    #sudo apt-get update
    #sudo apt-deb install wireshark
    #sudo apt-kali install nmap exploitdb wordlists hydra john burpsuite zaproxy metasploit-framework smbclient masscan smbmap gobuster arp-scan dirbuster amass sqlmap whatweb nikto zsh

    # Instalar fuentes para kitty
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip
    sudo mkdir -p /usr/share/fonts/Meslo
    sudo unzip -o /tmp/Meslo.zip -d /usr/share/fonts/Meslo
    rm -f /tmp/Meslo.zip
    #echo 'font_family MesloLGS Nerd Font' >> /home/$USER/.config/kitty/kitty.conf
}

default_shell () {
    sudo chsh -s $(which zsh) $USER
    sudo chsh -s $(which zsh) root
    sudo sed -e '/^SHELL/ s/^#*/#/' -i /etc/default/useradd 
    sudo su -c "echo 'SHELL=/bin/zsh' >> /etc/default/useradd"  
}

reinciar() {
    echo
    echo "Quieres REINICIAR ahora (s/n):"
    read -p "Respuesta: " choice
     case $choice in
        S|s) sudo reboot ;;
        N|n) echo "has seleccionado NO. Deberá reiniciar manualmente" ;;
        *) invalid_option ;;
    esac
    echo
}

skel () {
    #Como usuario "no root"
    # Con la descarga de SKEL no es necesario:
    sudo rm -rf /etc/skel.tgz
    sudo wget https://github.com/brunxor/custom-linux/raw/main/home/skel.tgz -O /etc/skel.tgz 
    sudo rm -rf /etc/skel.old
    sudo mv /etc/skel /etc/skel.old
    sudo tar -xvzf /etc/skel.tgz --directory /etc

    sudo mv $HOME $HOME.old
    sudo mkdir -p $HOME
    sudo cp -r /etc/skel/.* $HOME
    sudo chown -R $USER:$USER $HOME

    sudo mv /root /root.old
    sudo mkdir -p /root
    sudo cp -r /etc/skel/.* /root
    sudo chown -R root:root /root

    reinciar

}

skel_update () {
    #Como usuario "no root"
    # Con la descarga de SKEL no es necesario:
    sudo rm -rf /etc/skel.tgz
    sudo wget https://github.com/brunxor/custom-linux/raw/main/home/skel.tgz -O /etc/skel.tgz 
    sudo rm -rf /etc/skel.old
    sudo mv /etc/skel /etc/skel.old
    sudo tar -xvzf /etc/skel.tgz --directory /etc

    #sudo mv /home/$USER /home/$USER.old
    #sudo mkdir -p /home/$USER
    sudo cp -rf /etc/skel/.* $HOME
    sudo chown -R $USER:$USER $HOME

    #sudo mv /root /root.old
    #sudo mkdir -p /root
    sudo cp -r /etc/skel/.* /root
    sudo chown -R root:root /root

    reinciar

}

inst_paquetes_adiconales () {
    sudo apt-deb install -y wireshark nmap tcpdump tshark python3-venv
    sudo apt-kali install -y zaproxy gobuster wfuzz burpsuite
    cd /usr/share
    sudo git clone https://github.com/danielmiessler/SecLists.git
}

invalid_option() {
    echo "Invalid option. Please select a valid option."
}

instalacion_completa () {
    echo "Instalacion completa"
    sudoer
    apt_sources
    inst_paquetes_iniciales
    inst_navegadores
    inst_vs
    inst_nvim
    inst_kali_repo
    inst_fuentes
    default_shell

    echo
    echo "Instalar paquetes adicionales (seguridad) ?(s/n)"
    read -p "Respuesta: " choice
     case $choice in
        S|s) inst_paquetes_adiconales ;;
        N|n) echo "has seleccionado NO" ;;
        *) invalid_option ;;
    esac
    echo

    skel


}

wizard () {
    echo "Wizard"

    echo
    echo "Quieres configurar el sudoers automatico (s/n):"
    read -p "Respuesta: " choice
     case $choice in
        S|s) sudoer ;;
        N|n) echo "has seleccionado NO" ;;
        *) invalid_option ;;
    esac
    echo

    echo
    echo "Configurar los sources de apt (non-free) (s/n):"
    read -p "Respuesta: " choice
     case $choice in
        S|s) apt_sources ;;
        N|n) echo "has seleccionado NO" ;;
        *) invalid_option ;;
    esac
    echo

    echo
    echo "Instalación de paquetes básicos (s/n):"
    read -p "Respuesta: " choice
     case $choice in
        S|s) inst_paquetes_iniciales ;;
        N|n) echo "has seleccionado NO" ;;
        *) invalid_option ;;
    esac
    echo

    echo
    echo "Instalación de navegadores (s/n):"
    read -p "Respuesta: " choice
     case $choice in
        S|s) inst_navegadores ;;
        N|n) echo "has seleccionado NO" ;;
        *) invalid_option ;;
    esac
    echo

    echo
    echo "Instalación de Visual Studio Code (s/n):"
    read -p "Respuesta: " choice
     case $choice in
        S|s) inst_vs ;;
        N|n) echo "has seleccionado NO" ;;
        *) invalid_option ;;
    esac
    echo

    echo
    echo "Instalación de NeoVim (s/n)"
    read -p "Respuesta: " choice
     case $choice in
        S|s) inst_nvim ;;
        N|n) echo "has seleccionado NO" ;;
        *) invalid_option ;;
    esac
    echo

    echo
    echo "Instalación de REPOSITORIOS DE KALI (s/n)"
    read -p "Respuesta: " choice
     case $choice in
        S|s) inst_kali_repo ;;
        N|n) echo "has seleccionado NO" ;;
        *) invalid_option ;;
    esac
    echo

    echo
    echo "Instalación de Fuentes de letra para ZSH (s/n)"
    read -p "Respuesta: " choice
     case $choice in
        S|s) inst_fuentes ;;
        N|n) echo "has seleccionado NO" ;;
        *) invalid_option ;;
    esac
    echo

    echo
    echo "Configuracion de la Default SHELL (ZSH) para usuario actual, root y default ?(s/n)"
    read -p "Respuesta: " choice
     case $choice in
        S|s) default_shell ;;
        N|n) echo "has seleccionado NO" ;;
        *) invalid_option ;;
    esac
    echo

    echo
    echo "Instalar paquetes adicionales (seguridad) ?(s/n)"
    read -p "Respuesta: " choice
     case $choice in
        S|s) inst_paquetes_adiconales ;;
        N|n) echo "has seleccionado NO" ;;
        *) invalid_option ;;
    esac
    echo

    echo
    echo " SKEL para usuario actual y root ?(s/n)"
    echo "1. No hacer nada"
    echo "2. SOBREESCRIBIR AMBOS USUARIO. Con backup."
    echo "3. Configurar /etc/skel. Y copiar ficheros junto con la configuración actual"
    read -p "Respuesta: " choice
     case $choice in
        3) skel_update ;;
        2) skel ;;
        1) echo "has seleccionado NO" ;;
        *) invalid_option ;;
    esac
    echo




}

main () {
    echo " Bienvenido "
    echo
    echo "Tipo de instalación a realizar:"
    echo "1. Completa (Sistema Debian Limpio)"
    echo "2. Personalizada (Wizard)"
    read -p "Respuesta: " choice
     case $choice in
        1) instalacion_completa ;;
        2) wizard ;;
        *) invalid_option ;;
    esac
    echo
    echo " Hasta luego! "
}

main
# Instalación completa:

#inst_fuentes


#sudo apt-get -yqq install net-tools vim vim-gtk3 iotop atop htop bmon curl wget pwgen lm-sensors pv tmux sudo gpg keepass2 dmidecode openssl bzip2 x11-xkb-utils python3-pip x11-apps x11-utils p7zip-full xfce4-whiskermenu-plugin  git screen apt-transport-https default-jdk icedtea-netx mugshot remmina swaks terminator openfortivpn network-manager-openvpn-gnome network-manager-openconnect-gnome network-manager-fortisslvpn-gnome mc ttf-mscorefonts-installer iptables sqlite3 gcc make cmake build-essential bat neofetch kitty aptitude gnupg