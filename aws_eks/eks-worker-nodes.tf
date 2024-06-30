resource "aws_iam_role" "main_node" {
  name = "terraform-eks-main_node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "main_node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.main_node.name
}

resource "aws_iam_role_policy_attachment" "main_node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.main_node.name
}

resource "aws_iam_role_policy_attachment" "main_node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.main_node.name
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "main"
  node_role_arn   = aws_iam_role.main_node.arn
  subnet_ids      = aws_subnet.main[*].id
  instance_types  = ["${var.aws_node_groups_instance_type}"]
  ami_type        = "AL2_x86_64"
  disk_size       = 20

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.main_node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.main_node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.main_node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
