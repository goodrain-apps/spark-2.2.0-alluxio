#!/usr/bin/env bash

# export SPARK_DIST_CLASSPATH=$(hadoop classpath)
export SPARK_CLASSPATH=/opt/java/alluxio-core-client-runtime-1.5.0-jar-with-dependencies.jar:$SPARK_CLASSPATH
