#!/bin/sh


#coconut	172.22.200.127	panel grafico
#coconut	172.22.200.110	postgres


#backup_user='daniel.bascon'
backup_description='Incremental'
backup_mode='Automatica'
backup_node_dir="172.22.200.110"


#backup_user  usuario
#backup_host   ip               
#backup_label  tipo de copia                     
#backup_description   comentario   
#backup_status codigo (200 o 400)
#backup_date    fecha   
#backup_mode    manual o automatico




for (( i=1 ; i < 5 ; i++ )) ; do
	#Definicion de las maquinas con su respectiva ip
	case $i in
                1)
 					host='graph'
					backup_host='172.22.200.182'
					;;
                2)
 					host='mickey'
					backup_host='172.22.200.99'
					;;
                3)
 					host='minnie'
					backup_host='172.22.200.94'
					;;				
                4)
 					host='donald'
					backup_host='172.22.200.93'
					;;
	esac

    consulta=$(mariadb -u root -e "select Level, JobStatus, RealEndTime from bacula.Job where RealEndTime in (select max(RealEndTime) from bacula.Job group by Name) and Name='$host' group by Name;")
       
    backup_label=$( echo $consulta | cut -d " " -f 4 )
    backup_status=$( echo $consulta | cut -d " " -f 5 )
    backup_date=$( echo $consulta | cut -d " " -f 6-7 )

    echo $backup_label
    echo $backup_status
    echo $backup_date



#Se consulta a la base de datos de bacula  y se obtiene los parametros necesarios para el registo de la copia y todo ello se guarda en una variable
mickey1=$( mariadb -u root -p'root' -e 'select Level, JobStatus, RealEndTime, (JobBytes/1024)/1024 from bacula.Job where RealEndTime in (select max(RealEndTime) from bacula.Job group by Name) and type="B" and Name="mickey" group by Name;')
#Se filtra la fecha de esa consulta realizada para comparar posteriormente
mickey2=$( echo $mickey1 | cut -d " " -f 7 | cut -d "-" -f 3)
#Se obtiene la fecha actual del sistema, filtrando el dia
mickey3=$( date +%d )
#Se filtra la fecha y hora para registrar dicha actividad
mickey_fecha=$( echo $mickey1 | cut -d " " -f 7-8)
#Se filtra la informacion de la consulta realizada para obtener el estado de la copia si ha sido correcto o no
mickey_estado=$( echo $mickey1 | cut -d " " -f 6)
#Se filta la informacion de la consulta realizada para obtener que tipo de copia se ha realizado si es completa, diferencial o incremental
mickey_tipo=$( echo $mickey1 | cut -d " " -f 5)
#Se filta la informacion de la consulta realizada para obtener el tamano de dicha copia
mickey_tamano=$( echo $mickey1 | cut -d " " -f 9)










done 



#mariadb -h 172.22.200.182 -u root -p'bacula' -e














#        mariadb -u root -e "select Level, JobStatus, RealEndTime from bacula.Job where RealEndTime in (select max(RealEndTime) from bacula.Job group by Name) and Name='mickey' group by Name;"







#psql -h 172.22.200.110 -U daniel.bascon -d db_backup -c "insert into backups (backup_user, backup_host, backup_label, backup_description, backup_status,backup_date, backup_mode) values('daniel.bascon',)"
