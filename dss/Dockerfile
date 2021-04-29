FROM dataiku/dss:${DSS_VERSION:-latest}
ENV DSS_INSTALLER_ARGS $DSS_INSTALLER_ARGS
#   add DSS_INSTALLER_ARGS dss entrypoint run.sh
USER root
RUN sed -i -e 's/installer.sh/installer.sh $DSS_INSTALLER_ARGS /g' run.sh ; \
    chown root. run.sh
USER dataiku
