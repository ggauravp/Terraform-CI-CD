output "ec2_public_ip" {
  value = aws_instance.postgres_ec2.public_ip
}

output "bucket_name" {
  value = aws_s3_bucket.csv_bucket.bucket
}

output "lambda_arn" {
  value = aws_lambda_function.csv_to_postgres.arn
}
 
output "dynamodb_table_name" {
  value = aws_dynamodb_table.tf_lock.name
}