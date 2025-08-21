#!/bin/bash

# GitHub Secrets Setup Helper
# This script helps you prepare the values needed for GitHub repository secrets

echo "🔧 GitHub Secrets Setup Helper"
echo "==============================="
echo ""

echo "📝 You need to add these secrets to your GitHub repository:"
echo "   Go to: Repository → Settings → Secrets and variables → Actions"
echo ""

echo "🐳 DOCKER HUB SECRETS:"
echo "----------------------"
echo "DOCKERHUB_USERNAME: (Your Docker Hub username)"
echo "DOCKERHUB_TOKEN: (Create at: https://hub.docker.com/settings/security)"
echo ""

echo "☁️ GCP SECRETS:"
echo "---------------"
read -p "Enter your GCP Project ID: " PROJECT_ID
read -p "Enter your GKE cluster name (default: laravel-cluster): " CLUSTER_NAME
CLUSTER_NAME=${CLUSTER_NAME:-laravel-cluster}
read -p "Enter your GKE zone (default: us-central1-a): " ZONE
ZONE=${ZONE:-us-central1-a}

echo ""
echo "GCP_PROJECT_ID: $PROJECT_ID"
echo "GKE_CLUSTER: $CLUSTER_NAME"
echo "GKE_ZONE: $ZONE"
echo ""

echo "🔑 To create the service account key:"
echo "gcloud iam service-accounts create github-actions --project=$PROJECT_ID"
echo "gcloud projects add-iam-policy-binding $PROJECT_ID --member=\"serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com\" --role=\"roles/container.developer\""
echo "gcloud iam service-accounts keys create key.json --iam-account=github-actions@$PROJECT_ID.iam.gserviceaccount.com"
echo ""
echo "Then copy the content of key.json file as GCP_SERVICE_ACCOUNT_KEY secret"
echo ""

echo "🔐 LARAVEL SECRETS:"
echo "-------------------"
echo "Generate new APP_KEY:"
APP_KEY_BASE64=$(echo -n "base64:$(openssl rand -base64 32)" | base64)
echo "APP_KEY (base64): $APP_KEY_BASE64"
echo ""

echo "Generate new DB password:"
read -s -p "Enter a secure database password: " DB_PASSWORD
echo ""
DB_PASSWORD_BASE64=$(echo -n "$DB_PASSWORD" | base64)
echo "DB_PASSWORD (base64): $DB_PASSWORD_BASE64"
echo ""

echo "✏️ UPDATE YOUR FILES:"
echo "---------------------"
echo "1. Update k8s-simple/laravel.yaml:"
echo "   Replace 'your-dockerhub-username' with your actual Docker Hub username"
echo ""
echo "2. Update k8s-simple/secret.yaml:"
echo "   APP_KEY: $APP_KEY_BASE64"
echo "   DB_PASSWORD: $DB_PASSWORD_BASE64"
echo ""

echo "🚀 Once everything is set up:"
echo "git add ."
echo "git commit -m 'Deploy to GCP'"
echo "git push origin main"
echo ""
echo "✅ Your app will automatically deploy to GCP!"
