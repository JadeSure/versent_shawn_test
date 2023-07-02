resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.deploy_env}-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public-subnet" {
  count  = var.az_public_count
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = cidrsubnet(aws_vpc.myapp-vpc.cidr_block, 8, count.index)
  # availability_zone = var.avail_zone
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name : "${var.deploy_env}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private-subnet" {
  count  = var.az_private_count
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = cidrsubnet(aws_vpc.myapp-vpc.cidr_block, 8, var.az_private_count + count.index)
  # availability_zone = var.avail_zone
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name : "${var.deploy_env}-private-subnet-${count.index + 1}"
  }
}


# for public subnet
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name = "${var.deploy_env}-igw"
  }
}

# for private subnet
resource "aws_eip" "nat_eip" {
  count = var.az_private_count >= 1 ? 1 : 0
  vpc        = true
  depends_on = [aws_internet_gateway.myapp-igw]
  tags = {
    Name : "${var.deploy_env}-NAT-Gateway-EIP"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.az_private_count >= 1 ? 1 : 0
  # allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  allocation_id = aws_eip.nat_eip[0].id

  # must be in the public subnet
  subnet_id  = element(aws_subnet.public-subnet.*.id, count.index)
  depends_on = [aws_internet_gateway.myapp-igw]

  tags = {
    Name = "${var.deploy_env}-NAT-Gateway"
  }
}

resource "aws_route_table" "public-route-table" {
  count = var.az_public_count >= 1 ? 1 : 0
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # gateway_id = element(aws_internet_gateway.myapp-igw.*.id, count.index)
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.deploy_env}-public-rtb"
  }
}


resource "aws_route_table" "private-route-table" {
  count = var.az_private_count >= 1 ? 1 : 0
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
    gateway_id = aws_nat_gateway.nat[0].id
  }

  tags = {
    Name = "${var.deploy_env}-private-rtb"
  }
}


# edit subnet associations for public and private
resource "aws_route_table_association" "public" {
  count          = var.az_public_count
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id = aws_route_table.public-route-table[0].id
}


resource "aws_route_table_association" "private" {
  count          = var.az_private_count
  subnet_id      = element(aws_subnet.private-subnet.*.id, count.index)
  route_table_id = aws_route_table.private-route-table[0].id
}