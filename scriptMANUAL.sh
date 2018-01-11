#!/bin/sh

backup_user='daniel.bascon'
backup_mode='Manual'

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
    label=$( echo $consulta | cut -d " " -f 4 )
    status=$( echo $consulta | cut -d " " -f 5 )
    backup_date=$( echo $consulta | cut -d " " -f 6-7 )

	if [[ $label == 'F' ]]; then
    	backup_label="Completa $host"
    	backup_description="Completa"
    else
    	backup_label="Incremental $host"
    	backup_description="Incremental"
    fi

	if [[ $status == 'T' ]]; then
	        backup_status='200'
	else
	        backup_status='400'
    	echo "No se ha realizado la copia la seguridad bien" |  sendmail  subject danibascon1991@gmail.com
	fi
	
	psql -h 172.22.200.110 -U $backup_user -d db_backup -c "insert into backups (backup_user, backup_host, backup_label, backup_description, backup_status, backup_mode) values('$backup_user', '$backup_host','$backup_label','$backup_description', '$backup_status', '$backup_mode' );"
done