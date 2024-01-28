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
${reset}                        
INSTALACION LUFFY SERVER
"
sleep $pausa_larga

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

sleep $pausa_larga

#---------------------------------
#	REVISIÓN DE SEGURIDAD
#---------------------------------

echo -e "${verde}I PARTE: REVISIÓN DE SEGURIDAD${reset}"
sleep $pausa_corta

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
