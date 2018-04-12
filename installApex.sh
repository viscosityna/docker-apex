#!/bin/bash

if [[ -d /opt/oracle/scripts/setup/apex ]]
then

	printf "\n\nObtaning Oracle Database version\n\n"

	ORACLE_DB_VERSION=$($ORACLE_HOME/OPatch/opatch lsinventory | awk '/^Oracle Database/ {print $NF}')

	printf "Oracle Database version: $ORACLE_DB_VERSION found\n\n"

	if [[ $ORACLE_DB_VERSION = "12.1.0.2.0" ]] 
	then
		cd $ORACLE_HOME/apex

		printf "Installing APEX in a 12c (12.1) Database need to remove old APEX version from CDB first\n\n"
		printf "Removing any previous version of APEX from CDB\n\n"

		sqlplus /nolog <<EOF
connect / as sysdba
@apxremov_con.sql
exit
EOF
		printf "\n\nPrevious version of APEX removed successfully\n\n"
	fi

	cd /opt/oracle/scripts/setup/apex

	printf "Installing APEX in pluggable database: $ORACLE_PDB\n"
	printf "ORACLE PASSWORD FOR APEX_PUBLIC_USER, APEX_LISTENER, APEX_REST_PUBLIC_USER: $ORACLE_PWD\n\n"
	printf "Creating tablespace 'apex_ts' in pluggable database: $ORACLE_PDB with datafile: '$ORACLE_BASE/oradata/$ORACLE_SID/$ORACLE_PDB/apex_ts.dbf'\n\n"

	sqlplus /nolog <<EOF
connect / as sysdba
alter session set container = $ORACLE_PDB;
create tablespace apex_ts datafile '$ORACLE_BASE/oradata/$ORACLE_SID/$ORACLE_PDB/apex_ts.dbf' size 1G autoextend on;
exit
EOF

printf "\n\nStarting installation of APEX in pluggable database: $ORACLE_PDB\n\n"

	sqlplus /nolog <<EOF
connect / as sysdba
alter session set container = $ORACLE_PDB;
@apexins.sql apex_ts apex_ts TEMP /i/
exit
EOF

	printf "\n\nSetting up APEX users\n\n"

	sqlplus /nolog <<EOF
connect / as sysdba
alter session set container = $ORACLE_PDB;
alter user apex_public_user identified by $ORACLE_PWD account unlock;
@apex_rest_config_core.sql $ORACLE_PWD $ORACLE_PWD
exit
EOF
else
	printf "\n\nDid NOT find an APEX Installation Package\n\n"
fi