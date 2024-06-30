resource "aws_iam_role" "main_cluster" {
  name = "terraform-eks-main_cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "main_cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.main_cluster.name
}

resource "aws_iam_role_policy_attachment" "main_cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.main_cluster.name
}

resource "aws_security_group" "main_cluster" {
  name        = "terraform-eks-main_cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags_all = {
    Name        = "${var.owner_name}-environment"
    Environment = var.environment_type
    Owner       = var.owner_name
  }
}

resource "aws_security_group_rule" "main_cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.main_cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.main_cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.main_cluster.id]
    subnet_ids         = aws_subnet.main[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.main_cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.main_cluster-AmazonEKSVPCResourceController,
  ]

  tags_all = {
    Name        = var.owner_name
    Environment = var.environment_type
    Owner       = var.owner_name
  }
}
