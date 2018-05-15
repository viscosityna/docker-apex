#!/bin/bash

printf "\n\nObtaning Oracle Database version\n\n"

ORACLE_DB_VERSION=$($ORACLE_HOME/OPatch/opatch lsinventory | awk '/^Oracle Database/ {print $NF}')

printf "Oracle Database version: $ORACLE_DB_VERSION found\n\n"

if [[ $ORACLE_DB_VERSION = "12.1.0.2.0" ]] 
then

	printf "Applying Datapatch Patch 20618595: DBA_CONSTRAINTS RETURNS WRONG CONSTRAINT_NAME FOR SYSTEM GENERATED IN PDBS\n\n"
	printf "to Oracle Database version $ORACLE_DB_VERSION\n\n"

	cd $ORACLE_HOME/patch_top/p20618595_121020_Linux-x86-64/20618595
	datapatch
	# TODO: Capture and verify successful execution of datapatch
fi
