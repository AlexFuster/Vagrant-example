#!/bin/bash
# ipa-server-addusers.sh

source /vagrant/scripts/common.sh

#
# NOTA PREVIA GENERAL:
# 
#       En este script se han omitido expresamente algunas comprobaciones
#       previas a cada acción, y en general todas las comprobaciones de error.
#       Se deja al alumno que las implemente como desee, así como algunas acciones
#       que se comentan pero no se resuelven.
#

# DATOS DE ENTRADA (desde Vagrantfile):
#
# - fich_usuarios (fichero): nombre de fichero CSV que contiene los 
#                            usuarios a crear.
#                            Parámetro obligatorio.
#
#       En el fichero, hay una línea por cada usuario, y sus datos son los
#       siguientes, en orden y separados por comas:
#
#       login_name,contraseña,Nombre,Apellidos
#


# 0) Comprobación previa de parámetros de entrada obligatorios
if [ $# -lt 1 ]
	then echo "Error: faltan argumentos"
	exit 1
fi
fich_usuarios=$1
# 1) Comprobamos la existencia del fichero de usuarios (relativo al directorio
#    actual "./scripts/") y en caso contrario salimos con error.
if [ ! -e /vagrant/scripts/$fich_usuarios ]
	then echo "El fichero de usuarios no existe"
	exit 1
fi

# 2) Comprobamos la existencia del dominio IPA (solicitando un tique Kerberos
#    para admin@ADMON.LAB) y en caso contrario salimos con error.
echo ${PASSWD_ADMIN} | kinit "admin@${DOMINIO_KERBEROS}" 2>/dev/null 1>/dev/null
if [[ "$?" != "0" ]]
	then echo "El dominio IPA no existe"
	exit 1 	
fi



# 3) Procesamos el fichero CSV:
#
declare -a v
cat /vagrant/scripts/$fich_usuarios | while read linea # Para cada línea:
		
	do for (( i=0; i<4; i++ ))
		do v[$i]=${linea%%,*}
		linea=${linea#*,}
	done
	login_name=${v[0]}
	password=${v[1]}
	Nombre=${v[2]}
	Apellidos=${v[3]}
	ipa user-show ${login_name} 2>/dev/null 1>/dev/null #  Comprobamos si el usuario ya existe
	if [[ "$?" != "0" ]] #  y en caso contradio:
		then echo $password | ipa user-add ${login_name} --first ${Nombre} --last "${Apellidos}" --password #lo creamos, mediante la orden ipa user-add
	fi
done
 





