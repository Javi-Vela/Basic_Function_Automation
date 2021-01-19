#!/bin/bash

#
#  Archivo con el código asociado operaciones extra
#


mostrar_menu(){    
	clear	
    echo -e "\n \n"
    echo "*************** MENU PRINCIPAL MI SCRIPT MÓDULO ISO *******************************"
    echo -e "\n \n"
	echo -e "\t [u] ---> Gestionar Usuarios"
    echo -e "\t [d] ---> Gestionar Disco"
    echo -e "\t [p] ---> Gestionar Procesos"
    echo -e "\n"
    echo "[s]----------------------> Salir del script"
    echo "***********************************************************************************"  
	echo -e "\n"
	echo "seleccionar una opcion"	
	read opcion
}

mostrar_menu_procesos()
{
	clear
    echo -e "\n \n"
    echo "*************** Ha seleccionado la opción GESTIONAR PROCESOS *******************************"
    echo -e "\n"
	echo -e "\t [x] ---> Gestionar Proceso"
    echo -e "\t [y] ---> Gestionar Prioridades"
    echo -e "\t [z] ---> lanzar un comando en suegundo plano"
    echo -e "\t [t] ---> mostrar informacion de procesos"
    echo -e "\n"
	echo "[e]----------------------> volver al menu principal"
    echo "[s]----------------------> salir del programa"
    echo "***********************************************************************************"  
	echo -e "\n"
	echo "seleccionar una opcion"
}

mostrar_menu_discos()
{
	clear
    echo -e "\n \n"
    echo "*************** Ha seleccionado la opción GESTIONAR PROCESOS *******************************"
    echo -e "\n"
	echo -e "\t [x] ---> Crear dos particiones de disco"
    echo -e "\t [y] ---> Borrar las dos particiones primarias"
    echo -e "\t [z] ---> Montar un raid 5"
    echo -e "\t [t] ---> Borrar 5"
	echo -e "\t [d] ---> Simular un fallo en el raid 5"
	echo -e "\t [p] ---> Informacion de los discos"
    echo -e "\n"
	echo "[e]----------------------> volver al menu principal"
    echo "[s]----------------------> salir del programa"
    echo "***********************************************************************************"  
	echo -e "\n"
	echo "seleccionar una opcion"
}

mostrar_menu_usuarios()
{
	clear
    echo -e "\n \n"
    echo "*************** Ha seleccionado la opción GESTIONAR PROCESOS *******************************"
    echo -e "\n"
	echo -e "\t [x] ---> creacion del grupo"
    echo -e "\t [y] ---> Creaciond e usuarios"
    echo -e "\t [z] ---> asignacion de contraseña"
    echo -e "\t [t] ---> eliminacion de usuarios y grupos"
	echo -e "\t [d] ---> instalacion de paqueteria"
    echo -e "\n"
	echo "[e]----------------------> volver al menu principal"
    echo "[s]----------------------> salir del programa"
    echo "***********************************************************************************"  
	echo -e "\n"
	echo "seleccionar una opcion"
}

informacion_final_salir(){ 
	clear;
	echo "Ha seleccionado salir del script......."
	
	# Instalar juegos cowsay y fortune	
	apt install cowsay > /dev/null 2>&1
	apt install fortune-mod > /dev/null 2>&1
	
	# Crear enlaces simbólicos para ejecutar des el bash los juegos cowsay y fortune
	ln -s /usr/games/cowsay /usr/bin/cowsay > /dev/null 2>&1
	ln -s /usr/games/cowthink /usr/bin/cowthink > /dev/null 2>&1

	# Ejecutar juegos instalados
	cowsay -f $(ls /usr/share/cowsay/cows/ | sort -R | head -1) $(fortune -s)
}
