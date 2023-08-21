# CI/CD Lab Setup on AWS using Terraform and Ansible

This repository contains scripts and configurations to set up a comprehensive Continuous Integration and Continuous Deployment (CI/CD) lab environment on Amazon Web Services (AWS). The lab environment includes Jenkins, GitLab, and Artifactory, facilitating experimentation and learning in the realm of modern software development practices.

The project leverages Terraform for infrastructure provisioning and Ansible for configuration management. This README provides an overview of the project structure, deployment steps, and key components.

## Project Structure

```
.
├── destroy.sh
├── getInitPassword
├── infra
│   ├── cicd-lab.tfvars
│   ├── compute.tf
│   ├── network.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── roles.tf
│   ├── security_group.tf
│   ├── userdata
│   │   └── config.sh
│   └── variables.tf
├── init.sh
├── playbooks
│   ├── ansible.cfg
│   ├── ci_cd.yml
│   ├── compose
│   │   ├── docker-compose.yml
│   │   ├── dockerfile
│   │   └── plugins.txt
│   └── inventory
└── README.md
```

- `destroy.sh`: Script to tear down the lab infrastructure.
- `getInitPassword`: Script for obtaining initial passwords.
- `infra`: Terraform configurations for AWS infrastructure setup.
- `init.sh`: Script to initialize and deploy the infrastructure.
- `playbooks`: Ansible playbooks and related files for configuration.

## Prerequisites

- AWS account with appropriate credentials and permissions.
- Terraform installed on your local machine.
- Ansible installed on your local machine.
- Basic familiarity with AWS, Terraform, and Ansible.

## Usage

1. Create a `.tfvars` file or modify variables.tf  in `infra` to configure infrastructure parameters.
2. Run `init.sh` to deploy infrastructure and execute the ansible playbook using to configure Jenkins, GitLab, and Artifactory.
3. Access services as per output of the `init.sh` script.

## Teardown

To tear down the environment and release resources:

1. Execute `destroy.sh` to dismantle the infrastructure.

## Components

### Docker Image and Plugins

A custom Docker image is created for Jenkins with various tools pre-installed, including Java 8, Docker, Docker Compose, Terraform, Helm, AWS CLI, and more. Jenkins plugins listed in `compose/plugins.txt` are automatically installed upon container launch.

### Docker Compose Setup

The Docker Compose configuration in `playbooks/compose/docker-compose.yml` defines services for Jenkins, GitLab, and Artifactory. Ports and volumes are mapped to facilitate communication and data persistence. Jenkins will be setup using docker-in-docker approach.

### Ansible Playbooks

- `playbooks/ci_cd.yml`: Ansible playbook for configuring the CI/CD environment.
- `playbooks/ansible.cfg`: Ansible configuration file.
- `playbooks/inventory`: Directory for Ansible inventory files.
