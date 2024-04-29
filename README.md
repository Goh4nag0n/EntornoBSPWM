# EntornoBSPWM

Descripción
Este script en Bash está diseñado para automatizar la configuración del entorno de BSPWM (Binary Space Partitioning Window Manager) en sistemas basados en Debian, como Parrot OS y Debian puro. Proporciona funciones para actualizar el sistema, instalar dependencias, clonar repositorios necesarios, configurar herramientas como Polybar y Picom, y establecer configuraciones de archivos.

***

Funciones del Script
updateSystem: Esta función actualiza los paquetes del sistema dependiendo de si el entorno es Parrot o Debian, utilizando los comandos apt update y apt upgrade.
dependencies: Instala las dependencias necesarias para el entorno de BSPWM y herramientas adicionales como Polybar, Picom, etc., utilizando el comando apt install.
installRepositories: Configura las carpetas de repositorios necesarias, clona los repositorios de Polybar y Picom desde GitHub, y los compila e instala.
filesConfiguration: Copia archivos de configuración a las ubicaciones adecuadas, configura Zsh con plugins y temas, y cambia el shell predeterminado a Zsh.
utilsPermission: Asigna permisos adecuados a los scripts y configura el tema de Rofi.
nvimInstall: Instala y configura Neovim, y realiza configuraciones adicionales.
