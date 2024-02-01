#!/bin/bash

#---------------------------------
#	CONFIGURACIÓN DE SERVICIOS
#---------------------------------
#	Condiciones de Instalacion
min_HDD=58 	# Valores en Gigabytes
min_RAM=8	# Valores en Gigabytes
aceptable_SO=("Ubuntu")
aceptable_version_ubuntu=("22.04" "")
aceptable_version_debian=("" "")

#	Tiempo de Pausas entre mensajes
pausa_larga=1
pausa_corta=$pausa_larga

#   Colores de instalación
amarillo='\033[1;33m'
cian_claro='\033[1;36m'
boton_error='\033[1;41m'
boton_correcto='\033[1;44m'
verde='\033[7;32m'
reset='\033[0m'
sub='\033[4m'
negr='\033[1m'
fondoblanco='\033[0;47m'

#	Detectar Sistema
if [ -e /etc/os-release ]; then
    source /etc/os-release
	sistema_operativo=$ID
	sistema_version=$VERSION_ID
else
    sistema_operativo = "null";
fi

<<COMMENT
*********************************************************************
[:::::::::::::::		SISTEMA LUFFY   					::::::::]
*********************************************************************
Cargar con sudo ./install_multi.sh
Por prevención, siempre suba estos archivos a su directorio de usuario /home

Sistema luffy es un sistema que permite instalar un servidor funcional
completo. Es open source.
El siguiente SCRIPT es y ha sido testeado en los siguientes 
sistemas operativos:
*********************************************************************
SERVERS:
*   UBUNTU SERVER 22.04 LTS

TECNOLOGIAS:
*   PROXIMAMENTE
*****************************************************************
COMMENT
#---------------------------------
#	LOGO FIBERCAT
#---------------------------------
clear

echo -e "${cian_claro}⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
'########:'####:'########::'########:'########:::'######:::::'###::::'########:
 ##.....::. ##:: ##.... ##: ##.....:: ##.... ##:'##... ##:::'## ##:::... ##..::
 ##:::::::: ##:: ##:::: ##: ##::::::: ##:::: ##: ##:::..:::'##:. ##::::: ##::::
 ######:::: ##:: ########:: ######::: ########:: ##:::::::'##:::. ##:::: ##::::
 ##...::::: ##:: ##.... ##: ##...:::: ##.. ##::: ##::::::: #########:::: ##::::
 ##:::::::: ##:: ##:::: ##: ##::::::: ##::. ##:: ##::: ##: ##.... ##:::: ##::::
 ##:::::::'####: ########:: ########: ##:::. ##:. ######:: ##:::: ##:::: ##::::
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	         			        NETWORKS SPA 2024
${cian_claro}INSTALACION LUFFY SERVER${reset}"
sleep $pausa_corta

#---------------------------------
#	LOGO SERVER
#---------------------------------

echo "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⢻⣿⣻⣿⡾⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢻⣷⢛⣯⣽⣷⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣹⡇⡿⣿⢿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣹⣧⢻⡞⣟⢻⢿⣻⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠍⡇⣿⢻⡾⣧⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠹⠾⠟⠃⠛⠉⠉⠈⠀⠤⠙⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠠⠐⠜⣸⣧⡿⡎⣿⡿⣿⣿⡿⠿⠿⠟⠛⠛⡉⠉⠉⠁⡀⠀⠄⠠⢀⠠⠀⠂⡀⢁⠢⣈⣕⣿⣿⠻⣾⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠈⠇⠓⠈⠈⠀⠁⠀⠀⡀⠠⢀⠂⡐⠠⠁⠌⡐⠠⠁⢈⠀⠄⣀⠂⣁⣬⣶⣿⣿⡥⣿⣯⣤⣞⣿⢯
⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠄⡀⠁⠄⡐⢀⠂⠡⠀⠄⠐⢀⣢⣬⠴⣶⣿⣿⣿⣿⣿⣿⡶⣍⢦⡉⠈⠈⠃
⣿⣿⣿⣿⣿⡿⢿⡻⢝⣒⣟⣻⣭⣩⡠⠠⣄⡀⠀⠀⠈⠀⠄⠁⢂⣐⣀⣬⣤⣶⣶⣿⠖⢿⣗⡩⢿⣏⡉⠙⠻⠋⠃⠙⠈⠀⣀⣠⣴⣶
⠿⠛⠋⠑⣤⣾⣶⠿⠛⠉⠋⠀⠉⠀⠀⠘⠛⠻⢖⡀⠦⠅⠂⢨⣹⣿⣿⡿⣿⣿⣿⣧⠔⠚⡿⡖⠉⠈⠐⠀⠀⠀⠀⠀⠀⠀⢈⣻⣿⣿
⠀⢀⣢⠎⣹⣇⣰⣿⣿⣯⣀⠁⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣶⣿⣿⣷⠀⠈⡝⠣⠀⠂⠉⠀⠀⠀⠀⠀⠀⠀⠠⠒⠀⠀⠀⠈⣿⣿⣿
⢀⣾⣿⣶⣿⣿⣿⣿⣿⠛⢿⣶⣄⡀⠀⠀⠀⠀⠀⠉⠉⠈⠛⠙⠉⠂⠁⠉⢀⣀⣀⠀⠀⠀⠀⠀⠀⣀⠦⠀⠀⠀⠀⠀⠠⣄⣳⣿⣿⣿
⣼⣿⣿⣿⣿⣿⣿⢿⡁⠀⠀⠈⠉⠁⠁⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠐⢿⣿⣿⣿⣿⣷⣶⣦⣿⠉⠘⠀⠀⠀⠀⠀⢠⣄⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⡿⡝⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⣦⣄⣴⣴⣾⣷⡄⠀⠀⣳⣼⣿⣿⣿⣿⣿⣿⠷⠀⠀⠀⠀⠀⣀⣴⣾⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⢯⡗⡀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢀⠀⢻⣿⣿⣿⣿⣿⣿⣿⠾⠿⠿⠿⠿⢿⣿⣿⣿⡖⠀⠀⠀⠀⣡⣼⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⢯⢟⡘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⢿⣿⡿⢉⣡⣶⡿⠿⠿⠿⣿⣷⣶⣤⠟⠘⠀⠀⠀⠠⢿⣿⣿⡿⠿⠿⠛⠋⠉⠀
⣿⡳⣏⠞⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⣾⣿⣿⣿⣷⣤⣀⣀⣤⣾⡿⢿⠉⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠳⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⠿⣿⣿⣿⢿⡟⠯⠙⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠁⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢠⣴⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⡀⠀⣀⠀⠀⠀⠀⣠⣴⣿⣟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠿⠟⠿⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣻⣟⡷⠀⢫⣷⣶⣶⢿⡟⣯⢗⠊⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣯⢻⡜⡄⠀⢿⣾⡽⣾⡹⢧⠣⠀⣚⡴⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⡭⢷⡘⠀⠀⠸⣷⡻⣖⡏⢇⠃⠀⣧⠳⡉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⠳⣝⢢⠑⠀⠀⠀⢻⣝⢧⡚⠡⠀⢰⣡⠓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"

sleep $pausa_corta

#---------------------------------
#	REVISIÓN DE SEGURIDAD
#---------------------------------

echo -e "${verde}I PARTE: REVISIÓN DE SEGURIDAD${reset}"
sleep $pausa_corta

echo -e "${cian_claro}${sub}
Requisitos de Hardware y OS${reset}"

# OBTENEMOS EL TAMAÑO DE DISCO EN /
HDD_tamano_actual=$(df -B 1M --output=size / | tail -n 1 | awk '{print $1}')
HDD_tamano_actual=$(echo "scale=2; $HDD_tamano_actual/1024" | bc)

if [ "$(echo "$HDD_tamano_actual >= $min_HDD" | bc -l)" -eq 1 ]; then
	echo -e "El tamaño de Disco ($HDD_tamano_actual) es mayor o igual a ${min_HDD}G. ${boton_correcto}${cian_claro}CORRECTO${reset}"
else
	echo -e "El tamaño de Disco ($HDD_tamano_actual) es menor a ${min_HDD}G. ${boton_error}${amarillo}ERROR${reset}"
	echo "No podemos continuar con la instalación"
	exit
fi

sleep $pausa_corta

# OBTENEMOS EL TAMAÑO DE RAM
RAM_tamano_actual=$(free --mega | awk '/Mem:/ {print $2}' | tr -d '[:alpha:]')
RAM_tamano_actual=$(echo "scale=2; $RAM_tamano_actual/1024" | bc)

if [ "$(echo "$RAM_tamano_actual >= $min_RAM" | bc -l)" -eq 1 ]; then
	echo -e "El tamaño de Disco ($RAM_tamano_actual) es mayor o igual a ${min_RAM}G. ${boton_correcto}${cian_claro}CORRECTO${reset}"
else
	echo -e "El tamaño de Disco ($RAM_tamano_actual) es menor a ${min_RAM}G. ${boton_error}${amarillo}ERROR${reset}"
	echo "No podemos continuar con la instalación"
	exit
fi

sleep $pausa_corta

# OBTENEMOS EL SISTEMA OPERATIVO
actual_SO=$(lsb_release -is)
actual_version=$(lsb_release -rs)

# Función para imprimir un mensaje de error y salir
error_y_salir() {
    echo -e "${boton_error}${amarillo}ERROR${reset} El sistema operativo instalado ($actual_SO $actual_version) por ahora no son compatibles con Fibercat Luffy."
    exit 1
}

# Verificar el sistema operativo
if [[ ! " ${aceptable_SO[@]} " =~ " $actual_SO " ]]; then
    error_y_salir
fi

# Verificar la versión según el sistema operativo
case $actual_SO in
    "Ubuntu")
        if [[ ! " ${aceptable_version_ubuntu[@]} " =~ " $actual_version " ]]; then
            error_y_salir
        fi
        ;;
    "Debian")
        if [[ ! " ${aceptable_version_debian[@]} " =~ " $actual_version " ]]; then
            error_y_salir
        fi
        ;;
    *)
        error_y_salir
        ;;
esac

# Si llegamos aquí, el sistema operativo y la versión son correctos
echo -e "El sistema operativo ($actual_SO $actual_version) cumplen con los requisitos mínimos. ${boton_correcto}${cian_claro}CORRECTO${reset}"

sleep $pausa_corta

######################## VERSION 0.2 ########################

# PRIVILEGIOS

echo -e "${cian_claro}${sub}
Verificar privilegios${reset}"

# Verificar si el usuario actual es root
if [ "$EUID" -eq 0 ]; then
    echo -e "El usuario actual tiene privilegios ${amarillo}root${reset}. ${boton_correcto}${cian_claro}CORRECTO${reset}"
else
    echo -e "${boton_error}${amarillo}ERROR${reset} El usuario actual no posee privilegios ${amarillo}root${reset}. Por favor, utilice sudo para instalar."
    exit
fi

sleep $pausa_corta

# CHECKING DE ARCHIVOS AUXILIARES
echo -e "${cian_claro}${sub}
Verificar archivos de configuración escenciales${reset}"

# Cargamos la configuración de config.cfg
if [[ -f "config.cfg" ]]; then
    echo -e "${amarillo}config.cfg${reset} se encuentra presente. ${boton_correcto}${cian_claro}CORRECTO${reset}"
    source "config.cfg"
else
    echo -e "${boton_error}${amarillo}ERROR${reset} No se encontró el archivo de configuración (config.cfg)."
    echo -e "${amarillo}Puede descargar una copia del archivo config.cfg desde https://github.com/kissableandres/Fibercat-Luffy ${reset}"
    exit 1
fi

sleep $pausa_corta

# Cargamos la configuración de ssh_key.cfg
if [[ -f "ssh_key.cfg" ]]; then
    echo -e "${amarillo}ssh_key.cfg${reset} se encuentra presente. ${boton_correcto}${cian_claro}CORRECTO${reset}"
    source "ssh_key.cfg"
else
    echo -e "${boton_error}${amarillo}ERROR${reset} No se encontró el archivo de configuración (ssh_key.cfg)."
    echo -e "${amarillo}Puede descargar una copia del archivo ssh_key.cfg desde https://github.com/kissableandres/Fibercat-Luffy ${reset}"
    exit 1
fi

sleep $pausa_corta

echo -e "
${verde}II PARTE: INSTALACIÓN DE SISTEMA BASE${reset}"
sleep $pausa_corta

# CREACIÓN DE DIRECTORIOS
echo -e "${cian_claro}${sub}
Creando Directorios de sistema${reset}"

<<COMMENT
A continuación, declararemos un array que contendrán las rutas de los directorios.
La aplicación verificará que estén creados y, de no ser así, los creará.
Verifica que cada directorio tenga una separación de un espacio como mínimo.
$SERVERDIRECTORY lo debemos obtener del archivo config. Por defecto, se llamara
fibercat_luffy.

	"/$SERVERDIRECTORY"             Contiene todos los archivos de sistema.
	"/$SERVERDIRECTORY/www"         Contiene la salida www a travésdel puerto 8080.
	"/$SERVERDIRECTORY/installed"   Contiene los logs de salida de instalación.
	"/$SERVERDIRECTORY/ssl"         Contiene los certificados ssl de la maquina
	"/$SERVERDIRECTORY/logs"        Continene los logs
    "/$SERVERDIRECTORY/logs/system" Contiene los logs del sistema
COMMENT

declare -a dirs=(
	"/$SERVERDIRECTORY"
	"/$SERVERDIRECTORY/www"
	"/$SERVERDIRECTORY/installed"
	"/$SERVERDIRECTORY/ssl"
	"/$SERVERDIRECTORY/logs"
	"/$SERVERDIRECTORY/logs/system"
)

for dir in "${dirs[@]}"
do
	# Verificar si el directorio existe | Check if the directory exists
	if [ -d "$dir" ]; then
        sleep $pausa_corta
		echo -e "El directorio ${amarillo}$dir${reset} existe. ${boton_correcto}${cian_claro}CORRECTO${reset}"
	else
		# Crear el directorio y mostrar un mensaje | Create the directory and display a message.
		mkdir "$dir"
		echo -e "El Directorio ${amarillo}$dir${reset} ha sido creado. ${boton_correcto}${cian_claro}CORRECTO${reset}"
        sleep $pausa_corta
	fi
done

sleep $pausa_corta

# ACTUALIZACIÓN INICIAL DEL SISTEMA

echo -e "${cian_claro}${sub}
Verificando Actualizaciones${reset}"

    echo -e "${cian_claro}${sub}
Actualización de Repositorios${reset}"

FILE_INSTALLED_NAME="01-update"
if [[ -f /$SERVERDIRECTORY/installed/$FILE_INSTALLED_NAME ]]
then
	echo -e "No volveremos a actualizar los repositorios. ${boton_correcto}${cian_claro}CORRECTO${reset}"
else
	apt-get update -y 2>&1 | tee /$SERVERDIRECTORY/installed/$FILE_INSTALLED_NAME
	echo -e "Se han actualizado los repositorios. ${boton_correcto}${cian_claro}CORRECTO${reset}"
fi

    echo -e "${cian_claro}${sub}
Actualización de Aplicaciones${reset}"

FILE_INSTALLED_NAME="02-upgrade"
if [[ -f /$SERVERDIRECTORY/installed/$FILE_INSTALLED_NAME ]]
then
	echo -e "No volveremos a actualizar aplicaciones. ${boton_correcto}${cian_claro}CORRECTO${reset}"
else
	apt-get upgrade -y 2>&1 | tee /$SERVERDIRECTORY/installed/$FILE_INSTALLED_NAME
	echo -e "Se han actualizado las aplicaciones. ${boton_correcto}${cian_claro}CORRECTO${reset}"
fi

sleep $pausa_corta

# LOCALES
echo -e "${cian_claro}${sub}
Actualizar Soporte Idioma Local${reset}"

FILE_INSTALLED_NAME="03-locales"
if [[ -f /$SERVERDIRECTORY/installed/$FILE_INSTALLED_NAME ]]
then
    echo -e "El soporte para español ya ha sido instalado. ${boton_correcto}${cian_claro}CORRECTO${reset}"
else
    apt-get install language-pack-es -y 2>&1 | tee /$SERVERDIRECTORY/installed/$FILE_INSTALLED_NAME
    sudo update-locale LANG=$LOCALES
    echo -e "El soporte para español se ha sido instalado con exito. ${boton_correcto}${cian_claro}CORRECTO${reset}"
fi

# HORA
echo -e "${cian_claro}${sub}
Actualizar Zona Horaria${reset}"

TIME=$(cat /etc/timezone);
if [[ $TIME == "$TIMEZONE" ]]
then
	echo -e "La zona horaria solicitada ($TIMEZONE) ya es $TIME. ${boton_correcto}${cian_claro}CORRECTO${reset}"
else
    timedatectl set-timezone $TIMEZONE
	echo -e "Se ha reemplazado $TIME a $TIMEZONE. ${boton_correcto}${cian_claro}CORRECTO${reset}"
fi

# FIREWALL

# Verificar firewall
echo -e "${cian_claro}${sub}
Verificando la instalación del Firewall (UFW)${reset}"

FILE_INSTALLED_NAME="04-firewall"
if [[ -f /$SERVERDIRECTORY/installed/$FILE_INSTALLED_NAME ]]
then
	echo -e "Ya existe el Firewall (UFW) en el sistema. ${boton_correcto}${cian_claro}CORRECTO${reset}"
else
    if ! command -v ufw &> /dev/null; then
        echo "UFW no está instalado. Instalando..."
        sudo apt-get install -y ufw -y 2>&1 | tee /$SERVERDIRECTORY/installed/$FILE_INSTALLED_NAME
        echo -e "UFW instalado correctamente. ${boton_correcto}${cian_claro}CORRECTO${reset}"
    else
        echo "Ok">>/$SERVERDIRECTORY/installed/$FILE_INSTALLED_NAME
        echo -e "Ya existe el Firewall (UFW) en el sistema. ${boton_correcto}${cian_claro}CORRECTO${reset}"
    fi
fi

# Activar OpenSSH
echo -e "${cian_claro}${sub}
Autorizando OpenSSH y Activando UFW${reset}"

# Verificar si UFW ya está activado
if ! sudo ufw status | grep -q "Estado: activo"; then
    echo -e "${amarillo}Activando OpenSSH en UFW...${reset}"
    sudo ufw allow 22
    echo -e "${amarillo}Iniciando UFW...${reset}"
    sudo ufw --force enable
    echo -e "UFW iniciado y OpenSSH permitido. ${boton_correcto}${cian_claro}CORRECTO${reset}"
else
    echo -e "UFW ya está activado en el sistema. ${boton_correcto}${cian_claro}CORRECTO${reset}"
    echo -e "${amarillo}Activando OpenSSH en UFW...${reset}"
    sudo ufw allow OpenSSH
    echo -e "OpenSSH permitido. ${boton_correcto}${cian_claro}CORRECTO${reset}"
fi
