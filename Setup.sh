#!/bin/bash
##Bring in the environment variables
ENVIRONMENT_VARIABLE_FILE="variables.sh"
source "${ENVIRONMENT_VARIABLE_FILE}"


POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-postgres}"
POSTGRES_HOST_PORT="25432"

ETL_IMAGE="assignment:latest"
ETL_CONTAINER_NAME="assignment"

POSTGRES_CONTAINER="postgres_container_assignment"

# Stop and Remove container if it already exists
echo "Stopping and Removing Postgres Container: ${POSTGRES_CONTAINER}"
docker stop "${ETL_CONTAINER_NAME}"
docker stop "${POSTGRES_CONTAINER}"

docker rm "${ETL_CONTAINER_NAME}"
echo "Removed ETL Container: ${POSTGRES_CONTAINER}"
docker rm "${POSTGRES_CONTAINER}"
echo "Removed Postgres Container: ${POSTGRES_CONTAINER}"

docker rmi "${ETL_IMAGE}"
echo "Removed ETL Image: ${ETL_IMAGE_}"

# Build Image for the ETL Container
docker build -f Dockerfile --tag "${ETL_IMAGE}" .

docker network rm assignment_network
docker network create assignment_network

echo "Creating Postgres Container with connection credentials: Username: ${POSTGRES_USER}, Password: ${POSTGRES_PASSWORD}, Database: postgres, Port: ${POSTGRES_HOST_PORT}"
docker run -d -e POSTGRES_USER="${POSTGRES_USER}" -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} -e POSTGRES_DB=${POSTGRES_DB}  -p $POSTGRES_HOST_PORT:5432 --network assignment_network --name "${POSTGRES_CONTAINER}" postgres:14

# Time for Database Start-up before starting the ETL Process
sleep 20

docker run -d --network assignment_network --name "${ETL_CONTAINER_NAME}" "${ETL_IMAGE}"
