
docker_name=hadoop-docker

docker stop $docker_name
docker rm $docker_name

docker run --name $docker_name -it --rm sequenceiq/hadoop-docker:2.7.0 /etc/bootstrap.sh -bash
