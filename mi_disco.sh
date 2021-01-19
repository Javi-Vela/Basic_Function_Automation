#!/bin/bash
source mi_extra.sh
#
#  Archivo con el código asociado a la gestión de Disco
#

   
informacion_inicial_discos()
{    
	while !([ $opcion = 'e' ])
	do	  
		mostrar_menu_discos
		read opcion
		case $opcion in 
			x)
				practica_6;;
			y)
				borrar_practica_6;;
			z)
				montar_raid_5;;
			t)
				eliminar_raid_5;;
			d)	
				simular_fallo_raid;;
			p)
				informacion_discos;;
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



practica_6()
{    
clear
if [ $usuario != "root" ]; then
   echo El script tiene que ejecutarse con usuario root
   exit 1 
else 
	echo "CORRECTO 1"
fi    
fdisk -l /dev/sdb > /dev/null 2>&1
if [ $? -gt 0 ]; then
   echo No existe el dispositivo a montar
   exit 2
else
	echo "CORRECTO 2"
fi
size=`fdisk -l | grep sdb | tr -s ' ' | cut -d ' ' -f 3`
if [ $size -le 5 ]; then
   echo El disco debe ser mayor que 5
   exit 3
else 
	echo "CORRECTO 3"
fi  
df -h | grep sdb 2>&1
if [ $? -eq 0 ]; then
	echo "ERROR existe sdb"
	df -h | grep sdb1 2>&1
	if [ $? -eq 0 ]; then
		echo "ERROR existe sdb1"
		umount /dev/sdb1 > /dev/null 2>&1
		fdisk /dev/sdb > /dev/null 2>&1 <<EOF
d
1
w
EOF
		rm -r /particion1
	fi
	df -h | grep sdb2 2>&1
	if [ $? -eq 0 ]; then
		echo "ERROR existe sdb2"
		umount /dev/sdb2 > /dev/null 2>&1
		fdisk /dev/sdb > /dev/null 2>&1 <<EOF
d
w
EOF
		rm -r /particion2
	fi
else 
	echo "CORRECTO 4"
fi
fdisk /dev/sdb > /dev/null 2>&1 <<EOF
n
p
1
2048
+5g
n
p



w
EOF
fdisk -l | grep sdb1 > /dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "CORRECTO 5"
else 
	echo "ERROR al crear particion 1"
	exit 4
fi
fdisk -l | grep sdb2 > /dev/null 2>&1
if [ $? -eq 0 ]; then > /dev/null 2>&1
	echo "CORRECTO 6"
else 
	echo "ERROR al crear particion 2"
	exit 5
fi 
cd
mkfs -t ext4 /dev/sdb1 > /dev/null 2>&1
mkfs -t ext4 /dev/sdb2 > /dev/null 2>&1
mkdir /particion1 > /dev/null 2>&1
mount -t ext4 /dev/sdb1 /particion1 > /dev/null 2>&1
mkdir /particion2 > /dev/null 2>&1
mount -t ext4 /dev/sdb2 /particion2 > /dev/null 2>&1

df -h | grep sdb1 > /dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "CORRECTO 7"
else 
	echo "ERROR al montar el primer disco"
	exit 6
fi
df -h | grep sdb2 > /dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "CORRECTO 8"
else 
	echo "ERROR al montar el segundo disco"
	exit 7
fi
cp /home/vela/seguridad_fstab /etc/fstab
cat /etc/fstab > /etc/seguridad_fstab
echo "/dev/sdb1	/particion1	ext4	defaults	2	1
/dev/sdb2	/particion2	ext4	defaults	2	1" >> /etc/fstab

cat /etc/fstab | grep sdb > /dev/null 2>&1
if [ $? -eq 0 ]; then 
	echo "CORRECTO 9"
else
	echo "ERROR al modificar el archivo fstab"
	exit 8
fi
echo "introduce el nombre del usuario al que va a pertener la primera particion"
read nombre_usuario
cat /etc/passwd | grep $nombre_usuario > /dev/null 2>&1
if [ $? -eq 0 ]; then
	cp -r /home/$nombre_usuario /particion1
	echo "CORRECTO 10"
else 
echo "ERROR no existe un usuario con este nombre"
	exit 9
fi
}

borrar_practica_6()
{
	clear
	echo "borrando los cambios de la paractica..."
	umount /dev/sdb1 > /dev/null 2>&1
	umount /dev/sdb2 > /dev/null 2>&1
	fdisk /dev/sdb > /dev/null 2>&1 <<EOF
d
1
d
w
EOF
	rm -r /particion1 > /dev/null 2>&1
	rm -r /particion2 > /dev/null 2>&1
	read parada
}

montar_raid_5()
{
clear
fdisk /dev/sdc > /dev/null 2>&1 <<EOF
n
p



t
L
fd
w
EOF
fdisk /dev/sdd > /dev/null 2>&1 <<EOF
n
p



t
L
fd
w
EOF
fdisk /dev/sde > /dev/null 2>&1 <<EOF
n
p



t
L
fd
w
EOF
fdisk /dev/sdf > /dev/null 2>&1 <<EOF
n
p



t
L
fd
w
EOF
mknod /dev/md0 b 9 5 > /dev/null 2>&1
mdadm --create /dev/md0 --level=raid5 --raid-devices=3 /dev/sdc1 /dev/sdd1 /dev/sde1 --spare-devices=1 /dev/sdf1
read esperar
mkdir /media/mi_raid_5 > /dev/null 2>&1
mkfs.ext4 /dev/md0 > /dev/null 2>&1
mount -t ext4 /dev/md0 /media/mi_raid_5 > /dev/null 2>&1
mdadm --detail /dev/md0
read parada
}

eliminar_raid_5()
{
clear
umount /dev/md0 > /dev/null 2>&1
umount /dev/md127 > /dev/null 2>&1
mdadm --stop /dev/md0
mdadm --remove /dev/md0
mdadm --stop /dev/md127 2> /dev/null 
mdadm --remove /dev/md127 2> /dev/null 
rm -rf /dev/md0 
rm -rf /dev/md127
fdisk /dev/sdc > /dev/null 2>&1 <<EOF
d
w
EOF
fdisk /dev/sdd > /dev/null 2>&1 <<EOF
d
1
w
EOF
fdisk /dev/sde > /dev/null 2>&1 <<EOF
d
w
EOF
fdisk /dev/sdf > /dev/null 2>&1 <<EOF
d
w
EOF
	rm -r /media/mi_raid_5 > /dev/null 2>&1
echo "se ha borrado el raid 5"
read esperar
}

simular_fallo_raid()
{
clear
mdadm --manage /dev/md0 --fail /dev/sdc1 > /dev/null 2>&1
mdadm --detail /dev/md0 
read parada
mdadm --manage /dev/md0 --remove /dev/sdc1 > /dev/null 2>&1
mdadm --detail /dev/md0 
read parada
mdadm --manage /dev/md0 --add /dev/sdc1 > /dev/null 2>&1
mdadm --detail /dev/md0 
echo "se ha simulando un fallo en el raid 5"
read parada
}

informacion_discos()
{
clear
fdisk -l
read parada
}
