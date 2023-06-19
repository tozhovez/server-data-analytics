FROM openjdk:11.0.16-jre-slim-buster

ENV HADOOP_VERSION=3.3.3
ENV METASTORE_VERSION=3.0.0

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-metastore-${METASTORE_VERSION}-bin

WORKDIR /opt

RUN set -eux; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        netcat \
        curl \
        libssl-dev && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L https://downloads.apache.org/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
    curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
    curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.tar.gz | tar zxf - && \
    cp mysql-connector-java-8.0.19/mysql-connector-java-8.0.19.jar ${HIVE_HOME}/lib/ && \
    rm -rf mysql-connector-java-8.0.19 && \
    rm -rf hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz && \
    rm -rf hadoop-${HADOOP_VERSION}.tar.gz && \
    rm -rf mysql-connector-java-8.0.19.tar.gz 

COPY entrypoint.sh /entrypoint.sh
#COPY metastore-site.xml ${HIVE_HOME}/conf
#RUN groupadd -r hive --gid=1000 && \
#    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
#    chown hive:hive -R ${HIVE_HOME} && \
#    chown hive:hive /entrypoint.sh && \
#    chmod +x /entrypoint.sh
RUN chmod +x /entrypoint.sh

#USER hive
EXPOSE 9083

ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]