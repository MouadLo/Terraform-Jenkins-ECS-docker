resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-state-a2b62fgfg19"
  acl    = "private"

  tags = {
    Name = "Terraform state"
  }
}

