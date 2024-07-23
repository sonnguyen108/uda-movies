# Output the Subnet IDs
output "vpc_id" {
  description = "aws vpc id"
  value       = aws_vpc.vpc.id
}
# Output the Subnet IDs
output "private_subnet_id" {
  description = "private_subnet_id"
  value       = aws_subnet.private_subnet.id
}
output "public_subnet_id" {
  description = "public_subnet_id"
  value       = aws_subnet.public_subnet.id
}

