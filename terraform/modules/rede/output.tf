output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "sn_pub_az1a_id" {
  value = aws_subnet.sn_pub_az1a.id
}

output "sn_pub_az1c_id" {
  value = aws_subnet.sn_pub_az1c.id
}

output "sn_priv_az1a_id" {
  value = aws_subnet.sn_priv_az1a.id
}

output "sn_priv_az1c_id" {
  value = aws_subnet.sn_priv_az1c.id
}