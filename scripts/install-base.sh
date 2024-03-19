#!/bin/bash
PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

echo "Root password:"
su -c " echo '$USER  ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers" 

cd /tmp/

sudo sed -i "/ main/s/$/ contrib non-free/" /etc/apt/sources.list

sudo apt update
sudo apt-get -yqq install net-tools vim vim-gtk3 iotop atop htop bmon curl wget pwgen lm-sensors pv tmux sudo gpg keepass2 dmidecode openssl bzip2 x11-xkb-utils python3-pip x11-apps x11-utils p7zip-full xfce4-whiskermenu-plugin  git screen apt-transport-https default-jdk icedtea-netx mugshot remmina swaks terminator openfortivpn network-manager-openvpn-gnome network-manager-openconnect-gnome network-manager-fortisslvpn-gnome mc ttf-mscorefonts-installer iptables sqlite3 gcc make cmake build-essential bat neofetch kitty aptitude gnupg

# Repositorios de Google Chrome
curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg >> /dev/null
echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Repositorios de Opera
curl -fSsL https://deb.opera.com/archive.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/opera.gpg >> /dev/null
echo deb [arch=amd64 signed-by=/usr/share/keyrings/opera.gpg] https://deb.opera.com/opera-stable/ stable non-free | sudo tee /etc/apt/sources.list.d/opera.list

sudo apt update
sudo apt-get install -y opera-stable google-chrome-stable

# Repositorios de Microsoft Visual Studio Code
curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-archive-keyring.gpg >> /dev/null
echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list 
sudo apt update
sudo apt-get install -y code

# Instalacion repositorios KALI

curl -fSsL https://archive.kali.org/archive-key.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/kali.gpg >> /dev/null

echo 'deb [signed-by=/usr/share/keyrings/kali.gpg] https://http.kali.org/kali kali-rolling main non-free contrib' | sudo tee /etc/apt/sources.list.d/kali.list

# le indicamos que tiene menos prioridad que los paquetes de Debian
sudo sh -c "echo 'Package: *'>/etc/apt/preferences.d/kali.pref; echo 'Pin: release a=kali-rolling'>>/etc/apt/preferences.d/kali.pref; echo 'Pin-Priority: 50'>>/etc/apt/preferences.d/kali.pref"

sudo apt update

sudo su -c ' echo "aptitude -t kali-rolling \$@" > /usr/bin/apt-kali ' ; sudo chmod +x /usr/bin/apt-kali
sudo su -c ' echo "aptitude -t bookworm \$@" > /usr/bin/apt-deb ' ; sudo chmod +x /usr/bin/apt-deb

#Para instalar:
#apt-kali install PACKAGE-NAME
#apt-deb install PACKAGE-NAME


sudo apt update
sudo apt-deb install wireshark
sudo apt-kali install nmap exploitdb wordlists hydra john burpsuite zaproxy metasploit-framework smbclient masscan smbmap gobuster arp-scan dirbuster amass sqlmap whatweb nikto zsh

# Instalar fuentes para kitty
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip
sudo mkdir -p /usr/share/fonts/Meslo
sudo unzip /tmp/Meslo.zip -d /usr/share/fonts/Meslo
rm -f /tmp/Meslo.zip

echo 'font_family MesloLGS Nerd Font' >> /home/$USER/.config/kitty/kitty.conf

cd ~
#Como usuario "no root"
cd ~
wget https://raw.githubusercontent.com/brunxor/custom-linux/main/home/.zshrc
wget https://raw.githubusercontent.com/brunxor/custom-linux/main/home/.p10k.zsh

sudo rm -f /root/.p10k.zsh
sudo ln -s /home/$USER/.p10k.zsh /root/.p10k.zsh
sudo rm -f /root/.zshrc
sudo ln -s /home/$USER/.zshrc /root/.zshrc

