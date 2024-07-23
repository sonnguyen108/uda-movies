######################
# CodeBuild Resources
######################
# Create a CodeBuild project
resource "aws_codebuild_project" "codebuild" {
  name          = "udacity"
  description   = "Udacity CodeBuild project"
  service_role  = aws_iam_role.codebuild.arn
  build_timeout = 60
  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/sonnguyen108/uda-movies.git"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  cache {
    type = "NO_CACHE"
  }
}

# Create the Codebuild Role
resource "aws_iam_role" "codebuild" {
  name = "codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the IAM policy to the codebuild role
resource "aws_iam_role_policy_attachment" "codebuild" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
  role       = aws_iam_role.codebuild.name
}
