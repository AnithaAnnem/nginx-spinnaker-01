#!/bin/bash
set -e

# Paths
PARAM_FILE="overlay/dev/parameter.yml"
BASE_DEPLOYMENT="base/deployment.yaml"
BASE_SERVICE="base/service.yaml"

OUTPUT_DIR="/tmp/generated"
mkdir -p $OUTPUT_DIR

# Read parameters using yq
APP=$(yq e '.app' $PARAM_FILE)
NAMESPACE=$(yq e '.namespace' $PARAM_FILE)
REPLICAS=$(yq e '.replicas' $PARAM_FILE)
IMAGE=$(yq e '.image' $PARAM_FILE)
CPU=$(yq e '.cpu' $PARAM_FILE)
MEMORY=$(yq e '.memory' $PARAM_FILE)

# Replace placeholders in deployment.yaml
envsubst < $BASE_DEPLOYMENT > $OUTPUT_DIR/deployment.yaml
envsubst < $BASE_SERVICE > $OUTPUT_DIR/service.yaml

# Overwrite placeholders dynamically using env variables
export parameters_app=$APP
export parameters_namespace=$NAMESPACE
export parameters_replicas=$REPLICAS
export parameters_image=$IMAGE
export parameters_cpu=$CPU
export parameters_memory=$MEMORY

# Run envsubst on both files
envsubst '${parameters_app} ${parameters_namespace} ${parameters_replicas} ${parameters_image} ${parameters_cpu} ${parameters_memory}' \
  < $BASE_DEPLOYMENT > $OUTPUT_DIR/deployment.yaml

envsubst '${parameters_app} ${parameters_namespace}' \
  < $BASE_SERVICE > $OUTPUT_DIR/service.yaml

echo "Generated YAML in $OUTPUT_DIR"
ls -l $OUTPUT_DIR
