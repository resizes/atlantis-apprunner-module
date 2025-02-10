resource "aws_apprunner_service" "atlantis" {
  service_name = "atlantis-app"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_access_role.arn
    }

    image_repository {
      image_identifier      = "${aws_ecr_repository.atlantis.repository_url}:${local.atlantis_image_tag}"
      image_repository_type = "ECR"
      image_configuration {
        port = "4141"
        runtime_environment_variables = {
          "ATLANTIS_ATLANTIS_URL"    = local.app_runner_url
          "ATLANTIS_REPO_ALLOWLIST"  = local.repo_allowlist
          "ATLANTIS_BITBUCKET_USER"  = local.bitbucket_user
        }
        runtime_environment_secrets = {
          "ATLANTIS_BITBUCKET_TOKEN" = aws_secretsmanager_secret.bitbucket.arn
        }
      }
    }
  }

  instance_configuration {
    cpu               = "512"
    memory            = "1024"
    instance_role_arn = aws_iam_role.apprunner_instance_role.arn
  }

  health_check_configuration {
    protocol = "TCP"
    path     = "/"
  }
}
