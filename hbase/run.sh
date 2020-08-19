docker_name=hbase-docker

mkdir -p data

docker stop $docker_name
docker rm $docker_name

docker run -p 16010:16010 -p 9090:9090 -p 9095:9095 -p 8080:8080 -p 8085:8085 -p 2181:2181 --name=$docker_name -h hbase-docker -d -v $pwd/data:/data dajobe/hbase