resource "aws_ecs_cluster" "main" {
  name = var.project

  tags = {
    Name = "${var.project}"
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

resource "aws_ecs_task_definition" "main" {
  family                   = var.project
  task_role_arn            = aws_iam_role.ecs_task.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  memory                   = var.memory
  cpu                      = var.cpu

  container_definitions = jsonencode(
    [
      {
        name  = "${var.project}-migration-execution"
        image = data.aws_ecr_repository.app.repository_url
        portMappings = [
        ]
        entrypoint = [
          "sh",
          "-c"
        ]
        command = [
          "/bin/sh -c 'export DB_PASSWORD=$(echo $DB_INFO | jq '.password'); php artisan config:cache; php artisan migrate --force;'",
        ],
        essential = false
        environment = concat([
          for name, value in var.container_environments : {
            name  = name
            value = value
          }
          ],
          [{
            name  = "DB_HOST"
            value = var.db_instance_address
          }]
        )
        secrets = concat([
          for name, arn in var.container_sectrets : {
            name      = name
            valueFrom = arn
          }
          ],
          [
            {
              name      = "DB_INFO"
              valueFrom = var.aws_rds_db_password_arn
            }
        ])
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = var.aws_cloudwatch_log_group_migration
            awslogs-region        = data.aws_region.current.id
            awslogs-stream-prefix = "${var.project}-terraform-migration"
          }
        }
      },
      {
        name  = "${var.project}-main-app"
        image = data.aws_ecr_repository.app.repository_url
        portMappings = [
        ]
        entrypoint = [
          "sh",
          "-c"
        ]
        command = [
          "/bin/sh -c 'export DB_PASSWORD=$(echo $DB_INFO | jq '.password'); php artisan config:cache; php-fpm;'",
        ],
        environment = concat([
          for name, value in var.container_environments : {
            name  = name
            value = value
          }
          ],
          [{
            name  = "DB_HOST"
            value = var.db_instance_address
            },
            {
              name : "REDIS_HOST",
              value : var.redis_host
            },
          ]
        )
        secrets = concat([
          for name, arn in var.container_sectrets : {
            name      = name
            valueFrom = arn
          }
          ],
          [
            {
              name      = "DB_INFO"
              valueFrom = var.aws_rds_db_password_arn
            }
        ])
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = var.aws_cloudwatch_log_group_php
            awslogs-region        = data.aws_region.current.id
            awslogs-stream-prefix = "${var.project}"
          }
        }
      },
      {
        name  = "${var.project}-main-web"
        image = data.aws_ecr_repository.web.repository_url
        portMappings = [
          {
            hostPort      = 80
            containerPort = 80
            protocol      = "tcp"
          }
        ]
        environment = [
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = var.aws_cloudwatch_log_group_nginx
            awslogs-region        = data.aws_region.current.id
            awslogs-stream-prefix = "${var.project}-terraform-web"
          }
        }
      }
    ]
  )

  tags = {
    Name = "${var.project}"
  }
}
resource "aws_ecs_service" "main" {
  name                               = var.project
  cluster                            = aws_ecs_cluster.main.arn
  launch_type                        = "FARGATE"
  platform_version                   = "1.4.0"
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60

  #  capacity_provider_strategy {
  #    capacity_provider = "FARGATE"
  #    base              = var.capacity_provider_strategy.fargate.base
  #    weight            = var.capacity_provider_strategy.fargate.weight
  #  }
  #
  #  capacity_provider_strategy {
  #    capacity_provider = "FARGATE_SPOT"
  #    base              = var.capacity_provider_strategy.fargate_spot.base
  #    weight            = var.capacity_provider_strategy.fargate_spot.weight
  #  }

  load_balancer {
    container_name   = "${var.project}-main-web"
    container_port   = 80
    target_group_arn = var.lb_target_group_arn_http
  }

  network_configuration {
    security_groups = [
      aws_security_group.server.id
    ]
    subnets          = var.subnet_ids
    assign_public_ip = !var.enable_nat_gateway
  }
  enable_execute_command = var.enable_ecs_exec
  depends_on             = [aws_iam_role.ecs_task_execution]
  tags = {
    Name = "${var.project}"
  }
}
