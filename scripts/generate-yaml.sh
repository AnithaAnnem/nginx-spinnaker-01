#!/bin/bash
set -e

echo "Installing tools..."
apk add --no-cache yq gettext

PARAM_FILE="overlay/dev/parameter.yml"
OUTPUT_DIR="/tmp/generated"

mkdir -p "$OUTPUT_DIR"

echo "Loading parameters..."

export APP_NAME=$(yq e '.app' "$PARAM_FILE")
export NAMESPACE=$(yq e '.namespace' "$PARAM_FILE")
export REPLICAS=$(yq e '.replicas' "$PARAM_FILE")
export IMAGE=$(yq e '.image' "$PARAM_FILE")
export CPU=$(yq e '.cpu' "$PARAM_FILE")
export MEMORY=$(yq e '.memory' "$PARAM_FILE")

echo "Generating deployment.yaml..."
envsubst < base/deployment.yaml > "$OUTPUT_DIR/deployment.yaml"

echo "Generating service.yaml..."
envsubst < base/service.yaml > "$OUTPUT_DIR/service.yaml"

echo "Generated manifests:"
ls -l "$OUTPUT_DIR"

echo "Deployment YAML:"
cat "$OUTPUT_DIR/deployment.yaml"
