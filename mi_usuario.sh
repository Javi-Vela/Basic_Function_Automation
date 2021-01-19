#!/bin/bash

#
#  Archivo con el código asociado a la gestión de Usuarios
#


informacion_inicial_usuarios()
{     
	while !([ $opcion = 'e' ])
	do	  
		mostrar_menu_usuarios
		read opcion
		case $opcion in 
			x)
				creacion_grupos;;
			y)
				creacion_usuario;;
			z)
				asignacion_contrasenas;;
			t)
				eliminar_user;;
			d)	
				paqueteria;;
			s)
				echo "estas saliendo del script"
				exit 1;;
			e)
				echo "vas a salir al menu principal";;
			*)
				echo "opcion no valida"
		esac
	done    
}



creacion_grupos()
{   
	clear 
	echo "introduce el nombre del grupo que deseas crear"
	read grupo
    echo "introduce el GID que seas que tenga el grupo"
	read GID
	groupadd $grupo -g $GID  
	verificacion_grupo $grupo 
	echo "deseas crear otro grupo? (s/n)"
	read opcion
	if [ $opcion = 's' ]; then 
		creacion_grupo
	fi
	read parada
}

creacion_usuario()
{
	clear
	echo "introduce el nombre del usuario que deseas crear"
	read usuario
	echo "introduce el grupo al que quieras que pertenezca (nombre/GID)"
	read grupo2
	echo "introduce el UID que desas que tenga"
	read uid
	useradd $usuario -g $grupo2 -u $uid -m
	echo "el usuario" $usuario "se ha creado correctamente"
	echo "deseas crear otro usuario? (s/n)"
	read opcion1
	if [ $opcion1 = 's' ]; then
		creacion_usuario
	fi
	verificacion_usuario $usuario
	read parada
}

asignacion_contrasenas()
{
	clear
	echo "introduce el nombre del usuario que desas cambiar la contraseña"
	read usuario
	verificacion_usuario $usuario
	echo "introduce la nueva contraseña"
	read contrasena
	echo "introduce de nueva la nueva contraseña"
	read contrasena2
	if [ $contrasena != $contrasena2 ]; then
		echo "las contraseñas no coinciden no se va a cambiar"
	else
		echo "deseas que la contraseña sea " $contrasena " ? (s/n)"
		read comprobacion
		if [ $comprobacion = 's' ]; then
			passwd $usuario > /dev/null 2>&1 <<EOF
$contrasena
$contrasena2
EOF
		fi
		echo "se ha cambiado la contraseña del usuario " $usuario
	fi
}

eliminar_user()
{
	clear
	echo "deseas eliminar un usuario? (s/n)"
	read opcion
	if [ $opcion = 's' ]; then
		echo "introduce el usuario que desas eliminar"
		read usuario
		borrar_usuario $usuario
		verificacion_usuario $usuario
	fi
	echo "deseas eliminar un grupo? (s/n)"
	read opcion3
	if [ $opcion3 = 's' ]; then
		echo "introduce el grupo que deseas eliminar"
		read grupo_del
		borrar_grupo $grupo_del
	fi
}

borrar_usuario()
{
	echo "si tiene un grupo con su nombre tambien lo deseas eliminar? (s/n)"
	read opcion 
	if [ $opcion = 's' ]; then
		borrar_grupo $1
	fi
	echo "deseas eliminar su directorio? (s/n)"
	read opcion2
	if [ $opcion = 's' ]; then
		rm -r /home/$1
	fi
	userdel $1
}

borrar_grupo()
{
	grupodel $1
	verificacion_grupo $1
}

paqueteria()
{
	clear
	echo "introduce el paquete que deseas instalar"
	read paquete
	apt-get install $paquete 2>&1 /dev/null
}

verificacion_usuario() 
{
	cat /etc/passwd | grep $1 2>&1 /dev/null
	if [ $? -eq 0 ]; then
		echo "el usuario no existe"
	else 
		echo "existe el usuario que estas buscando"
	fi
}

verificacion_grupo() 
{
	cat /etc/group | grep $1 2>&1 /dev/null 
	if [ $? -eq 0 ]; then
		echo "el usuario no existe"
	else
		echo "existe el grupo que estas buscando"
	fi
}
