#!/bin/bash

if [[ -d $ORACLE_BASE/patches/apex ]]
then
	if [[ $( ls -A $ORACLE_BASE/patches/apex/*.zip ) ]]
	then

		APEX_INSTALL_PACKAGE=$( ls $ORACLE_BASE/patches/apex/*.zip | xargs -n 1 basename | sort -n | head -n 1 )

		printf "\nCopying APEX Install Package $APEX_INSTALL_PACKAGE for Installation into Oracle Database\n\n"

		cp $ORACLE_BASE/patches/apex/$APEX_INSTALL_PACKAGE /opt/oracle/scripts/setup/
		unzip -q /opt/oracle/scripts/setup/$APEX_INSTALL_PACKAGE -d /opt/oracle/scripts/setup/
	fi
fi 

$ORACLE_BASE/$RUN_FILE