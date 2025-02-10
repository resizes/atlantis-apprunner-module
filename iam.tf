resource "aws_iam_role" "apprunner_access_role" {
  name = "apprunner-atlantis-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.apprunner_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role" "apprunner_instance_role" {
  name = "apprunner-atlantis-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "atlantis" {
  name = "atlantis"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          AWS = aws_iam_role.apprunner_instance_role.arn
        }
      },
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          AWS = "arn:aws:iam::XXXXXXXXXXX:user/USERNAME"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "atlantis" {
  role       = aws_iam_role.atlantis.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy" "atlantis" {
  name = "atlantis"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource = aws_iam_role.atlantis.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_assume_role" {
  role       = aws_iam_role.apprunner_instance_role.name
  policy_arn = aws_iam_policy.atlantis.arn
}

resource "aws_iam_role_policy_attachment" "attach_secrets_manager" {
  role       = aws_iam_role.apprunner_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
