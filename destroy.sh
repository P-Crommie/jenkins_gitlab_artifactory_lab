#!/bin/bash

WORK_DIR=$(dirname "$(readlink -f "$0")")

terraform -chdir="$WORK_DIR/infra" destroy -var-file=cicd-lab.tfvars -auto-approve