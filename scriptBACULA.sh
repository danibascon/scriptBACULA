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




for (( i=1 ; i < 5 ; i++ )) ;do
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

    if [ '$backup_label' = 'F' ] ;then
    	backup_label = 'Completa $host'
    else
    	backup_label = 'Incremental $host'
    fi

    if [ '$backup_status' = 'T' ] ;then
    	backup_status = '200'
    else
    	backup_status = '400'
    	echo "No se ha realizado la copia la seguridad bien" |  sendmail  subject danibascon1991@gmail.com
    fi


    echo 'daniel.bascon'
    echo $backup_host
    echo $backup_label
    echo $backup_description
    echo $backup_status
    echo $backup_date
    echo ''






done 



#mariadb -h 172.22.200.182 -u root -p'bacula' -e














#        mariadb -u root -e "select Level, JobStatus, RealEndTime from bacula.Job where RealEndTime in (select max(RealEndTime) from bacula.Job group by Name) and Name='mickey' group by Name;"







#psql -h 172.22.200.110 -U daniel.bascon -d db_backup -c "insert into backups (backup_user, backup_host, backup_label, backup_description, backup_status,backup_date, backup_mode) values('daniel.bascon',)"
