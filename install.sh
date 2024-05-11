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
    clear
    echo -e "\n${grayColour}Uso:${endColour}"
    echo -e "\t${blueColour}e)${endColour}${grayColour} Ejecutar script para modificacion del entorno${endColour}"
    echo -e "\t${blueColour}h)${endColour}${grayColour} panel de ayuda no es muy complejo solo ejecutar y estar atento a las interacciones del script con el usuario...${endColour}"
}

function updateSystem (){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Actualizando el sistema${endColour}"
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} el entorno es parrot o debian puro?${endColour}"&& read entorno
    while true; do
        if [ $entorno = parrot ]; then
            sudo apt update > /dev/null 2>&1
            sudo parrot-upgrade > /dev/null 2>&1
            break
        elif [ $entorno = debian ]; then
            sudo apt update > /dev/null 2>&1 
            sudo apt upgrade > /dev/null 2>&1
            break
        else 
            echo -e "\n${redColour}[!] unicamente se puede responder con parrot o debian en minusculas${endColour}"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} el entorno es parrot o debian puro?${endColour}"&& read entorno 
        fi
    done
}

function dependencies (){
    echo -e "${yellowColour}[+]${endColour}${grayColour} Instalando dependencias de Entorno${endColour}"
    sleep 1
    sudo apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev

    echo -e "${yellowColour}[+]${endColour}${grayColour} Instalando Requerimientos para la polybar${endColour}"
    sleep 1
    sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev 

    echo -e "${yellowColour}[+]${endColour}${grayColour} Dependencias de Picom${endColour}"
    sleep 1
    sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev
    
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Instalamos paquetes adicionales${endColour}"
    sleep 1
    sudo apt install -y feh scrot scrub zsh rofi xclip bat locate neofetch wmname acpi bspwm sxhkd imagemagick ranger kitty thunar telnet krusader baobab flameshot ipcalc npm
#nm-connection-editor para gestionar tarjeta de red.
}
# Creando carpeta de Reposistorios
function installRepositories () {
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Creando Carpeta de Repositorios${endColour}"
    mkdir ~/github

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargar Repositorios Necesarios${endColour}"
    sleep 1
    clear
    cd ~/github
    git clone --recursive https://github.com/polybar/polybar
    git clone https://github.com/ibhagwan/picom.git

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Instalando Polybar${endColour}"
    
    sleep 1
    clear
    cd ~/github/polybar
    mkdir build
    cd build
    cmake ..
    make -j$(nproc)
    sudo make install

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Instalando Picom${endColour}"

    cd ~/github/picom
    clear
    git submodule update --init --recursive
    meson --buildtype=release . build
    ninja -C build
    sudo ninja -C build install

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Instalando p10k${endColour}"
    
    sleep 1 
    clear
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
    echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Instalando p10k root${endColour}"

    sleep 1 
    clear
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k
    mkdir -p ~/.config/rofi/themes
    cp $ruta/rofi/nord.rasi ~/.config/rofi/themes/

    echo -e "\n${yellowColour}[+]${endColour} Instando lsd"

    sleep 1 
    clear
    sudo dpkg -i $ruta/lsd.deb

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Instalamos las HackNerdFonts"

    sleep 1 
    clear

    sudo cp -v $ruta/fonts/HNF/* /usr/local/share/fonts/

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Instalando Fuentes de Polybar${endColour}"

    sleep 1 
    clear

    sudo cp -v $ruta/Config/polybar/fonts/* /usr/share/fonts/truetype/

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Instalando Wallpaper personal (despues puedes modificar si quieres...)${endColour}"
    
    sleep 1 
    clear
    mkdir ~/Wallpaper
    cp -v $ruta/Wallpaper/* ~/Wallpaper
}

function filesConfiguration (){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Copiando Archivos de Configuración${endColour}"
    sleep 1 
    clear

    cp -rv $ruta/Config/* ~/.config/


    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Copia de configuracion de .p10k.zsh y .zshrc${endColour}"

    sleep 1
    rm -rf ~/.zshrc
    cp -v $ruta/.zshrc ~/.zshrc

    cp -v $ruta/.p10k.zsh ~/.p10k.zsh
    sudo cp -v $ruta/.p10k.zsh-root /root/.p10k.zsh

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} colocando los Scripts de savi donde van jeje${endColour}"

    sleep 1
    sudo cp -v $ruta/scripts/whichSystem.py /usr/local/bin/
    sudo cp -v $ruta/scripts/screenshot /usr/local/bin/

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Plugins ZSH${endColour}"
    sleep 1
    sudo apt install -y zsh-syntax-highlighting zsh-autosuggestions
    sudo mkdir /usr/share/zsh-sudo
    cd /usr/share/zsh-sudo
    sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh


    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Cambiando de SHELL a zsh${endColour}"
    sleep 1
    chsh -s /usr/bin/zsh
    sudo usermod --shell /usr/bin/zsh root
    sudo ln -s -fv ~/.zshrc /root/.zshrc
}

function utilsPermission (){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Asignamos Permisos a los Scripts${endColour}"

    chmod +x ~/.config/bspwm/bspwmrc
    chmod +x ~/.config/bspwm/scripts/bspwm_resize
    chmod +x ~/.config/bin/ethernet_status.sh
    chmod +x ~/.config/bin/htb_status.sh
    chmod +x ~/.config/bin/htb_target.sh
    chmod +x ~/.config/polybar/launch.sh
    sudo chmod +x /usr/local/bin/whichSystem.py

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Configuramos el Tema de Rofi${endColour}"

    rofi-theme-selector

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Removiendo Repositorios${endColour}"
    rm -rf ~/github
}

function nvimInstall (){

    #configuramos nvim
    cd ~/.config/nvim
    sudo rm -r ~/.config/nvim
    git clone https://github.com/NvChad/starter ~/.config/nvim 
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
    sudo rm -rf nvim
    cp -r $user/.config/nvim .
    nvim
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser
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
