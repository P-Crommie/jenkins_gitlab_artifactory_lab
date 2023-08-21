resource "aws_iam_role" "this" {
  name = "${var.project}-exec-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "this" {
  name = "${var.project}-policyCreator"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "iam:CreateInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:PassRole"
        ],
        Effect : "Allow",
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = {
    policy_s3             = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    policy_dynamodb       = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
    policy_ecr            = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
    policy_ec2full_access = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    policy_iamfull_access = "arn:aws:iam::aws:policy/IAMFullAccess"
    policy_creation_role  = aws_iam_policy.this.arn
  }
  policy_arn = each.value
  role       = aws_iam_role.this.name
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.project}-profile"
  role = aws_iam_role.this.name
}