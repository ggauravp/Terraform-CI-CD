terraform {
  backend "s3" {
    bucket = "gaurav-terraform-state2003111"
    key    = "terraform.tfstate"
    region = "us-east-1"

    # Optional: keep if you're using custom creds in GitHub Actions
    skip_credentials_validation = true
  }
}

# NOTE:
# Do NOT manage the backend bucket inside this project.
# The bucket must already exist.
# Terraform will only use it to store state.
