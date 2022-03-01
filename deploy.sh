DOCKER_IMAGE=esso4real/pipeline:v5
docker pull $DOCKER_IMAGE
docker run -d -p 8080:8080 $DOCKER_IMAGE
