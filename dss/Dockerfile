FROM dataiku/dss:${DSS_VERSION:-latest}
ENV DSS_INSTALLER_ARGS $DSS_INSTALLER_ARGS
ENV GRAPHITE_HOST=$GRAPHITE_HOST \
    GRAPHITE_PORT=$GRAPHITE_PORT
#   add DSS_INSTALLER_ARGS dss entrypoint run.sh
USER root
COPY build.sh .
RUN set -e ; bash build.sh && rm -rf build.sh

USER dataiku
# Add monitoring
RUN dataiku-dss-$DSS_VERSION/scripts/install/download-monitoring-packages.sh
