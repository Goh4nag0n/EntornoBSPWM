#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#variables globales
ruta=$(pwd)

function helpPanel (){
    echo -e "\nUso:"
    echo -e "\te) Ejecutar script para modificacion del entorno"
    echo -e "\th) panel de ayuda no es muy complejo solo ejecutar y estar atento a las interacciones del script con el usuario..."
}

function updateSystem (){
    echo -e "\n[+] Actualizando el sistema"
    echo -e "\n[+] el entorno es parrot o debian puro?"&& read entorno
    while true; do
        if [ $entorno = parrot ]; then
            sudo apt update
            sudo parrot-upgrade
            break
        elif [ $entorno = debian ]; then
            sudo apt update
            sudo apt upgrade
            break
        else 
            echo -e "\n[!] unicamente se puede responder con parrot o debian en minusculas"
            echo -e "\n[+] el entorno es parrot o debian puro?"&& read entorno 
        fi
    done
}

function dependencies (){
    echo -e "[+] Instalando dependencias de Entorno"
    sleep 1
    sudo apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev

    echo -e "[+] Instalando Requerimientos para la polybar"
    sleep 1
    sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev

    echo -e "[+] Dependencias de Picom"
    sleep 1
    sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev
    
    echo -e "[+] Instalamos paquetes adicionales"
    sleep 1
    sudo apt install -y feh scrot scrub zsh rofi xclip bat locate neofetch wmname acpi bspwm sxhkd imagemagick ranger kitty thunar telnet krusader baobab flameshot ipcalc npm
}
# Creando carpeta de Reposistorios
function installRepositories () {
    echo -e "\n[+] Creando Carpeta de Repositorios"
    mkdir ~/github

    echo -e "\n[+] Descargar Repositorios Necesarios"
    sleep 1
    
    cd ~/github
    git clone --recursive https://github.com/polybar/polybar
    git clone https://github.com/ibhagwan/picom.git

    echo -e "\n[+] Instalando Polybar"
    
    sleep 1
    cd ~/github/polybar
    mkdir build
    cd build
    cmake ..
    make -j$(nproc)
    sudo make install

    echo -e "\n[+] Instalando Picom"

    cd ~/github/picom
    git submodule update --init --recursive
    meson --buildtype=release . build
    ninja -C build
    sudo ninja -C build install

    echo -e "\n[+] Instalando p10k"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
    echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

    echo -e "\n[+] Instalando p10k root"

    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k
    mkdir -p ~/.config/rofi/themes
    cp $ruta/rofi/nord.rasi ~/.config/rofi/themes/

    echo -e "\n[+] Instando lsd"

    sudo dpkg -i $ruta/lsd.deb

    echo -e "\n[+] Instalamos las HackNerdFonts"

    sudo cp -v $ruta/fonts/HNF/* /usr/local/share/fonts/

    echo -e "\n[+] Instalando Fuentes de Polybar"

    sudo cp -v $ruta/Config/polybar/fonts/* /usr/share/fonts/truetype/

    echo -e "\n[+] Instalando Wallpaper de S4vitar"

    mkdir ~/Wallpaper
    cp -v $ruta/Wallpaper/* ~/Wallpaper
}

function filesConfiguration (){
    echo -e "\n[+] Copiando Archivos de Configuración"

    cp -rv $ruta/Config/* ~/.config/

    # Kitty Root

    #sudo cp -rv $ruta/Config/kitty /root/.config/

    echo -e "\n[+] Copia de configuracion de .p10k.zsh y .zshrc"

    rm -rf ~/.zshrc
    cp -v $ruta/.zshrc ~/.zshrc

    cp -v $ruta/.p10k.zsh ~/.p10k.zsh
    sudo cp -v $ruta/.p10k.zsh-root /root/.p10k.zsh

    echo -e "\n[+] colocando los Scripts de savi donde van jeje"

    sudo cp -v $ruta/scripts/whichSystem.py /usr/local/bin/
    sudo cp -v $ruta/scripts/screenshot /usr/local/bin/

    echo -e "\n[+] Plugins ZSH"

    sudo apt install -y zsh-syntax-highlighting zsh-autosuggestions
    sudo mkdir /usr/share/zsh-sudo
    cd /usr/share/zsh-sudo
    sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh


    echo -e "\n[+] Cambiando de SHELL a zsh"

    chsh -s /usr/bin/zsh
    sudo usermod --shell /usr/bin/zsh root
    sudo ln -s -fv ~/.zshrc /root/.zshrc
}

function utilsPermission (){
    echo -e "\n[+] Asignamos Permisos a los Scritps"

    chmod +x ~/.config/bspwm/bspwmrc
    chmod +x ~/.config/bspwm/scripts/bspwm_resize
    chmod +x ~/.config/bin/ethernet_status.sh
    chmod +x ~/.config/bin/htb_status.sh
    chmod +x ~/.config/bin/htb_target.sh
    chmod +x ~/.config/polybar/launch.sh
    sudo chmod +x /usr/local/bin/whichSystem.py

    echo -e "\n[+] Configuramos el Tema de Rofi"

    rofi-theme-selector

    echo -e "\n[+] Removiendo Repositorios"
    rm -rf ~/github
}

function nvimInstall (){

    #configuramos nvim
    cd ~/.config/nvim
    rm -r ~/.config/nvim
    git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
    cd /opt
    sudo cp $ruta/nvim-linux64.tar.gz .
    sudo tar -xf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz
    cd /opt/nvim-linux64/bin
    ./nvim
    sudo apt remove neovim
    cd
    user=$(pwd)
    
    sudo su
    cd
    cd ~/.config/nvim 
    rm -rf nvim
    cp -r $user/.config/nvim .
    nvim
    #dale a no 
    #si quieres quitar el $ en el nvim te metes en el archivo con nano ~/.config/nvim/lua/core/init.lua escribes la opcion vim.opt.list=false y listo.
}

let parameter_counter=0
while getopts "eh" arg; do
    case $arg in
        e) let parameter_counter+=1 ;;
        h) ;;
    esac
done

if [ "$(whoami)" == "root" ]; then
    exit 1
elif [ $parameter_counter -eq 1 ]; then
    updateSystem
    dependencies
    installRepositories
    filesConfiguration
    utilsPermission
    nvimInstall
    notify-send "BSPWM INSTALADO"
else
    helpPanel
fi    
