FROM goodrainapps/hadoop:2.8.0
MAINTAINER zengqg@goodrain.com

# Version
ENV SPARK_VERSION=2.2.0

# Set home
ENV SPARK_HOME=/usr/local/spark-$SPARK_VERSION

# Install dependencies
RUN apk add --no-cache python3 python

# Install Spark
RUN mkdir -p "${SPARK_HOME}" \
  && export ARCHIVE=spark-$SPARK_VERSION-bin-without-hadoop.tgz \
  && export DOWNLOAD_PATH=apache/spark/spark-$SPARK_VERSION/$ARCHIVE \
  && curl -sSL https://mirrors.tuna.tsinghua.edu.cn/$DOWNLOAD_PATH | \
    tar -xz -C $SPARK_HOME --strip-components 1 \
  && rm -rf $ARCHIVE
COPY spark-env.sh $SPARK_HOME/conf/spark-env.sh
ENV PATH=$PATH:$SPARK_HOME/bin

# Ports
EXPOSE 6066 7070 8080 8081

# Copy start script
COPY start-spark /opt/util/bin/start-spark

# Copy alluxio-core-client jar  
COPY alluxio-core-client-runtime-1.5.0-jar-with-dependencies.jar /opt/java/alluxio-core-client-runtime-1.5.0-jar-with-dependencies.jar
# Fix environment for other users
RUN echo "export SPARK_HOME=$SPARK_HOME" >> /etc/bash.bashrc \
  && echo 'export PATH=$PATH:$SPARK_HOME/bin'>> /etc/bash.bashrc

# Add deprecated commands
RUN echo '#!/usr/bin/env bash' > /usr/bin/master \
  && echo 'start-spark master' >> /usr/bin/master \
  && chmod +x /usr/bin/master \
  && echo '#!/usr/bin/env bash' > /usr/bin/worker \
  && echo 'start-spark worker $1' >> /usr/bin/worker \
  && chmod +x /usr/bin/worker

ENV SPARK_MASTER_HOST 127.0.0.1
ENV SPARK_MASTER_PORT 7070
