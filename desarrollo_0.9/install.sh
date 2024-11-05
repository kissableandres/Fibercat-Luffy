#!/bin/bash

###################################################################
#							INICIO
###################################################################
#	00	INFORMACIÓN
#	01	VARIABLES DE CONFIGURACIÓN
#	02	FUNCIONES GENERALES
###################################################################

#------------------------------------------------------------------
#		00)	INFORMACIÓN
#------------------------------------------------------------------
#	Soporte para Ubuntu 22.04
#	Soporte para DigitalOcean Standard
echo -e "\033[1;32m\033[4m INICIO INSTALACIÓN SERVER \033[0m"
echo -e "\033[1;32m SERVIDOR: \033[1;33mUBUNTU SERVER 22.04 \033[0m"
echo -e "\033[1;32m SERVICIOS: \033[1;33mDIGITAL OCEAN \033[0m"
echo "Presiona cualquier tecla para continuar..."
# Espera a que el usuario presione cualquier tecla
#read -n 1 -s -r

#------------------------------------------------------------------
#		01)	VARIABLES DE CONFIGURACIÓN
#------------------------------------------------------------------
source 01_vars.sh

#------------------------------------------------------------------
#		02)	FUNCIONES DE TEXTO Y MENSAJERÍA
#------------------------------------------------------------------
#	do_points 	$MSG (String) $LOG (Boolean) $LOG_MSG (String)
#		do_btn_ok
#		do_btn_error
#	do_message	$MSG (String) $LOG (Boolean) $STATUS (Boolean) $LOG_MSG (String)
#	log			$MSG (String) $DATED (Boolean)
#	error		$MSG (String)
#	subtitle	$MSG (String)
#	title		$MSG (String)
#------------------------------------------------------------------
source 02_func_msg.sh

#------------------------------------------------------------------
#		03)	FUNCIONES DE ARCHIVOS
#------------------------------------------------------------------
#	create_dir	$DIRECTORY (String) $PERMISSIONS (Integer) $OWNER (String) $GROUP (String)
#	review_crlf	$FILE (String)
#	file_exists	$FILE (String)
#	copy_file	$FILE (String) $DESTINY (String)
#------------------------------------------------------------------
source 03_func_files.sh

#------------------------------------------------------------------
#		04)	FUNCIONES DE MANIPULACION DE CONTENIDO EN ARCHIVOS
#------------------------------------------------------------------
#	variable_exists 	$FILE (String) $VARIABLE (String) $SEPARATOR (String)
#	get_variable_value	$FILE (String) $VARIABLE (String) $SEPARATOR (String)
#	update_value		$FILE (String) $VARIABLE (String) $SEPARATOR (String) $QUOTES (Boolean) $NEW_VALUE (String)	
#	add_value			$FILE (String) $FULL_VARIABLE (String)
#	delete_value		$FILE (String) $VARIABLE (String) $SEPARATOR (String)
#	load_vars 			$FILE (String)
#	is_commented		$FILE (String) $COMMENT (String) $TEXT (String)
#	uncomment			$FILE (String) $COMMENT (String) $TEXT (String)		
#------------------------------------------------------------------
source 04_func_content_handler.sh

#------------------------------------------------------------------
#		05)	FUNCIONES DE EJECUCION DE TAREAS ESTANDAR
#------------------------------------------------------------------
#	review_package		$PACKAGE (String)
#	install_package		$PACKAGE (String)
#	uninstall_package	$PACKAGE (String)
#	do_script			$SCRIPT (String)
#------------------------------------------------------------------
source 05_func_tasks.sh

clear

#------------------------------------------------------------------
#		06) ES ROOT?
#------------------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
	error "Este script debe ejecutarse como root"
fi

#------------------------------------------------------------------
#		07) ARCHIVO LOG
#------------------------------------------------------------------

# [Eliminamos el log]

if [ "$acumulative_log" = false ]; then
	title "Preparando la instalación false"
	subtitle "Preparando el Log"
	do_message "Eliminando el log" false true
	rm "$install_temp/$logfile"
else
	title "Preparando la instalación true"
	subtitle "Preparando el Log"
	do_message "Log no eliminado" false true "La configuración de acumulative_log es $acumulative_log por lo que el log NO se eliminará."
fi

#------------------------------------------------------------------
#		08) ARCHIVOS DE CONFIGURACIÓN
#------------------------------------------------------------------
subtitle "Archivos de Configuración"

load_vars "$install_temp/config.cfg"
load_vars "$install_temp/ssh_key.cfg"

#------------------------------------------------------------------
#		09)	LOGOS
#------------------------------------------------------------------
subtitle "Logos"

# Verificar el valor de CFG_SHOWLOGO
if [ "$CFG_SHOWLOGO" -eq 1 ]; then

	echo -e "${yellow}
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
'########:'####:'########::'########:'########:::'######:::::'###::::'########:
##.....::. ##:: ##.... ##: ##.....:: ##.... ##:'##... ##:::'## ##:::... ##..::
##:::::::: ##:: ##:::: ##: ##::::::: ##:::: ##: ##:::..:::'##:. ##::::: ##::::
######:::: ##:: ########:: ######::: ########:: ##:::::::'##:::. ##:::: ##::::
##...::::: ##:: ##.... ##: ##...:::: ##.. ##::: ##::::::: #########:::: ##::::
##:::::::: ##:: ##:::: ##: ##::::::: ##::. ##:: ##::: ##: ##.... ##:::: ##::::
##:::::::'####: ########:: ########: ##:::. ##:. ######:: ##:::: ##:::: ##::::
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
				NETWORKS SPA 2024\n${reset}"

#	Definir la velocidad de los puntos suspensivos
if [ "$fast_setup" = true ]; then
	DELAY=0
else
	DELAY=$CFG_PAUSE
fi

sleep $DELAY

	echo -e "${negrita}⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
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
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⠳⣝⢢⠑⠀⠀⠀⢻⣝⢧⡚⠡⠀⢰⣡⠓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${reset}
"
	log "☑ La configuración CFG_SHOWLOGO es $CFG_SHOWLOGO por lo que SE MOSTRÓ el Logo."
else
	echo -e "${msg_atention}[NO SE MUESTRA LOGO]${reset}"
	log "☑ La configuración CFG_SHOWLOGO es $CFG_SHOWLOGO por lo que no se muestra el Logo."
fi

sleep $DELAY

###################################################################
#				Mantención de Usuario Root y Sudoer
title "Mantención de Usuario Root y Sudoer"
###################################################################

#------------------------------------------------------------------
#		10) CREACIÓN USUARIO SUDOER (DIGITAL OCEAN SUPPORT)
#------------------------------------------------------------------
subtitle "Creación de Usuario Sudoer"

if id "$CFG_SUDOUSER" &>/dev/null; then
	do_points "El usuario $CFG_SUDOUSER existe"
	do_btn_ok
else
	do_points "Creando Grupo $CFG_SUDOUSER"
	sudo groupadd "$CFG_SUDOGROUP"
	do_btn_ok

	do_points "Creando Usuario Sudoer $CFG_SUDOUSER"
	sudo useradd -m -s /bin/bash -g "$CFG_SUDOGROUP" "$CFG_SUDOUSER"
	echo "$CFG_SUDOUSER:$CFG_SUDOUSERPWD" | sudo chpasswd
	do_btn_ok

	do_points "Agregando al usuario $CFG_SUDOUSER a la lista de Sudoers"
	do_btn_ok
	adduser $CFG_SUDOUSER sudo

	do_message "El usuario $CFG_SUDOUSER se ha creado y se ha agregado a los sudoers." true true
fi

#------------------------------------------------------------------
#		11) SHELL ROOT & CFG_SUDOUSER (DIGITAL OCEAN SUPPORT)
#------------------------------------------------------------------
subtitle "Cambio de SHELL"
change_shell "root"
change_shell "$CFG_SUDOUSER"

#------------------------------------------------------------------
#		12) PS1 ROOT
#------------------------------------------------------------------
subtitle "Aplicar PS1 personalizados"
change_PS1 "root" "/root/.bashrc"
change_PS1 "$CFG_SUDOUSER" "/home/$CFG_SUDOUSER/.bashrc"

###################################################################
#				Mantención de Sistema
title "Mantención Inicial del sistema"
###################################################################

#------------------------------------------------------------------
#		13)	CONFIGURACIÓN DE HORA LOCAL
#------------------------------------------------------------------
subtitle "Configurando Zona Horaria"

# Verificar el valor de CFG_TIMEZONE
TIME=$(cat /etc/timezone);

if [[ $TIME == "$TIMEZONE" ]]; then
	do_points "La zona horaria solicitada ($TIMEZONE) ya es $TIME."
else
	do_points "Reemplazado $TIME (Actual) por $TIMEZONE (DIRECTIVA TIMEZONE)."
	timedatectl set-timezone $TIMEZONE
fi
do_btn_ok

#------------------------------------------------------------------
#		14)	DIRECTORIO DE RESTAURACIÓN
title "Instalando Directorios"
#------------------------------------------------------------------

subtitle "Verificando Directorio de restauración '$CFG_RESCUEDIRECTORY'"

if [ ! -d "/$CFG_RESCUEDIRECTORY" ]; then
	do_points "El directorio /$CFG_RESCUEDIRECTORY se está creando."
	create_dir "/$CFG_RESCUEDIRECTORY"
	do_btn_ok
else
	do_message "El directorio /$CFG_RESCUEDIRECTORY ya esta creado." true
fi

#------------------------------------------------------------------
#		15)	DIRECTORIO DE SISTEMA
#------------------------------------------------------------------
subtitle "Verificando Directorio Principal /$CFG_SERVERDIRECTORY"

#	Verificamos la existencia de los directorios
if [ ! -d "/$CFG_SERVERDIRECTORY" ]; then
	do_points "El directorio /$CFG_SERVERDIRECTORY se está creando."
	create_dir "/$CFG_SERVERDIRECTORY"
	do_btn_ok
else
	if [ "$CFG_RECREATE" -eq 1 ]; then
		do_points "Respaldando directorios actuales"
		
		fecha=$(date +%d-%m-%Y_%H-%M)
		origen="/$CFG_SERVERDIRECTORY"
		destino="/$CFG_RESCUEDIRECTORY/${fecha}_$CFG_SERVERDIRECTORY"
		cp -ar "$origen" "$destino"
		
		do_btn_ok

		do_points "El directorio /$CFG_SERVERDIRECTORY se está eliminando."
		rm -r "/$CFG_SERVERDIRECTORY"
		do_btn_ok	

		do_points "El directorio /$CFG_SERVERDIRECTORY se está creando."
		create_dir "/$CFG_SERVERDIRECTORY"
		do_btn_ok
	else
		do_message "El directorio /$CFG_SERVERDIRECTORY ya esta creado." true
	fi
fi

#------------------------------------------------------------------
#		16)	SUBDIRECTORIOS DE INSTALACIÓN
#------------------------------------------------------------------
subtitle "Creando subdirectorios de sistema"

#	Declaramos los directorios.
declare -a dirs=(
	"/$CFG_SERVERDIRECTORY/backups"
	"/$CFG_SERVERDIRECTORY/logs"
	"/$CFG_SERVERDIRECTORY/ssl"		
	"/$CFG_SERVERDIRECTORY/www"
)

#	Creación de Directorios
for dir in "${dirs[@]}"
do	
	#	Verificamos la existencia de los directorios
	if [ ! -d "$dir" ]; then
		do_points "El directorio $dir se está creando."
		do_btn_ok
		create_dir "$dir"
	else
		do_points "El directorio $dir está creado."
	fi
done

#------------------------------------------------------------------
#		17)	NEEDRESTART (UBUNTU)
title "Actualizaciones"
#------------------------------------------------------------------
subtitle "Verificando Needstart"

do_points "Verificando la directiva Needstart"
do_btn_ok
uncomment "/etc/needrestart/needrestart.conf" "#" "\$nrconf{restart}"
update_value "/etc/needrestart/needrestart.conf" "\$nrconf{restart}" " = " false "'a';"	





















exit
#------------------------------------------------------------------
#		18)	UPDATE
#------------------------------------------------------------------
subtitle "Actualizando repositorios"

#	Verificamos existencia
file_exists	"$CFG_SERVERDIRECTORY/last_update"
take_function_value=$?

if [ "$take_function_value" -eq 0 ]; then
	# Obtener el timestamp actual y el de la última actualización
	CURRENT_TIME=$(date +%s)
	LAST_UPDATE_TIME=$(cat "$LAST_UPDATE_FILE")	
	# Calcular la diferencia de tiempo
	TIME_DIFF=$((CURRENT_TIME - LAST_UPDATE_TIME))

	if [ "$TIME_DIFF" -gt "$UPDATE_INTERVAL" ]; then
		# Si han pasado más de 10 minutos, ejecutar la actualización
		do_message "Actualizando Repositorios"

		#	Definir la velocidad de los puntos suspensivos
		if [ "$fast_setup" = true ]; then
			DELAY=0
		else
			DELAY=$((CFG_PAUSE + 2))  # Uso de aritmética en Bash
		fi

		sleep $DELAY

		subtitle "Actualizando repositorios"
		do_message "Actualizando Repositorios"

		do_script "apt update -y"

		subtitle "Actualizando Aplicaciones"

		do_message "Actualizando Aplicaciones"
		do_script "apt upgrade -y"

		# Actualizar el archivo con el nuevo timestamp
		echo "$CURRENT_TIME" > "$LAST_UPDATE_FILE"
	else
		# Si no han pasado 10 minutos, mostrar un mensaje
		echo "Se ha actualizado hace menos de 10 minutos."
	fi



else

fi



echo $take_function_value
exit


# Comprobar si el archivo de última actualización existe
if [ -f "$LAST_UPDATE_FILE" ]; then
    
    CURRENT_TIME=$(date +%s)
    LAST_UPDATE_TIME=$(cat "$LAST_UPDATE_FILE")

    # Calcular la diferencia de tiempo
    TIME_DIFF=$((CURRENT_TIME - LAST_UPDATE_TIME))

    if [ "$TIME_DIFF" -gt "$UPDATE_INTERVAL" ]; then
        # Si han pasado más de 10 minutos, ejecutar la actualización
        do_message "Actualizando..."
        do_script "apt update -y"


        # Actualizar el archivo con el nuevo timestamp
        echo "$CURRENT_TIME" > "$LAST_UPDATE_FILE"
    else
        # Si no han pasado 10 minutos, mostrar un mensaje
        echo "Se ha actualizado hace menos de 10 minutos."
    fi
else
    # Si el archivo no existe, ejecutar la actualización y crear el archivo
    do_message "Actualizando por primera vez..."
    do_script "apt update -y"

    # Crear el archivo con el timestamp actual
    echo "$(date +%s)" > "$LAST_UPDATE_FILE"
fi




CFG_SERVERDIRECTORY="/ruta/del/servidor" # Reemplaza con la ruta de tu servidor
LAST_UPDATE_FILE="$CFG_SERVERDIRECTORY/last_update"
UPDATE_INTERVAL=600  # 10 minutos en segundos (600 segundos)

# Función para mostrar un mensaje
function do_message() {
    local MSG=$1
    echo "$MSG"
}

# Función para ejecutar un comando y mostrar un mensaje de progreso
function do_script() {
    local COMMAND=$1
    $COMMAND
}

# Comprobar si el archivo de última actualización existe
if [ -f "$LAST_UPDATE_FILE" ]; then
    # Obtener el timestamp actual y el de la última actualización
    CURRENT_TIME=$(date +%s)
    LAST_UPDATE_TIME=$(cat "$LAST_UPDATE_FILE")

    # Calcular la diferencia de tiempo
    TIME_DIFF=$((CURRENT_TIME - LAST_UPDATE_TIME))

    if [ "$TIME_DIFF" -gt "$UPDATE_INTERVAL" ]; then
        # Si han pasado más de 10 minutos, ejecutar la actualización
        do_message "Actualizando..."
        do_script "apt update -y"

        # Actualizar el archivo con el nuevo timestamp
        echo "$CURRENT_TIME" > "$LAST_UPDATE_FILE"
    else
        # Si no han pasado 10 minutos, mostrar un mensaje
        echo "Se ha actualizado hace menos de 10 minutos."
    fi
else
    # Si el archivo no existe, ejecutar la actualización y crear el archivo
    do_message "Actualizando por primera vez..."
    do_script "apt update -y"

    # Crear el archivo con el timestamp actual
    echo "$(date +%s)" > "$LAST_UPDATE_FILE"
fi



































#------------------------------------------------------------------
#		19)	UPGRADE
#------------------------------------------------------------------
subtitle "Actualizando aplicaciones"

do_message "Actualizando..."
do_script "apt upgrade -y"

#------------------------------------------------------------------
#		20)	INSTALACION DE UTILIDADES
#------------------------------------------------------------------
subtitle "Instalando Utilidades"

install_package "language-pack-es"

#------------------------------------------------------------------
#		18)	CONFIGURACIÓN DE IDIOMAS LOCALES
#------------------------------------------------------------------
subtitle "Instalando LOCALES"

LOCALE_GEN="/etc/locale.gen"

cp $LOCALE_GEN $install_temp/locale.gen.bak

#	Descomentar la linea
uncomment "$LOCALE_GEN" "# " "$LOCALES"
LOCALE_SHORT=$(echo "$LOCALES" | awk '{print $1}')
update-locale LANG=$LOCALE_SHORT

#------------------------------------------------------------------
#		19)	DESHABILITAR APP ARMOR
#------------------------------------------------------------------
subtitle "Configurando AppArmor"

service apparmor stop
update-rc.d -f apparmor remove
uninstall_package "apparmor"
uninstall_package "apparmor-utils"

#------------------------------------------------------------------
#		20)	APACHE 
title "Servidor Web"
#------------------------------------------------------------------
subtitle "Instalando Apache"

install_package "apache2"

#------------------------------------------------------------------
#		21)	APACHE WEBPAGE
#------------------------------------------------------------------
subtitle "Cambiando la web de bienvenida"

echo "PCFET0NUWVBFIGh0bWw+CjxodG1sIGxhbmc9ImVzIj4KPGhlYWQ+CiAgICA8bWV0YSBjaGFyc2V0PSJVVEYtOCI+CiAgICA8bWV0YSBuYW1lPSJ2aWV3cG9ydCIgY29udGVudD0id2lkdGg9ZGV2aWNlLXdpZHRoLCBpbml0aWFsLXNjYWxlPTEuMCI+CiAgICA8dGl0bGU+wqFGdW5jaW9uYSE8L3RpdGxlPgogICAgPHN0eWxlPgogICAgICAgIGJvZHksIGh0bWwgewogICAgICAgICAgICBoZWlnaHQ6IDEwMCU7CiAgICAgICAgICAgIG1hcmdpbjogMDsKICAgICAgICAgICAgZm9udC1mYW1pbHk6IFVidW50dSwgQXJpYWwsIHNhbnMtc2VyaWY7CiAgICAgICAgICAgIG92ZXJmbG93OiBoaWRkZW47CiAgICAgICAgfQogICAgICAgIC5jb250YWluZXIgewogICAgICAgICAgICBoZWlnaHQ6IDEwMCU7CiAgICAgICAgICAgIGRpc3BsYXk6IGZsZXg7CiAgICAgICAgICAgIGZsZXgtZGlyZWN0aW9uOiBjb2x1bW47CiAgICAgICAgICAgIGp1c3RpZnktY29udGVudDogY2VudGVyOwogICAgICAgICAgICBhbGlnbi1pdGVtczogY2VudGVyOwogICAgICAgICAgICBiYWNrZ3JvdW5kOiBsaW5lYXItZ3JhZGllbnQoNDVkZWcsICNFOTU0MjAsICNGRjhDNDQsICNGRkJCMzMpOwogICAgICAgICAgICBhbmltYXRpb246IGdyYWRpZW50QkcgMTVzIGVhc2UgaW5maW5pdGU7CiAgICAgICAgfQogICAgICAgIEBrZXlmcmFtZXMgZ3JhZGllbnRCRyB7CiAgICAgICAgICAgIDAlIHsgYmFja2dyb3VuZC1wb3NpdGlvbjogMCUgNTAlOyB9CiAgICAgICAgICAgIDUwJSB7IGJhY2tncm91bmQtcG9zaXRpb246IDEwMCUgNTAlOyB9CiAgICAgICAgICAgIDEwMCUgeyBiYWNrZ3JvdW5kLXBvc2l0aW9uOiAwJSA1MCU7IH0KICAgICAgICB9CiAgICAgICAgLmNvbnRlbnQgewogICAgICAgICAgICB0ZXh0LWFsaWduOiBjZW50ZXI7CiAgICAgICAgICAgIGNvbG9yOiAjZmZmZmZmOwogICAgICAgICAgICBwYWRkaW5nOiAyMHB4OwogICAgICAgIH0KICAgICAgICAubG9nbyB7CiAgICAgICAgICAgIHdpZHRoOiAxNTBweDsKICAgICAgICAgICAgaGVpZ2h0OiBhdXRvOwogICAgICAgICAgICBtYXJnaW4tYm90dG9tOiAyMHB4OwogICAgICAgIH0KICAgICAgICBoMSB7CiAgICAgICAgICAgIGZvbnQtc2l6ZTogNHZ3OwogICAgICAgICAgICBtYXJnaW4tYm90dG9tOiAyMHB4OwogICAgICAgIH0KICAgICAgICAubGFuZ3VhZ2VzIHsKICAgICAgICAgICAgZm9udC1zaXplOiAxLjh2dzsKICAgICAgICAgICAgbGluZS1oZWlnaHQ6IDEuNTsKICAgICAgICB9CiAgICA8L3N0eWxlPgo8L2hlYWQ+Cjxib2R5PgogICAgPGRpdiBjbGFzcz0iY29udGFpbmVyIj4KICAgICAgICA8ZGl2IGNsYXNzPSJjb250ZW50Ij4KICAgICAgICAgICAgPGltZyBzcmM9InVidW50dS5wbmciIGFsdD0iVWJ1bnR1IExvZ28iIGNsYXNzPSJsb2dvIj4KICAgICAgICAgICAgPGgxPsKhRnVuY2lvbmEhPC9oMT4KICAgICAgICAgICAgPGRpdiBjbGFzcz0ibGFuZ3VhZ2VzIj4KICAgICAgICAgICAgICAgIEl0IHdvcmtzISDigKIgw4dhIG1hcmNoZSEg4oCiIEVzIGZ1bmt0aW9uaWVydCE8YnI+CiAgICAgICAgICAgICAgICBGdW56aW9uYSEg4oCiIOWug+i1t+S9nOeUqOS6hu+8gSDigKIg0K3RgtC+INGA0LDQsdC+0YLQsNC10YIhPGJyPgogICAgICAgICAgICAgICAg44Gd44KM44Gv5YuV5L2c44GX44G+44GZ77yBIOKAoiDgpK/gpLkg4KSV4KS+4KSuIOCkleCksOCkpOCkviDgpLngpYghIOKAoiDCoUZ1bmNpb25hITxicj4KICAgICAgICAgICAgICAgIEhldCB3ZXJrdCEg4oCiIER6aWHFgmEhIOKAoiBGdW5nZXJhciEg4oCiIFRvaW1paSE8YnI+CiAgICAgICAgICAgICAgICBGdW5nZXJlciEg4oCiIMOeYcOwIHZpcmthciEg4oCiIExla2tlciBtYW4hIOKAoiDDh2FsxLHFn8SxeW9yITxicj4KICAgICAgICAgICAgICAgIM6bzrXOuc+Ezr/Phc+BzrPOtc6vISDigKIgRGVsdWplISDigKIgRnVuZ3VqZSEg4oCiINCf0YDQsNGG0Y7RlCE8YnI+CiAgICAgICAgICAgICAgICDYpdmG2Ycg2YrYudmF2YQhIOKAoiDXlteUINei15XXkdeTISDigKIgSG/huqF0IMSR4buZbmchIOKAoiDguYPguIrguYnguIfguLLguJnguYTguJTguYkhCiAgICAgICAgICAgIDwvZGl2PgogICAgICAgIDwvZGl2PgogICAgPC9kaXY+CjwvYm9keT4KPC9odG1sPg==" | base64 --decode > "/var/www/html/index.html"

echo "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" | base64 --decode > "/var/www/html/ubuntu.png"

do_message "Web de bienvenida cambiada"

#------------------------------------------------------------------
#		22)	DOMAIN.CONF
#------------------------------------------------------------------
subtitle "Creando el VirtualHost para $CFG_DOMAIN"

echo "<VirtualHost *:$CFG_PORT>
    ServerAdmin $CFG_ADMINMAIL
    ServerName $CFG_DOMAIN
    ServerAlias www.$CFG_DOMAIN

    DocumentRoot /$CFG_SERVERDIRECTORY/www/$CFG_DOMAIN

    ErrorLog /$CFG_SERVERDIRECTORY/logs/error.$CFG_DOMAIN.log
    CustomLog /$CFG_SERVERDIRECTORY/logs/access.$CFG_DOMAIN.log combined

    <Directory /$CFG_SERVERDIRECTORY/www/$CFG_DOMAIN>
        Options -Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>" > "/etc/apache2/sites-available/$CFG_DOMAIN.conf"

do_message "Creado $CFG_DOMAIN.conf"

#------------------------------------------------------------------
#		23)	HABILITAR PUERTO
#------------------------------------------------------------------
subtitle "Agregando puerto de escucha a ports.conf"

PORTS_CONF="/etc/apache2/ports.conf"

#------------------------------------------------------------------
#		23)	PHP
#------------------------------------------------------------------
install_package "php"
install_package "libapache2-mod-php"
install_package "php-mysql"

#------------------------------------------------------------------
#		24)	MYSQL
#------------------------------------------------------------------


#------------------------------------------------------------------
#		25)	TLS (LETS ENCRYPT)
#------------------------------------------------------------------


#------------------------------------------------------------------
#		26)	CERTIFICADO
#------------------------------------------------------------------

#------------------------------------------------------------------
#		27)	FIREWALL
#------------------------------------------------------------------


#------------------------------------------------------------------
#		28)	MANTENCIONES FINALES
#------------------------------------------------------------------
#	Copia de Log
#	Eliminar instalacion
#	Reiniciar Sistema



exit

#------------------------------------------------------------------
#		20)	INSTALACIÓN DE SERVIDOR SH
#------------------------------------------------------------------
subtitle "Ssh"

install_package "openssh-server"
echo -e "${green}"
sudo systemctl enable ssh
sudo systemctl start ssh
echo -e "${reset}"

#------------------------------------------------------------------
#		21)	CONFIGURACIÓN DE SERVIDOR SH
#------------------------------------------------------------------
subtitle "Modificando Propiedades"

#	PermitRootLogin
uncomment "/etc/ssh/sshd_config" "#" "PermitRootLogin"
set_value "/etc/ssh/sshd_config" "PermitRootLogin" " " "no"

#Port 22
uncomment "/etc/ssh/sshd_config" "#" "Port"
set_value "/etc/ssh/sshd_config" "Port" " " "$SSH_PORT"

#PasswordAuthentication
uncomment "/etc/ssh/sshd_config" "#" "PasswordAuthentication"
set_value "/etc/ssh/sshd_config" "PasswordAuthentication" " " "no"

#AllowUsers
uncomment "/etc/ssh/sshd_config" "#" "AllowUsers"
set_value "/etc/ssh/sshd_config" "AllowUsers" " " "$CFG_SUDOUSER"

#PubkeyAuthentication
uncomment "/etc/ssh/sshd_config" "#" "PubkeyAuthentication"
set_value "/etc/ssh/sshd_config" "PubkeyAuthentication" " " "yes"

#ChallengeResponseAuthentication
uncomment "/etc/ssh/sshd_config" "#" "ChallengeResponseAuthentication"
set_value "/etc/ssh/sshd_config" "ChallengeResponseAuthentication" " " "no"

#UsePAM
uncomment "/etc/ssh/sshd_config" "#" "UsePAM"
set_value "/etc/ssh/sshd_config" "UsePAM" " " "no"

















exit
#------------------------------------------------------------------
#		22)	CREANDO LLAVES PUBLICAS
#------------------------------------------------------------------
subtitle "Creación de Llaves"

if [ "$SSH_CREATE" -eq 1 ]; then

    # Verificar si el archivo existe
    if [ ! -e "./id_rsa" ]; then
		do_points "Creando Par de Llaves"
		do_btn_ok
		ssh-keygen -t rsa -b 4096 -C "$CFG_ADMINMAIL" -f "./id_rsa" -N "$SSH_PWD"
	fi
else
	do_points "Copiando Par de llaves"
	$SSH_PRIVATE >> "./id_rsa"
	$SSH_PUBLIC >> "./id_rsa.pub"
	do_btn_ok
fi

#	Creacion de .ssh
create_dir "/home/$CFG_SUDOUSER/.ssh"

#	Copia de llave privada
copy_userfile "./id_rsa" "/home/$CFG_SUDOUSER/.ssh/id_rsa"
#	Copia de llave publica
copy_userfile "./id_rsa.pub" "/home/$CFG_SUDOUSER/.ssh/id_rsa.pub"

#	Copia de archivos a autorized keys
ssh-copy-id -i /home/$CFG_SUDOUSER/.ssh/id_rsa.pub $CFG_SUDOUSER@$CGF_IP
#ssh-copy-id -i /home/fibercat/.ssh/id_rsa.pub -p 3125 fibercat@159.89.50.24

chmod 700 /home/$CFG_SUDOUSER/.ssh
chmod 600 /home/$CFG_SUDOUSER/.ssh/authorized_keys

#------------------------------------------------------------------
#		23)	SSH: Quitando personalizaciones
#------------------------------------------------------------------
subtitle "Quitando Personalizaciones"

SSHD_CONFIG="/etc/ssh/sshd_config"

if grep -q "^Include /etc/ssh/sshd_config.d/\*.conf" "$SSHD_CONFIG"; then
    # Comenta la línea
    sudo sed -i 's|^Include /etc/ssh/sshd_config.d/\*.conf|#Include /etc/ssh/sshd_config.d/*.conf|' "$SSHD_CONFIG"
    echo "La línea 'Include /etc/ssh/sshd_config.d/*.conf' ha sido comentada en $SSHD_CONFIG."
else
    echo "La línea 'Include /etc/ssh/sshd_config.d/*.conf' ya está comentada o no existe en $SSHD_CONFIG."
fi

sudo systemctl restart ssh






exit













exit
#------------------------------------------------------------------
#		17)	SSH SERVER
#------------------------------------------------------------------


#Configurar sshd_config
#Configurar autenticación con claves
#Configurar el firewall (UFW)
#Deshabilitar autenticación con contraseña
#Reiniciar el servicio SSH
#Monitorear el servidor
#Verificar y mantener



sudo apt install openssh-server -y







exit
title "EL SERVER"



#------------------------------------------------------------------
#		16)	LOG 
#------------------------------------------------------------------








#------------------------------------------------------------------
#					8)	ARCHIVO LOG DE INSTALACIÓN
#------------------------------------------------------------------
	title "Creación y verificación de archivos necesarios para la instalación"

	subtitle "Creando archivo de log"

	#	Movemos el archivo de log al directorio de log
	do_points "Creando log en /$CFG_SERVERDIRECTORY/logs/install.log" 0.1
	touch /$CFG_SERVERDIRECTORY/logs/install.log
	sudo chmod 774 "/$CFG_SERVERDIRECTORY/logs/install.log"
	sudo chown root:"$CFG_SUDOGROUP" "/$CFG_SERVERDIRECTORY/logs/install.log"
	do_btn_ok

	#	Copiamos el contenido del antiguo log de instalación
	do_points "Copiando actual log en /$CFG_SERVERDIRECTORY/logs/install.log" 0.1
	cp "$logfile" "/$CFG_SERVERDIRECTORY/logs/install.log"
	do_btn_ok

	#	Eliminamos el antiguo log de instalación
	do_points "Eliminando actual log" 0.1
	rm "$logfile"
	logfile="/$CFG_SERVERDIRECTORY/logs/install.log"
	do_btn_ok
else
	logfile="/$CFG_SERVERDIRECTORY/logs/install.log"
	echo -e "${msg_atention}[DIRECTORIOS]${reset}"
fi

exit






