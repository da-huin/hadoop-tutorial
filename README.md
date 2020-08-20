<p align="center">
  <a href="" rel="noopener">
 <img width=200px height=200px src="./static/icon.png" alt="Project logo" ></a>
 <br>

</p>

<h3 align="center">Hadoop Tutorial</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![GitHub Issues](https://img.shields.io/github/issues/da-huin/hadoop-tutorial.svg)](https://github.com/da-huin/hadoop-tutorial/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/da-huin/hadoop-tutorial.svg)](https://github.com/da-huin/hadoop-tutorial/pulls)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> 
    <br> Tutorial of Hadoop and Hbase with EC2 Docker.
</p>

## 📝 Table of Contents

- [Getting Started](#getting_started)
- [Acknowledgments](#acknowledgement)

## 🏁 Getting Started <a name = "getting_started"></a>

This document explains how to install Hadoop and Hbase and how to basic use it.

### Prerequisites

1. **Run AWS EC2.**

    * You need to open 8888 port.
    * You need to select `Ubuntu OS`.

    ![](./static/20200819_170156.png)

1. **Connect AWS EC2.**

    1. Copy Your IP

        ![](./static/20200819_170328.png)

    2. Connect to `Instance` with your ssh connection program.

        ![](./static/20200819_170544.png)

    3. Get administrator privileges with the command below.
        
        ```
        sudo -s
        ```

1. **Install Docker with code below.**
    
    * If you want install Docker on `Windows OS`, Please see https://docs.docker.com/docker-for-windows

    ```bash
    apt-get update -y
    apt-get install docker.io -y
    ```

1. **Run Jupyter Notebook Docker.**

    1. Create file `Dockerfile`

    1. Copy and Paste code below to `Dockerfile`

        * Dockerfile is the place to write the properties of the OS.

        ```Dockerfile
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
        ```

    1. Build Dockerfile.

        ```
        docker build --tag jupyter .
        ```

    1. Run jupyter notebook.

        * If you want check docker command, please see https://docs.docker.com/engine/reference/commandline/docker/.

        ```bash
        docker run -v $pwd/workspace:/workspace -p 8888:8888 -it --rm -d --name jupyter jupyter

        # if you run code below, you can get a token.
        docker logs -f jupyter
        ```

        * result:
            ```
            To access the notebook, open this file in a browser:
                file:///root/.local/share/jupyter/runtime/nbserver-6-open.html
            Or copy and paste one of these URLs:
                http://docker-desktop:8888/?token=3804db616b6519d72b6dc68ddf68dff4508c2e32ba97616e
            or http://127.0.0.1:8888/?token=3804db616b6519d72b6dc68ddf68dff4508c2e32ba97616e        
            ```
    1. Connect your jupyter notebook as URL below.
        
        ```bash
        http://YOUR_SERVER_URL_HERE:8888/?token=YOUR_TOKEN_HERE
        ```

    1. So you can see notebook screen.

        ![](./static/20200819_165445.png)


## Using Hadoop(Hbase) in python
---

### **Please follow the step below to know the basic usage.**

1. **Run Docker hbase on your EC2 Computer**

    * If you want check docker command, please see https://docs.docker.com/engine/reference/commandline/docker/.

    ```bash
    mkdir -p data

    docker run -p 16010:16010 -p 9090:9090 -p 9095:9095 -p 8080:8080 -p 8085:8085 -p 2181:2181 --name=hbase-docker hbase-docker -d -v $pwd/data:/data dajobe/hbase
    ```

1. **Connect hbase and create table.**

    ```python
    import happybase

    # Connect to hbase.
    connection = happybase.Connection('localhost', 9090)

    # Create table in hbase.
    connection.create_table('sample', {'family': dict()})
    print(connection.tables())
    ```

1. **Connect table and put data and read data**

    ```python
    # Get table handler.
    table = connection.table('sample')

    # Put row.
    table.put('sample-rowkey', {'family:qual1': 'value1', 'family:qual2': 'value2'})


    # Get list of rows.
    for k, data in table.scan():
        print(k, data)

    # Get row data.
    row = table.row(b'sample-rowkey')
    print(row[b'family:qual1'])  # prints 'value1'
    

    # Delete row.
    table.delete(b'sample-rowkey')
    ```

1. **Run docker shell to check**

    ```bash
    docker exec -it hadoop-docker hbase shell
    ```

1. **scan table**

    ```bash
    scan 'sample'
    ```
### **Reference**

1. **What is HBase?**

    HBase is non-relational distribution database for Hadoop platform. It runs on `HDFS`.

1. **What is HappyBase?**

    Happy Base is a library to use HBase in Python. It runs on `Apache Thrift`

1. **What is Apache Thrift?**

    Thrift is Interface Definition Language.

    It has been developed by Facebook for `Scalable Cross-Language Service Development`.

## Using Hadoop in Docker
---

### **Please follow the step below to know the basic usage.**

1. **Run Docker Hadoop.**

    ```
    docker run -it sequenceiq/hadoop-docker:2.7.0 /etc/bootstrap.sh -bash
    ```

1. **Run MapReduce and check output.**

    ```bash
    cd $HADOOP_PREFIX
    # run the mapreduce
    bin/hadoop dfsadmin -safemode leave
    bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.0.jar grep input output 'dfs[a-z.]+'

    # check the output
    bin/hdfs dfs -cat output/*
    ```

1. **Create directory and put file.**

    ```bash
    >>> bin/hadoop fs -mkdir /hello
    >>> bin/hadoop fs -put ./NOTICE.txt /hello

    >>> bin/hadoop fs -ls /hello
    Found 1 items
    -rw-r--r--   1 root supergroup        101 2020-08-18 09:10 /hello/NOTICE.txt

    ```

1. **Read File.**

    ```bash
    >>> bin/hadoop fs -cat /hello/NOTICE.txt
    This product includes software developed by The Apache Software
    Foundation (http://www.apache.org/).
    ```

1. Complete!


### **Reference**

1. **HDFS is hadoop distribution file system.**

1. **Hadoop consists of:**
    
    **Node**

    1. Name Node
        * Manage Metadata (Block informations and Datanode Informations)
        * Manage DataNode (Heartbeat - 3s and Blockreport - 6h)
    2. Data Node

    **Block**

    1. Block size 128MB
    2. The reason a block size is large is to search quickly.

    **Safe Mode**

    1. Safemode is state in which data nodes cannot be modified.
    2. How to change safe mode
        
        ```bash
        # Get safe mode state.
        $ hdfs dfsadmin -safemode get
        Safe mode is OFF

        # Safe mode enter.
        $ hdfs dfsadmin -safemode enter
        Safe mode is ON

        # Safe mode leave.
        $ hdfs dfsadmin -safemode leave
        Safe mode is OFF
        ```

1. **Mapreduce**

    MapReduce is a system to process data of Hadoop cluster and consists of Map and Reduce.

    ![](./static/2136A84B59381A8428.jpg)


## **Tutorial is over 😀**
