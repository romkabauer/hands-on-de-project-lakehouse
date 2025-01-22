FROM confluentinc/cp-kafka-connect:7.8.0

WORKDIR /usr/share/java

COPY ./tabular-iceberg-kafka-connect-0.6.19 /usr/share/java/kafka-connect-iceberg/

COPY ./kafka-connect.properties /etc/kafka-connect/config/
COPY ./iceberg-connector-config.properties /etc/kafka-connect/config/

# troubleshooting logs
# COPY ./connect-log4j.properties /etc/kafka/

ENV CONNECT_PLUGIN_PATH="/usr/share/java/kafka-connect-iceberg,/usr/share/java/kafka-connect-jdbc"

EXPOSE 8083

CMD ["/bin/connect-standalone", "/etc/kafka-connect/config/kafka-connect.properties", "/etc/kafka-connect/config/iceberg-connector-config.properties"]