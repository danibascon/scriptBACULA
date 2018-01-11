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
    echo $consulta
       
done 



#mariadb -h 172.22.200.182 -u root -p'bacula' -e














#mariadb -u root -e "select name, Level, JobStatus, RealEndTime from bacula.Job where RealEndTime in (select max(RealEndTime) from bacula.Job group by Name) and Name='mickey' group by Name;"







#psql -h 172.22.200.110 -U daniel.bascon -d db_backup -c "insert into backups (backup_user, backup_host, backup_label, backup_description, backup_status,backup_date, backup_mode) values('daniel.bascon',)"
