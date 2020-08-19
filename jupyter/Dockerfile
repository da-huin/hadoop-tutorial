FROM ubuntu:20.04

ENV TZ Asia/Seoul
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install python3 -y
RUN apt-get install python3-pip -y
RUN pip3 install --upgrade pip

RUN pip3 install jupyterlab "ipywidgets>=7.5"
RUN pip3 install requests
RUN pip3 install happybase

CMD jupyter lab --ip=0.0.0.0 --port=8888 --allow-root