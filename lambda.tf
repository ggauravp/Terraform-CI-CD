data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/app/lambda_function.py"
  output_path = "${path.module}/app/lambda.zip"
}

resource "aws_lambda_function" "csv_to_postgres" {
  function_name = "csv_to_postgres"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  filename      = data.archive_file.lambda_zip.output_path
  architectures = ["x86_64"]
  timeout       = 600

  # Ensure Lambda is created after EC2
  depends_on = [aws_instance.postgres_ec2]

  environment {
    variables = {
      DB_HOST = aws_instance.postgres_ec2.private_ip # automatically fetch EC2 private IP
      DB_NAME = var.db_name
      DB_USER = var.db_user
      DB_PASS = var.db_pass
    }
  }

  layers = [aws_lambda_layer_version.psycopg_layer.arn]

  vpc_config {
    subnet_ids         = [var.lambda_subnet_id]
    security_group_ids = [aws_security_group.postgres_sg.id]
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = var.vpc_id
  service_name    = "com.amazonaws.us-east-1.s3"
  route_table_ids = [var.route_table_id]

  vpc_endpoint_type = "Gateway"
}
