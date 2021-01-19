#!/bin/bash

#
source mi_extra.sh
#


informacion_inicial_procesos()
{    
	while !([ $opcion = 'e' ])
	do	  
		mostrar_menu_procesos
		read opcion
		case $opcion in 
			x)
				gestionar_procesos;;
			y)
				gestionar_prioridades;;
			z)
				lanzar_segundo_plano;;
			t)
				mostar_procesos;;
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



gestionar_procesos()
{    
    	
    echo "mostrar informacion de los procesos"
	ps -la
	echo "introduce ID del proceso que deseas matar"
	read PID 
	echo "quieres ver las señales existentes? (s/n)"
	read s
	if [ $s = 's' ]; then
		kill -l
	fi
	echo "introduce la señal que deseas ejecutar"
	read senal
	if [ $senal -gt 65 ]; then
		echo "el valor introducido no es valido"
		exit 1
	fi
	kill $senal $PID
	read continuar
}

gestionar_prioridades()
{
	echo "listado de procesos"
	ps -la
	echo "introduce la PID"
	read PID
	echo "introduce la prioridad"
	read prioridad
	renice $prioridad $PID
	if [ $? -eq 0 ]; then 
		echo "has cambiado la prioridad"
		ps -ao stat,pcpu,pid,user,fname,nice
	else
		echo "no se ha cambiado la prioridad"
	fi
	read parada
}

lanzar_segundo_plano()
{
	echo "que comando deseas lanzar?"
	read comando
	echo "desea añadir alguna opcion de comando?"
	read opcion_comando
	$comando $opcion_comando &
	echo "el comando que has lanzado es: $comando $opcion_comando &"
jobs
	read parada
}


mostar_procesos()
{
	echo "deseas ver los procesos en segundo plano (s/n)"
	read ver
	if [ $ver = 's' ]; then
		jobs
		echo parada
	fi
	echo "deseas ver todos los procesos activos? (s/n)"
	read ver2
	if [ $ver2 = 's' ]; then
		ps -la
		read parada
	fi
}



