#!/bin/bash

# Simple Laravel Kubernetes Deployment Script
set -e

echo "🚀 Deploying Laravel to Kubernetes (Simple Setup)"

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed"
    exit 1
fi

# Build Docker image (optional)
if [ "$1" = "--build" ]; then
    echo "🔨 Building Docker image..."
    IMAGE_NAME="laravel-app:latest"
    docker build -f Dockerfile.simple -t $IMAGE_NAME .
    echo "✅ Image built: $IMAGE_NAME"
    echo "📝 Don't forget to push to your registry and update laravel.yaml"
fi

# Deploy to Kubernetes
echo "📦 Deploying to Kubernetes..."

kubectl apply -f k8s-simple/namespace.yaml
kubectl apply -f k8s-simple/configmap.yaml
kubectl apply -f k8s-simple/secret.yaml
kubectl apply -f k8s-simple/mysql.yaml
kubectl apply -f k8s-simple/laravel.yaml

echo "⏳ Waiting for deployment..."
kubectl wait --for=condition=available deployment/laravel -n laravel --timeout=300s

echo "🎉 Deployment complete!"
echo ""
echo "📊 Status:"
kubectl get pods -n laravel
echo ""
echo "🌐 Access your app:"
echo "kubectl port-forward svc/laravel 8080:80 -n laravel"
echo "Then open: http://localhost:8080"
