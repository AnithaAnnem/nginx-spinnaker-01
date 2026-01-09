# #!/bin/bash
# set -e

# echo "Installing tools..."
# apk add --no-cache yq gettext

# ENV="${ENV_PARAM}"

# if [ -z "$ENV" ]; then
#   echo "ERROR: ENV_PARAM is not set"
#   exit 1
# fi

# echo "Running for environment: $ENV"

# PARAM_FILE="overlay/${ENV}/parameter.yml"
# OUTPUT_DIR="/tmp/generated"

# mkdir -p "$OUTPUT_DIR"

# echo "Loading parameters from $PARAM_FILE"

# export APP_NAME=$(yq e '.app' "$PARAM_FILE")
# export NAMESPACE=$(yq e '.namespace' "$PARAM_FILE")
# export REPLICAS=$(yq e '.replicas' "$PARAM_FILE")
# export IMAGE=$(yq e '.image' "$PARAM_FILE")
# export CPU=$(yq e '.cpu' "$PARAM_FILE")
# export MEMORY=$(yq e '.memory' "$PARAM_FILE")

# echo "Generating deployment.yaml..."
# envsubst < base/deployment.yaml > "$OUTPUT_DIR/deployment.yaml"

# echo "Generating service.yaml..."
# envsubst < base/service.yaml > "$OUTPUT_DIR/service.yaml"

# echo "Generated manifests:"
# ls -l "$OUTPUT_DIR"

# echo "Deployment YAML:"
# cat "$OUTPUT_DIR/deployment.yaml"

#!/bin/sh
set -e

ENV="dev"   # hardcode for now (we’ll parameterize later)

PARAM_FILE="overlay/${ENV}/parameter.yml"
OUTPUT_DIR="/tmp/generated"

mkdir -p "$OUTPUT_DIR"

echo "Reading parameters from $PARAM_FILE"

APP_NAME=$(yq e '.app' "$PARAM_FILE")
NAMESPACE=$(yq e '.namespace' "$PARAM_FILE")
REPLICAS=$(yq e '.replicas' "$PARAM_FILE")
IMAGE=$(yq e '.image' "$PARAM_FILE")
CPU=$(yq e '.cpu' "$PARAM_FILE")
MEMORY=$(yq e '.memory' "$PARAM_FILE")

export APP_NAME NAMESPACE REPLICAS IMAGE CPU MEMORY

envsubst < base/deployment.yaml > "$OUTPUT_DIR/deployment.yaml"
envsubst < base/service.yaml > "$OUTPUT_DIR/service.yaml"

echo "Generated files:"
ls -l "$OUTPUT_DIR"
