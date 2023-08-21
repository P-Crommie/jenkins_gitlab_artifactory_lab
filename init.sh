#!/bin/bash

WORK_DIR=$(dirname "$(readlink -f "$0")")

key_name=$(awk -F'"' '/key_name/ {print $2}' "$WORK_DIR/infra/cicd-lab.tfvars")

terraform -chdir="$WORK_DIR/infra" init -reconfigure
terraform -chdir="$WORK_DIR/infra" apply -var-file=cicd-lab.tfvars -auto-approve

ansible_cfg_file="$WORK_DIR/playbooks/ansible.cfg"
inventory_file="$WORK_DIR/playbooks/inventory"

# Clean inventory file
> "$inventory_file"

public_ip=$(terraform -chdir="$WORK_DIR/infra" output -raw cicd_lab-public_ip)
public_dns=$(terraform -chdir="$WORK_DIR/infra" output -raw cicd_lab-public_dns)

# Update the private_key_file in ansible.cfg
sed -i "s|private_key_file =.*|private_key_file = ~/.ssh/$key_name.pem|" "$ansible_cfg_file"
# Update the inventory path in ansible.cfg
sed -i "s|inventory =.*|inventory = $inventory_file|" "$ansible_cfg_file"

echo "cicd-lab ansible_host=$public_ip ansible_connection=ssh ansible_user=ubuntu" > "$inventory_file"
sleep 10
echo
echo "Inventory file updated successfully."
echo
echo "Waiting for lab to startup..."
echo
sleep 45

cd "$WORK_DIR/playbooks"

# Ping the Jenkins host using Ansible
ansible -m ping -i "$(basename "$inventory_file")" -c "$(basename "$ansible_cfg_file")" cicd-lab

if [[ $? -eq 0 ]]; then 
    # If the ping is successful, execute the playbook
    echo "Running Jenkins playbook..."
    echo
    ansible-playbook -i "$(basename "$inventory_file")" -c "$(basename "$ansible_cfg_file")" "$WORK_DIR/playbooks/ci_cd.yml"

    if [[ $? -eq 0  ]]; then
        echo "Waiting for lab environment to be initialized..."
        sleep 30
        ssh -i ~/.ssh/$key_name.pem -o "StrictHostKeyChecking no" ubuntu@$public_dns < $WORK_DIR/getInitPassword
        echo
        echo "Access Jenkins on... http://$public_dns:8080"
        echo
        echo "Access GItlab on... http://$public_dns"
        echo
        echo "Access Artifactory on... http://$public_dns:8082"
        echo
    else
        echo "Error applying playbook. Check your playbook and/or network connectivity."
        exit 1
    fi
else
    echo "Unable to ping the Jenkins host. Please check your network connectivity."
    exit 1
fi