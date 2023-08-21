variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "project" {
  description = "Name of the project deployment."
  type        = string
  default     = "cicd-lab"
}

variable "availability_zone" {
  type    = string
  default = "eu-west-1b"
}

variable "key_name" {
  default = "ci-cd_lab"
}

variable "ec2_ami" {
  type    = string
  default = "ami-01dd271720c1ba44f"
}

variable "ec2_type" {
  type    = string
  default = "t3a.xlarge"
}

variable "user_home_directory" {
  description = "Path to the user's home directory"
  default     = "/home/crommie"
}

variable "allowed_ingress_cidr_blocks" {
  type = list(string)
  default = [ "0.0.0.0/0" ]
}