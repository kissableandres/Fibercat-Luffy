# Fibercat Luffy
Fibercat Luffy es un script Bash diseñado para facilitar la instalación de un servidor de administración en VPS con características esenciales. Actualmente, el sistema está optimizado para Ubuntu 22.04.
## Características
- **Apache 2.4:** El Proyecto Apache HTTP Server es un esfuerzo colaborativo de desarrollo de software con el objetivo de crear una implementación de código fuente robusta, de calidad comercial, con muchas características y de libre disponibilidad de un servidor HTTP (Web). El proyecto es gestionado de manera conjunta por un grupo de voluntarios ubicados en todo el mundo, que utilizan Internet y la Web para comunicarse, planificar y desarrollar el servidor y su documentación relacionada. Este proyecto es parte de la Fundación Apache Software. Además, cientos de usuarios han contribuido con ideas, código y documentación al proyecto. Este archivo tiene la intención de describir brevemente la historia del servidor Apache HTTP y reconocer a los numerosos contribuyentes.
- **PHP 8.x:** Un lenguaje de programación de propósito general muy popular, especialmente adecuado para el desarrollo web. Rápido, flexible y práctico, PHP impulsa desde tu blog hasta los sitios web más populares del mundo.
- **MariaDB:** MariaDB Server es una de las bases de datos relacionales de código abierto más populares del mundo y está disponible en los repositorios estándar de todas las principales distribuciones de Linux. Busca el paquete mariadb-server utilizando el gestor de paquetes de tu sistema operativo.
- **OpenSSH:** OpenSSH es la herramienta principal de conectividad para inicio de sesión remoto con el protocolo SSH. Encripta todo el tráfico para eliminar el espionaje, el secuestro de conexiones y otros tipos de ataques. Además, OpenSSH proporciona una amplia gama de capacidades de túneles seguros, diversos métodos de autenticación y opciones de configuración sofisticadas.

## Instalación

### Desde Github
1. Ingresa al directorio home del usuario (No se instalará en ese directorio). 
2. Clona el repositorio en tu servidor:
   ```bash
   git clone https://github.com/kissableandres/Fibercat-Luffy.git
3. Edita las configuraciones de los siguientes archivos:
- config.cfg
```
DOMAIN="my.domain.com" 		#	my.domain.com
SERVERDIRECTORY="fibercat_luffy"#	Rutas
ADMINMAIL="myemail@domain.com"	#	Correo del servidor
SUDOUSER="mysudoeruser"         #      Usuario con privilegios de Sudo

```
- ssh_key.cfg

Cambia `INSTALL=false` a `INSTALL=true` y el sistema isntalará automaticamente tu ssh. \
En caso que necesites crear un par, coloca `INSTALL=giveme`\
\
Cambia `PUBLIC="Generic"` por clave publica como por ejemplo: `PUBLIC="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDExAMPLE1xI7xH5U9BAk8gIISFgjEjM1j+uaW1i1t+kgq8j2ee1m/Zynh2ys4tF4kIqj1Yj1iiaZfg/MNHD/NhE5YOWm+H8VYNw== example@example.com"`\
\
Cambia `PRIVATE="Generic"` por clave privada como por ejemplo: `PRIVATE="myprivaterh"`\
\
***Ten en cuenta que, por seguridad, el archivo ssh_key.cfg se eliminará al termino de la instalación.***

3. Ingresa y da los permisos necesarios
   ```bash
   cd Fibercat-Luffy
   ```
    ```bash
   sudo chmod 764 install_multi.sh
   ```
    ```bash
   sudo ./install_multi.sh
   ```
    O todo de una sola vez
    ```bash
   cd Fibercat-Luffy && sudo chmod 764 install_multi.sh && sudo ./install_multi.sh
   ```

### Desde el servidor de Fibercat Networks Spa.
- Proximamente

## Contribuciones
¡Las contribuciones son bienvenidas! Si tienes ideas para nuevas características o mejoras, por favor, ingresa al Discord

[Únete al servidor de Discord](https://discord.gg/PxzVZZcS9v)

## Notas
- Asegúrate de revisar y personalizar la configuración antes de ejecutar el script en un entorno de producción.
- Este proyecto está en constante desarrollo, así que mantente atento a las actualizaciones.
