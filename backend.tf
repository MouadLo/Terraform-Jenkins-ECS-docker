terraform {
    backend "s3" {
        bucket = "k8s--state-storage"
        key = "terraform/jenkins-docker"
        region = "us-west-2"
    }
}