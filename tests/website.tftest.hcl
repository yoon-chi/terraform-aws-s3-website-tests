# Call the setup module to create a random bucket prefix
run "setup_tests" {
  module {
    source = "./tests/setup" # runs a terraform apply cmd on the setup helper module to create the random bucket prefix
  }
}

/* run "get_plan_output" {
  command = plan
  module {
    source = "./."
  }
} */

# Apply run block to create the bucket
run "create_bucket" {
  variables {
    bucket_name = "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
    /* existing_bucket_name = "${run.get_plan_output.s3_bucket_name}" */
  }

  # Check that the bucket name is correct
  assert {
    condition     = aws_s3_bucket.s3_bucket.bucket == "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
    /* condition     = var.existing_bucket_name == var.bucket_name */
    error_message = "Invalid bucket name"
  }

  # Check index.html hash matches
  assert {
    condition     = aws_s3_object.index.etag == filemd5("./www/index.html")
    error_message = "Invalid eTag for index.html"
  }

  # Check error.html hash matches
  assert {
    condition     = aws_s3_object.error.etag == filemd5("./www/error.html")
    error_message = "Invalid eTag for error.html"
  }
}
