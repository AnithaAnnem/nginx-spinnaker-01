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

#!/bin/bash
set -e

echo "Generating manifests using pipeline parameters"

OUT_DIR="generated/${ENV}"
mkdir -p ${OUT_DIR}

envsubst < base/deployment.yaml > ${OUT_DIR}/deployment.yaml
envsubst < base/service.yaml > ${OUT_DIR}/service.yaml

cat <<EOF > ${OUT_DIR}/kustomization.yaml
resources:
- deployment.yaml
- service.yaml
EOF

echo "Generated files:"
ls -l ${OUT_DIR}
