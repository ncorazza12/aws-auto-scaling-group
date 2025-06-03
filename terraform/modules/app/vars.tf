variable "vpc_id" {}
variable "vpc_cidr" {}
variable "sn_pub_az1a_id" {}
variable "sn_pub_az1c_id" {}
variable "sn_priv_az1a_id" {}
variable "sn_priv_az1c_id" {}

variable "ami_id" {
  type    = string
  default = "ami-02457590d33d576c3"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "asg_min_size" {
  type    = number
  default = 2
}

variable "asg_max_size" {
  type    = number
  default = 8
}

variable "asg_desired_capacity" {
  type    = number
  default = 4
}