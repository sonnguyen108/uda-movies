# Create EC2 endpoint for private access
resource "aws_vpc_endpoint" "ec2" {
  count               = var.enable_private == true ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.us-east-1.ec2"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_eks_cluster.main.vpc_config.0.cluster_security_group_id]
  private_dns_enabled = true
}

################
# EKS Resources
################
# Create an EKS cluster
resource "aws_eks_cluster" "main" {
  name     = "cluster"
  version  = var.k8s_version
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    subnet_ids              = [var.private_subnet_id, var.public_subnet_id]
    endpoint_public_access  = var.enable_private == true ? false : true
    endpoint_private_access = true
  }
  depends_on = [aws_iam_role_policy_attachment.eks_cluster, aws_iam_role_policy_attachment.eks_service]
}

#####################
# IAM Roles
#####################
# Create EKS endpoint for private access
resource "aws_vpc_endpoint" "eks" {
  count               = var.enable_private == true ? 1 : 0 # only enable when private
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.us-east-1.eks"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_eks_cluster.main.vpc_config.0.cluster_security_group_id]
  subnet_ids          = [var.private_subnet_id]
  private_dns_enabled = true
}

# Create an IAM role for the EKS cluster
resource "aws_iam_role" "eks_cluster" {
  name = "eks_cluster_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to the EKS cluster IAM role
resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}


