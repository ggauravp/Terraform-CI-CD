# Archive a single file.

data "archive_file" "init" {
  type        = "zip"
  source_dir  = "${path.module}/python"
  output_path = "${path.module}/layer.zip"
}

resource "aws_lambda_layer_version" "psycopg_layer" {
  filename                 = data.archive_file.init.output_path
  layer_name               = "psycopg2-layer"
  compatible_runtimes      = ["python3.11"]
  compatible_architectures = ["x86_64"]
}

