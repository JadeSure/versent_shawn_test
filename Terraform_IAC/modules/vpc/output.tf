output "myapp_vpc"{
    value = aws_vpc.myapp-vpc
}

output "myapp_public_subnet"{
    value = aws_subnet.public-subnet
}

output "myapp_private_subnet" {
    value = aws_subnet.private-subnet
}