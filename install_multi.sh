#!/bin/bash

#	                  CONFIGURACION INICIAL
#------------------------------------------------------------------
#	Versión
system_version=0.4			# Versión del servicio
#   Formato
negrita='\033[1m'			# Define el formato de texto como negrita
subrayado='\033[4m'			# Define el formato de texto como subrayado
reset='\033[0m'				# Restablece el formato de texto a predeterminado
#   Fondos
f_blanco='\033[0;47m'		# Define el color de fondo como blanco
#   Botones
btn_ok='\033[1;45m'			# Define el formato de botón OK.
destacar='\033[1;33m'		# Define el formato para destacar en amarillo.
btn_error='\033[1;41m'		# Define el formato de botón de error
cyan='\033[1;36m'			# Define el color de texto como cian
titulo=$cyan$subrayado		# Define el formato de título como cian y subrayado
parte='\033[7;32m'			# Define el formato de parte del texto

clear

#	                  FUNCIONES GENERALES
#------------------------------------------------------------------
#	Titulos Grandes
mititulo(){
	echo -e "${parte}\n--------------------------$1--------------------------\n${reset}"
}
#	Titulo del log
mititulo_log(){
	echo "------------------------------------------------------------------" >> tmp.log
	echo $1 >> tmp.log
	echo "------------------------------------------------------------------" >> tmp.log
}
#	Mi Subtitulo
misubtitulo(){
	echo -e "\n${titulo}$1\n${reset}"
}
misubtitulo_log(){
	echo "------------------------------------------------------------------" >> tmp.log
	echo "[||||||||||||||||$1||||||||||||||||]" >> tmp.log
	echo "------------------------------------------------------------------" >> tmp.log
}
misubtitulo_update(){
	echo "------------------------------------------------------------------" >> update.cfg
	echo "[||||||||||||||||$1||||||||||||||||]" >> update.cfg
	echo "------------------------------------------------------------------" >> update.cfg
}

#	Mensaje
mimensaje(){
	echo -e "${cyan}\n$1\n${reset}"
}

#	Destacar
destacar(){
	echo -e " ${destacar}$1${reset}"
}
#	Log
log(){
	echo "$(date +'%d-%b-%Y %H:%M:%S.%3N') $1" >> tmp.log
}

#	Ok
ok(){
	echo -e " ${btn_ok} PERFECTO ${reset} $1"
	if [ "$2" != false ];then
		log "$1"
	fi
}
#	Error
error(){
	echo -e " ${btn_error} ERROR ${reset} $1"
	if [ "$2" == false ];then
		echo ""
	else
		echo -e "$2"
		log "ERROR: $1"
	fi
	echo -e "${destacar}No podemos continuar con la instalación.${reset}"
	exit 1
}

#	                  REQUISITOS INICIALES
#------------------------------------------------------------------
mititulo "REQUISITOS INICIALES"

#	Declaración de archivos a revisar: 
declare -a files=(
	"config.cfg"
	"ssh_key.cfg"
	"installer.cfg"
)

#	Función de Revisión de presencia de archivos
revisar_archivo() {
	if [ -f "$1" ]; then
		ok "${destacar}$1${reset} se encuentra presente." false
		source "$1"
	else
		error "No se encontró el archivo de configuración ("$1")." "${destacar}Puede descargar una copia del archivo "$1" desde https://github.com/kissableandres/Fibercat-Luffy ${reset}"
	fi
	sleep $PAUSA_CORTA
}
#	Ejecuta la revisión
for file in "${files[@]}"
do
	revisar_archivo "$file"
done

#							LOG DE INSTALACIÓN
#------------------------------------------------------------------
#	Establecemos temporalmente la zona horaria desde config.cfg
export TZ="$TIMEZONE"
#	Creamos el "Registro del log".
echo "$(date +'%d-%b-%Y %H:%M:%S.%3N') Inicia la instalación" > tmp.log
#	Le damos permisos al dueño configurado en config.cfg
sudo chown "$SUDOUSER":"$SUDOGROUP" tmp.log
ok "Se ha creado el logger ${destacar}tmp.log${reset}" false

sleep $PAUSA_CORTA

#								PRESENTACIÓN
#------------------------------------------------------------------
mititulo "-----------------------------------------------
[:::::::::::::::           SISTEMA MONKEY D. LUFFY          ::::::::::::]
-----------------------------------------------"
mimensaje "BIENVENIDO
Para poder instalar correctamente, ten en cuenta lo siguiente:
1. Este script debe ser ejecutado con sudo: ${destacar}sudo ./install_multi.sh${reset}${cyan}
2. Para que todo fluya estandar, siempre suba estos archivos
al directorio /home del usuario sudoer, ejemplo:
${destacar}cd /home/usuario_sudoer${reset}${cyan}
3. Este SCRIPT esta pensado para ser instalado en un sistema ${destacar}minimimamente instalado${reset}${cyan}.
Errores podrían suceder si se ejecuta en un entorno con el software preinstalado.
Con todo, este script revisará lo máximo que pueda y desintalará versiones antiguas.
Asimismo, intentará restaurar configuraciones.
4. El siguiente SCRIPT es y ha sido testeado en los siguientes 
sistemas operativos:
*********************************************************************

${destacar}*   UBUNTU SERVER 22.04 LTS${reset}${cyan}

****************************************************************
Al continuar, estas de acuerdo con que se modificará el sistema exhaustivamente.
También se eliminaran directorios si ya tenias instalado el sistema o falló anteriormente.${reset}"

# Espera a que el usuario presione una tecla
#read -n 1 -s -r -p "Presiona cualquier tecla para continuar... o presiona ctrl+c para terminar el Script"
# Continúa con el resto del script
echo ""
echo "Continuamos..."

#							LOGO FIBERCAT
#------------------------------------------------------------------
destacar "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
'########:'####:'########::'########:'########:::'######:::::'###::::'########:
 ##.....::. ##:: ##.... ##: ##.....:: ##.... ##:'##... ##:::'## ##:::... ##..::
 ##:::::::: ##:: ##:::: ##: ##::::::: ##:::: ##: ##:::..:::'##:. ##::::: ##::::
 ######:::: ##:: ########:: ######::: ########:: ##:::::::'##:::. ##:::: ##::::
 ##...::::: ##:: ##.... ##: ##...:::: ##.. ##::: ##::::::: #########:::: ##::::
 ##:::::::: ##:: ##:::: ##: ##::::::: ##::. ##:: ##::: ##: ##.... ##:::: ##::::
 ##:::::::'####: ########:: ########: ##:::. ##:. ######:: ##:::: ##:::: ##::::
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
				NETWORKS SPA 2024\n"

sleep $PAUSA_CORTA

#							LOGO SERVER
#------------------------------------------------------------------
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
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⠳⣝⢢⠑⠀⠀⠀⢻⣝⢧⡚⠡⠀⢰⣡⠓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${reset}"

sleep $PAUSA_CORTA

#						REVISIÓN DE SEGURIDAD
#------------------------------------------------------------------
mititulo "REVISIÓN DE SEGURIDAD"
mititulo_log "REVISIÓN DE SEGURIDAD"

#						REQUISITOS DE HARDWARE
#------------------------------------------------------------------
misubtitulo "Requisitos de Hardware y Distribución"

#	Obtenemos los datos de Disco en /
HDD_tamano_actual=$(df -B 1M --output=size / | tail -n 1 | awk '{print $1}')
HDD_tamano_actual=$(echo "scale=2; $HDD_tamano_actual/1024" | bc)
#	Obtenemos el tamaño de la RAM
RAM_tamano_actual=$(free --mega | awk '/Mem:/ {print $2}' | tr -d '[:alpha:]')
RAM_tamano_actual=$(echo "scale=2; $RAM_tamano_actual/1024" | bc)

#	"$REQUISITOS_HARDWARE" = "true|false"
if [ "$REQUISITOS_HARDWARE" = "true" ]; then

	log "Directiva REQUISITOS_HARDWARE = true."

	if [ "$(echo "$HDD_tamano_actual >= $MIN_HDD" | bc -l)" -eq 1 ]; then
		ok "El tamaño de Disco (${HDD_tamano_actual}G) es mayor o igual a ${MIN_HDD}G."
	else
		error "El tamaño de Disco (${HDD_tamano_actual}G) es menor a ${MIN_HDD}G."
	fi

	sleep $PAUSA_CORTA

	if [ "$(echo "$RAM_tamano_actual >= $MIN_RAM" | bc -l)" -eq 1 ]; then
		ok "El tamaño de Disco (${RAM_tamano_actual}G) es mayor o igual a ${MIN_RAM}G."
	else
		error "El tamaño de Disco (${RAM_tamano_actual}G) es menor a ${MIN_RAM}G."
	fi

else
	ok "Se ha solicitado que no se verifique el Hardware." false
	log "Directiva REQUISITOS_HARDWARE = false. No se ha verificado el hardware."
	log "Se registra que root tiene en el disco $HDD_tamano_actual Gb."
	log "Se registra que la RAM de sistema es de $RAM_tamano_actual Gb."
fi

sleep $PAUSA_CORTA

#				VERIFICAR COMPATIBILIDAD CON DISTRIBUCIÓN
#------------------------------------------------------------------
# Obtenemos la distribución
actual_DIST=$(lsb_release -is)
actual_version=$(lsb_release -rs)
log "Distribución Actual: $actual_DIST $actual_version"

# Verificar el sistema operativo
if [[ ! " ${ACEPTABLE_SO[@]} " =~ " $actual_DIST " ]]; then
	error "La distribución instalada ($actual_DIST $actual_version) por ahora no es compatibles con Fibercat Luffy"
fi

# Verificar la versión según el sistema operativo
case $actual_DIST in
	"Ubuntu")
		if [[ ! " ${ACEPTABLE_VERSION_UBUNTU[@]} " =~ " $actual_version " ]]; then
			error "La distribución instalada ($actual_DIST $actual_version) por ahora no es compatibles con Fibercat Luffy" 
		fi
		;;
	"Debian")
		if [[ ! " ${ACEPTABLE_VERSION_DEBIAN[@]} " =~ " $actual_version " ]]; then
			error "La distribución instalada ($actual_DIST $actual_version) por ahora no es compatibles con Fibercat Luffy"
		fi
		;;
	*)
		error "La distribución instalada ($actual_DIST $actual_version) por ahora no es compatibles con Fibercat Luffy"
		;;
esac

# Si llegamos aquí, el sistema operativo y la versión son correctos
ok "El sistema operativo ($actual_DIST $actual_version) cumplen con los requisitos mínimos."

sleep $PAUSA_CORTA

#						VERIFICAR PRIVILEGIOS
#------------------------------------------------------------------
misubtitulo "Verificar privilegios de usuario"

# Verificar si el usuario actual es root
if [ "$EUID" -eq 0 ]; then
	ok "El usuario actual tiene privilegios ${destacar}root${reset}." false
	echo "$(date +'%d-%b-%Y %H:%M:%S.%3N') Se registra que el usuario tiene privilegios ROOT." >> tmp.log
else
 	log "Usuario sin privilegios. Finalizado."
	error "El usuario actual no posee privilegios ${destacar}ROOT${reset}. Por favor, utilice ${destacar}sudo${reset} para instalar." false
fi

sleep $PAUSA_CORTA

#						VERIFICAR USUARIO SUDOER
#------------------------------------------------------------------
# Verifica si el usuario está adscrito al grupo
if groups "$SUDOUSER" | grep -q "\b$SUDOGROUP\b"; then
	ok "${destacar}$SUDOUSER${reset} está adscrito al grupo ${destacar}$SUDOGROUP${reset}." false
	log "El usuario $SUDOUSER pertenece al grupo $SUDOGROUP."
else 
	echo -e " ${destacar}$SUDOUSER${reset} NO está adscrito al grupo ${destacar}$SUDOGROUP${reset}."
	log "El usuario $SUDOUSER NO pertenece al grupo $SUDOGROUP."
	#	Verificamos que existe el grupo en cuestion
	if grep -q "^$SUDOGROUP:" /etc/group; then
		ok "El grupo ${destacar}$SUDOGROUP${reset} ya existe." false
		log "Existe el grupo $SUDOGROUP"
	else
		echo -e " El grupo ${destacar}$SUDOGROUP${reset} no existe. Creándolo..."
		sudo groupadd "$SUDOGROUP"
		ok "El grupo ${destacar}$SUDOGROUP${reset} ha sido creado." false
		log "El grupo $SUDOGROUP ha sido creado."
	fi
	sudo usermod -aG "$SUDOGROUP" "$SUDOUSER"
	ok "Se ha agregado ${destacar}$SUDOUSER${reset} al grupo ${destacar}$SUDOGROUP${reset}." false
	log "Usuario $SUDOUSER agragado al grupo $SUDOGROUP."
fi

sleep $PAUSA_CORTA

mititulo "LOCALIZACION E IDIOMA"
mititulo_log "LOCALIZACION E IDIOMA"

#						HORA LOCAL
#------------------------------------------------------------------
misubtitulo "Actualizar Zona Horaria"
TIME=$(cat /etc/timezone);

if [[ $TIME == "$TIMEZONE" ]]
then
	ok "La zona horaria solicitada ($TIMEZONE) ya es $TIME."
else
    timedatectl set-timezone $TIMEZONE
	ok "Se ha reemplazado $TIME (Actual) por $TIMEZONE (DIRECTIVA TIMEZONE)."
fi

sleep $PAUSA_CORTA

#						LOCALES
#------------------------------------------------------------------
misubtitulo "Instalando Locales (Idioma)"
ACTUAL_LOCALE=$(locale | grep -oP '^LANG=\K.*')
log "Declaramos que actualmente Locales es $ACTUAL_LOCALE."

# Verificar si language-pack-es está instalado
if dpkg -l | grep -q "language-pack-es"; then
    ok "El paquete language-pack-es está instalado."
else
	log "Instalacion de Locales"
    destacar "El paquete language-pack-es no está instalado."
	misubtitulo_log "LOG DE LA INSTALACION DE LOCALES"
	sudo apt-get install language-pack-es -y >> tmp.log 2>&1
	misubtitulo_log "LOG update-locale LANG=$LOCALES"
	sudo update-locale LANG=$LOCALES >> tmp.log 2>&1
	ok "Se han instalado el soporte para idioma local y actualizado locales."
	log "Será necesario reinciar. (sudo reboot)"
fi

sleep $PAUSA_CORTA

# Verificar si ya esta configurada el local
if [ "$ACTUAL_LOCALE" = "$LOCALES" ]; then
	ok "La configuración de locales actual ($ACTUAL_LOCALE) ya está configurada en $LOCALES"
else
	sudo update-locale LANG=$LOCALES
	ok "El soporte para $ACTUAL_LOCALE se ha sido instalado con exito. Pero requiere reiniciar."
fi

sleep $PAUSA_CORTA

#						INSTALACIÓN DE SISTEMA BASE
#------------------------------------------------------------------
mititulo "INSTALACIÓN DE SISTEMA BASE"
mititulo_log "INSTALACIÓN DE SISTEMA BASE"

#						DIRECTORIOS DE NUESTRO SISTEMA
#------------------------------------------------------------------
misubtitulo "Creando Directorios de sistema"

#	Declaramos los directorios.
declare -a dirs=(
	"/$SERVERDIRECTORY"
	"/$SERVERDIRECTORY/www"
	"/$SERVERDIRECTORY/backups"
	"/$SERVERDIRECTORY/ssl"
	"/$SERVERDIRECTORY/logs"
)

#	Creación de Directorios
for dir in "${dirs[@]}"
do
	# Verificar si el directorio existe
	if [ -d "$dir" ]; then
		ok "El directorio $dir ya existe. Lo eliminamos." false
		rm -R "$dir"
		log "Se ha eliminado el Directorio $dir y sus subdirectorios."
	else
		ok "El directorio $dir aún no existe. Lo crearemos."
	fi
	mkdir "$dir"
	sudo chmod 774 "$dir"
	sudo chown root:"$SUDOGROUP" "$dir"
	log "Se crea el Directorio $dir con permisos 774 y chown root:"$SUDOGROUP""
	ok "El Directorio ${destacar}$dir${reset} ha sido creado." false
	sleep $PAUSA_CORTA
done

#						REGISTRO DE ACTUALIZACIONES
#------------------------------------------------------------------
misubtitulo "Creación del Registro de Actualizaciones"

#	Crea el registro de actualizaciones si no está creado ya.
if [[ ! -f "update.cfg" ]]; then
	echo "ULTIMA_ACTUALIZACION=0" > update.cfg
	echo "ULTIMO_UPGRADE=0" >> update.cfg
	echo "REPO_APACHE=0" >> update.cfg
	echo "REPO_PHP=0" >> update.cfg
	sudo chown "$SUDOUSER":"$SUDOGROUP" update.cfg
	sudo chmod 664 update.cfg
	log "Se ha creado update.cfg con permisos 664 y "$SUDOUSER":"$SUDOGROUP""
	ok "Se ha creado el Registro update.cfg" false
else
	ok "El registro de actualizaciones ya existia con anterioridad." false
fi

#	Verificamos que el archivo exista.
if [ -f "update.cfg" ]; then
	#	Verifica existencia de parametros.
	ULTIMA_ACTUALIZACION=$(grep "^ULTIMA_ACTUALIZACION=" "update.cfg" | cut -d "=" -f 2)
	if [ -n "$ULTIMA_ACTUALIZACION" ]; then
		ok "El parámetro ${destacar}ULTIMA_ACTUALIZACION${reset} existe en update.cfg." false
	else
		log "Falta ULTIMA_ACTUALIZACION en update.cfg"
		error "El parámetro ${destacar}ULTIMA_ACTUALIZACION${reset} NO existe en update.cfg." false
 	fi

	ULTIMO_UPGRADE=$(grep "^ULTIMO_UPGRADE=" "update.cfg" | cut -d "=" -f 2)	
	if [ -n "$ULTIMO_UPGRADE" ]; then
		ok "El parámetro ${destacar}ULTIMO_UPGRADE${reset} existe en update.cfg." false
	else
		log "Falta ULTIMO_UPGRADE en update.cfg"
		error "El parámetro ${destacar}ULTIMO_UPGRADE${reset} NO existe en update.cfg." false
 	fi

	REPO_APACHE=$(grep "^REPO_APACHE=" "update.cfg" | cut -d "=" -f 2)
	if [ -n "$REPO_APACHE" ]; then
		ok "El parámetro ${destacar}REPO_APACHE${reset} existe en update.cfg." false
	else
		log "Falta REPO_APACHE en update.cfg"
		error "El parámetro ${destacar}REPO_APACHE${reset} NO existe en update.cfg." false
  	fi

	REPO_PHP=$(grep "^REPO_PHP=" "update.cfg" | cut -d "=" -f 2)
	if [ -n "$REPO_PHP" ]; then
		ok "El parámetro ${destacar}REPO_PHP${reset} existe en update.cfg." false
	else
		log "Falta REPO_PHP en update.cfg"
		error "El parámetro ${destacar}REPO_PHP${reset} NO existe en update.cfg." false
 	fi
	ok "El Registro ${destacar}update.cfg${reset} ha sido creado." false
	log "Se ha creado el Registro update.cfg con todos sus parametros."
else
	error "Hay un problema con el archivo REGISTRO DE ACTUALIZACIONES (update.cfg). No existe."
fi

sleep $PAUSA_CORTA

#					PERSONALIZAMOS EL SISTEMA
#------------------------------------------------------------------
misubtitulo "Personalizamos el sistema  en base a distros y versiones"
# NOTA:
#	Como los repositorios son personalizados para cada distribución, se agregan
# según el soporte de la distribución correspondiente.
#	Agregamos mas versiones para tener claridad en el futuro.

#	Obtenemos los valores
REPO_APACHE=$(grep "^REPO_APACHE=" "update.cfg" | cut -d "=" -f 2)
REPO_PHP=$(grep "^REPO_PHP=" "update.cfg" | cut -d "=" -f 2)

mititulo_log "AGREGAMOS REPOSITORIOS"

if [ "$actual_DIST" = "Ubuntu" ]; then
	#	Titulo del update

	if [ "$actual_version" = "20.04" ]; then
		#Se instalara para Ubuntu 20.04 Focal Fossa
		
		#	APACHE
		if [ "$REPO_APACHE" -eq 0 ]; then
			misubtitulo_log "AGREGAMOS REPOSITORIO APACHE"
			misubtitulo_update "AGREGAMOS REPOSITORIO APACHE"
			echo -e "\n" | sudo add-apt-repository ppa:ondrej/apache2 | tee -a update.cfg tmp.log > /dev/null 2>&1
			ok "${destacar}Repositorio Apache${reset} agregado." false
			log "Se ha agregado el repositorio de Apache2. Ver update.cfg"
			sed -i "s/^REPO_APACHE=.*/REPO_APACHE=1/" "update.cfg"
		else
			ok "${destacar}Repositorio Apache${reset} ya fue agregado." false
			log "No se ha agregado el repositorio de Apache2. Ver update.cfg"
		fi

		#	PHP
		if [ "$REPO_PHP" -eq 0 ]; then
			misubtitulo_log "AGREGAMOS REPOSITORIO PHP"
			misubtitulo_update "AGREGAMOS REPOSITORIO PHP"
			echo -e "\n" | sudo add-apt-repository ppa:ondrej/php | tee -a update.cfg tmp.log > /dev/null 2>&1
			ok "${destacar}Repositorio PHP${reset} agregado." false
			log "Se ha agregado el repositorio de PHP. Ver update.cfg"
			sed -i "s/^REPO_PHP=.*/REPO_PHP=1/" "update.cfg"
		else
			ok "${destacar}Repositorio PHP${reset} ya fue agregado."
		fi

	elif [ "$actual_version" = "22.04" ]; then
		#	Desde UBUNTU 22, al hacer upgrade aparece una ventana que requiere interacción.
		#	La desactivamos y reiniciamos los servicios automáticamente.
		sudo echo "\$nrconf{restart} = 'a'; " >> /etc/needrestart/needrestart.conf

		#	APACHE
		if [ "$REPO_APACHE" -eq 0 ]; then
			misubtitulo_log "AGREGAMOS REPOSITORIO APACHE"
			misubtitulo_update "AGREGAMOS REPOSITORIO APACHE"
			echo -e "\n" | sudo add-apt-repository ppa:ondrej/apache2 | tee -a update.cfg tmp.log > /dev/null 2>&1
			ok "${destacar}Repositorio Apache${reset} agregado." false
			log "Se ha agregado el repositorio de Apache2. Ver update.cfg"
			sed -i "s/^REPO_APACHE=.*/REPO_APACHE=1/" "update.cfg"
		else
			ok "${destacar}Repositorio Apache${reset} ya fue agregado." false
			log "No se ha agregado el repositorio de Apache2. Ver update.cfg"
		fi

		#	PHP
		if [ "$REPO_PHP" -eq 0 ]; then
			misubtitulo_log "AGREGAMOS REPOSITORIO PHP"
			misubtitulo_update "AGREGAMOS REPOSITORIO PHP"
			echo -e "\n" | sudo add-apt-repository ppa:ondrej/php | tee -a update.cfg tmp.log > /dev/null 2>&1
			ok "${destacar}Repositorio PHP${reset} agregado." false
			log "Se ha agregado el repositorio de PHP. Ver update.cfg"
			sed -i "s/^REPO_PHP=.*/REPO_PHP=1/" "update.cfg"
		else
			ok "${destacar}Repositorio PHP${reset} ya fue agregado."
		fi

	elif [ "$actual_version" = "23.10" ]; then
		echo "Se instalara para Ubuntu 23.10 Mantic Minotaur"
	else
		log "Error 401 - No se reconoce la version de Ubuntu. ($actual_version)" 
		error "Por favor comunicate con Fibercat para resolver esta incidencia.(401)" false
	fi
elif [ "$actual_DIST" = "debian" ]; then
	if [ "$actual_version" = "11.8" ]; then
		#	Hasta el 11 de febrero de 2024
		echo "Se instalara para Debian 11.8 bullseye"
	elif [ "$actual_version" = "11.9" ]; then
		#	Desde el 10 de febrero de 2024
		echo "Se instalara para Debian 11.9 bullseye"		
	elif [ "$actual_version" = "12.5" ]; then
		#	Desde el 10 de febrero de 2024
		echo "Se instalara para Debian 12.5 bookworm"	
	elif [ "$actual_version" = "13" ]; then
		#	Salida aun no decidida
		echo "Se instalara para Debian 13 trixie"				
	else
		log "Error 402 - No se reconoce la version de Debian. ($actual_version)" 
		error "Por favor comunicate con Fibercat para resolver esta incidencia.(402)" false
	fi
else
	log "Error 403 - No se reconoce la distribución. ($actual_version)" 
	error "Por favor comunicate con Fibercat para resolver esta incidencia.(403)" false
fi
log "Se ha agregado el repositorio de Apache y PHP"
echo "------------------------------------------------------------------" >> update.cfg
log "------------------------------------------------------------------"

sleep $PAUSA_CORTA

#					ACTUALIZAMOS REPOSITORIOS
#------------------------------------------------------------------
misubtitulo "Actualizamos los repositorios"

TIEMPO_ACTUAL=$(date +%s)
TIEMPO_TRANS_UPDATE=$((TIEMPO_ACTUAL - ULTIMA_ACTUALIZACION))

# Verificar si $TIEMPO_TRANS_UPDATE es mayor o igual a 3600
if [ "$TIEMPO_TRANS_UPDATE" -ge "$TIEMPO_ENTRE_ACTUALIZACIONES" ]; then
	misubtitulo_update "ACTUALIZAMOS REPOSITORIOS"
	misubtitulo_log "ACTUALIZAMOS REPOSITORIOS"
	destacar "Actualizando los repositorios. Espere por favor..."
	echo -e "\n" | sudo apt-get update -y | tee -a update.cfg tmp.log > /dev/null 2>&1
	sed -i "s/^ULTIMA_ACTUALIZACION=.*/ULTIMA_ACTUALIZACION=$TIEMPO_ACTUAL/" "update.cfg"
	ok "Se ha realizado la actualización de los repositorios."
else
	ok "El tiempo transcurrido ($TIEMPO_TRANS_UPDATE) es menor a $TIEMPO_ENTRE_ACTUALIZACIONES segundos. No se realiza ninguna acción."
fi

sleep $PAUSA_CORTA

#					ACTUALIZAMOS APLICACIONES
#------------------------------------------------------------------
misubtitulo "Actualizamos las apps"

TIEMPO_TRANS_UPGRADE=$((TIEMPO_ACTUAL - ULTIMO_UPGRADE))
# Verificar si $TIEMPO_TRANS_UPGRADE es mayor o igual a 3600
if [ "$TIEMPO_TRANS_UPGRADE" -ge "$TIEMPO_ENTRE_ACTUALIZACIONES" ]; then
	misubtitulo_update "ACTUALIZAMOS LAS APPS"
	misubtitulo_log "ACTUALIZAMOS LAS APPS"
	destacar "Actualizando las aplicaciones. Espere por favor..."
	sudo apt-get upgrade -y  2>&1 | tee -a update.cfg tmp.log > /dev/null
	sed -i "s/^ULTIMO_UPGRADE=.*/ULTIMO_UPGRADE=$TIEMPO_ACTUAL/" "update.cfg"
	ok "Se ha realizado la actualización de las aplicaciones."
else
	ok "El tiempo transcurrido ($TIEMPO_TRANS_UPDATE) es menor a $TIEMPO_ENTRE_ACTUALIZACIONES segundos. No se realiza ninguna acción."
fi

sleep $PAUSA_CORTA

#					FIREWALL
#------------------------------------------------------------------
misubtitulo "El Firewall"
mititulo_log "EL FIREWALL UFW"
# Verificar si UFW está instalado
if command -v ufw &> /dev/null; then
   	ok "UFW está instalado en el sistema."
else
	misubtitulo_log "Instalamos UFW"
	destacar "Instalando UFW. Espere por favor..."
    echo -e "\n" | sudo apt-get install ufw -y  2>&1 | tee -a tmp.log > /dev/null
	ok "Se ha instalado UFW (El Firewall no complicado)."
fi

sleep $PAUSA_CORTA

#					FIREWALL: BLINDAJE
#------------------------------------------------------------------
misubtitulo "El Firewall: EL BLINDAJE. AHORA ES PERSONAL."
misubtitulo_log "Aplicando configuraciones del firewall"
sudo echo -e "s" | ufw default deny incoming >> tmp.log 2>&1  # Deniega todas las conexiones entrantes por defecto
sudo echo -e "s" | ufw allow 22/tcp >> tmp.log 2>&1           # Permite conexiones al puerto 22 (SSH)
sudo echo -e "s" | ufw enable >> tmp.log 2>&1 
sudo systemctl restart ufw >> tmp.log 2>&1 
log "Se ha habilitado el firewall y aplicado sobre el puerto 22."

sleep $PAUSA_CORTA

#					COMPILACIÓN
#------------------------------------------------------------------
# Verificar si esta instalado make
if command -v make &> /dev/null; then
   	ok "Make  está instalado en el sistema."
else
	misubtitulo_log "Instalamos UFW"
	destacar "Instalando UFW. Espere por favor..."
    echo -e "\n" | sudo apt-get install ufw -y  2>&1 | tee -a tmp.log > /dev/null
	ok "Se ha instalado UFW (El Firewall no complicado)."
fi

sleep $PAUSA_CORTA

#					APACHE
#------------------------------------------------------------------
mititulo "INSTALACIÓN Y CONFIGURACIÓN DE APACHE"
misubtitulo "Instalando Apache 2.4"
misubtitulo_log "Instalando Apache 2.4"

#	Verificamos la instalacion de apache
if command -v apache2 &> /dev/null; then
   	ok "Apache está instalado en el sistema."
	sudo echo -e "s" | ufw allow 80/tcp >> tmp.log 2>&1           # Permite conexiones al puerto 80, 8080 (SSH)
	sudo echo -e "s" | ufw allow 8080/tcp >> tmp.log 2>&1           # Permite conexiones al puerto 22 (SSH)
else
	misubtitulo_log "Instalamos Apache 2.4"
	destacar "Instalando Apache 2. Espere por favor..."
    echo -e "\n" | sudo apt-get install apache2 -y  2>&1 | tee -a tmp.log > /dev/null
	sudo echo -e "s" | ufw allow 80/tcp >> tmp.log 2>&1           # Permite conexiones al puerto 80, 8080 (SSH)
	sudo echo -e "s" | ufw allow 8080/tcp >> tmp.log 2>&1           # Permite conexiones al puerto 22 (SSH)
	ok "Se ha instalado Apache2."
fi

sleep $PAUSA_CORTA

#					PHP
#------------------------------------------------------------------
#	Verificamos la instalacion de apache
	mititulo "INSTALACIÓN Y CONFIGURACIÓN DE PHP"
	misubtitulo "Instalando PHP 8.3"
if command -v php &> /dev/null; then
   	ok "PHP está instalado en el sistema."
else
	misubtitulo_log "Instalando PHP 8.3"
	destacar "Instalando PHP 8.3. Espere por favor..."
	echo -e "\n" | sudo apt-get install php8.3 libapache2-mod-php8.3 php-mysql -y  2>&1 | tee -a tmp.log > /dev/null
	systemctl restart apache2.service
	ok "Se ha instalado PHP 8.3."
fi
