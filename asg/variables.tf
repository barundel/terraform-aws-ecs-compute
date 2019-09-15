variable "asg_name" {
  description = "Name of the compute service your creating"
}

variable "instance_type" {
  description = "Instance type for your EC2"
  default = "t2.micro"
}

variable "security_groups" {
  type = "list"
  description = "List of SGs to attach to the "
}

variable "subnets" {
  type = "list"
  description = "List of subnets to launch compute in"
}

variable "user_data" {
  description = "Userdata to pass to the EC2"
  default = ""
}

variable "min_asg_size" {default = 0}
variable "max_asg_size" {default = 1}
variable "desired_capacity" {default = 1}