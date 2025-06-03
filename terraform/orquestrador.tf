module "rede" {
  source = "./modules/rede"
}

module "app" {
  source               = "./modules/app"
  vpc_id               = module.rede.vpc_id
  vpc_cidr             = module.rede.vpc_cidr
  sn_pub_az1a_id       = module.rede.sn_pub_az1a_id
  sn_pub_az1c_id       = module.rede.sn_pub_az1c_id
  sn_priv_az1a_id      = module.rede.sn_priv_az1a_id
  sn_priv_az1c_id      = module.rede.sn_priv_az1c_id
  ami_id               = "ami-00a929b66ed6e0de6"
  asg_min_size         = 1
  asg_max_size         = 4
  asg_desired_capacity = 2
}