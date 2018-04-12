ARG oracle_db_edition=se2
ARG oracle_db_version=12.2.0.1

FROM oracle/database:${oracle_db_version}-${oracle_db_edition}

USER oracle:oinstall 

COPY --chown=oracle:oinstall entrypoint.sh ./entrypoint.sh
COPY --chown=oracle:oinstall installApex.sh ./installApex.sh

RUN mkdir $ORACLE_BASE/patches && \
	chmod +x ./entrypoint.sh && \
	chmod +x ./installApex.sh && \
	mv installApex.sh /opt/oracle/scripts/setup/02_installApex.sh

VOLUME ["$ORACLE_BASE/patches"]

ENTRYPOINT ["sh","-c","./entrypoint.sh"]
