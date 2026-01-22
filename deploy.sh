#!/bin/bash
set -e

echo "Logging in to Artifact Registry..."
gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://us-central1-docker.pkg.dev

echo "Building image..."
docker build --platform linux/amd64 -t us-central1-docker.pkg.dev/fizzy-483720/fizzy-repo/fizzy:latest .

echo "Pushing image..."
docker push us-central1-docker.pkg.dev/fizzy-483720/fizzy-repo/fizzy:latest

echo "Applying Terraform..."
cd terraform
terraform apply -auto-approve -var="project_id=fizzy-483720" -var="rails_master_key=f15f687b340671df216d1bf5bf7c04e3" -var="db_password=iCj6Q1kRmyVsdGdj+pOYpw=="
