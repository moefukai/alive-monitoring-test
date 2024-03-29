#ecs_task_execution role
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project}-ecs-task-execution"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  tags = {
    Name = "${var.project}-ecs-task-execution"
  }
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = data.aws_iam_policy.ecs_task_execution.arn
}

# enable ecs to access to secret manager
resource "aws_iam_policy" "secret_access" {
  name = "${var.project}-secrets-manager"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetSecretValue",
          ],
          "Resource" : concat(
            [for key, value in var.container_sectrets : value],
          [var.aws_rds_db_password_arn])
        },
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_secret_access" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.secret_access.arn
}

# enable ecs to access to secret manager
resource "aws_iam_policy" "kms_access" {
  name = "${var.project}-kms"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "kms:Decrypt"
          ],
          "Resource" : [
            "arn:aws:kms:${data.aws_region.current.id}:${data.aws_caller_identity.self.account_id}:key/${var.kms_decryption_key_id}"
          ]
        },
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_kms_access" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.kms_access.arn
}

# enable ecs to access s3
resource "aws_iam_policy" "s3_access" {
  name = "${var.project}-s3-access"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "s3:*"
          "Resource" : "arn:aws:s3:::${var.s3_bucket_name}/*"
        },
      ]
    }
  )
}

resource "aws_iam_role" "ecs_task" {
  name = "${var.project}-ecs-task"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  tags = {
    Name = "${var.project}-ecs-task"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_s3_access" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.s3_access.arn
}

#for ECS exec
resource "aws_iam_role_policy" "ecs_task_ssm" {
  count = var.enable_ecs_exec ? 1 : 0
  name  = "${var.project}-ssm"
  role  = aws_iam_role.ecs_task.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}
