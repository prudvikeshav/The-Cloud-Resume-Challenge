output "s3_bucket_name" {
  value = aws_s3_bucket.resumeexample.bucket
}

output "base_url" {
  value = "${aws_apigatewayv2_stage.default.invoke_url}/VisitorCounter"
}
