#!/bin/bash

# Laravel Kubernetes Deployment Script
set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
ENVIRONMENT="development"
NAMESPACE="laravel-app"
BUILD_IMAGE=false
PUSH_IMAGE=false
REGISTRY="ghcr.io"
IMAGE_NAME="your-username/laravel-app"
IMAGE_TAG="latest"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -e, --environment    Environment to deploy to (development|staging|production)"
    echo "  -n, --namespace      Kubernetes namespace (default: laravel-app)"
    echo "  -b, --build          Build Docker image"
    echo "  -p, --push           Push Docker image to registry"
    echo "  -r, --registry       Container registry (default: ghcr.io)"
    echo "  -i, --image          Image name (default: your-username/laravel-app)"
    echo "  -t, --tag            Image tag (default: latest)"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -e development -b -p"
    echo "  $0 -e production -i myregistry.com/laravel-app -t v1.0.0"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -n|--namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        -b|--build)
            BUILD_IMAGE=true
            shift
            ;;
        -p|--push)
            PUSH_IMAGE=true
            shift
            ;;
        -r|--registry)
            REGISTRY="$2"
            shift 2
            ;;
        -i|--image)
            IMAGE_NAME="$2"
            shift 2
            ;;
        -t|--tag)
            IMAGE_TAG="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(development|staging|production)$ ]]; then
    print_error "Invalid environment: $ENVIRONMENT"
    print_error "Valid environments: development, staging, production"
    exit 1
fi

print_status "Starting deployment to $ENVIRONMENT environment"

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed or not in PATH"
    exit 1
fi

# Check if kustomize is available
if ! command -v kustomize &> /dev/null; then
    print_warning "kustomize is not installed. Using kubectl kustomize instead."
    KUSTOMIZE_CMD="kubectl kustomize"
else
    KUSTOMIZE_CMD="kustomize build"
fi

# Build Docker image if requested
if [ "$BUILD_IMAGE" = true ]; then
    print_status "Building Docker image..."
    FULL_IMAGE_NAME="$REGISTRY/$IMAGE_NAME:$IMAGE_TAG"

    if ! docker build -t "$FULL_IMAGE_NAME" .; then
        print_error "Failed to build Docker image"
        exit 1
    fi

    print_success "Docker image built: $FULL_IMAGE_NAME"

    # Push image if requested
    if [ "$PUSH_IMAGE" = true ]; then
        print_status "Pushing Docker image to registry..."

        if ! docker push "$FULL_IMAGE_NAME"; then
            print_error "Failed to push Docker image"
            exit 1
        fi

        print_success "Docker image pushed: $FULL_IMAGE_NAME"
    fi
fi

# Create namespace if it doesn't exist
print_status "Creating namespace if it doesn't exist..."
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

# Deploy to Kubernetes
print_status "Deploying to Kubernetes..."
OVERLAY_PATH="k8s/overlays/$ENVIRONMENT"

if [ ! -d "$OVERLAY_PATH" ]; then
    print_error "Overlay directory not found: $OVERLAY_PATH"
    exit 1
fi

# Apply the configuration
if ! $KUSTOMIZE_CMD "$OVERLAY_PATH" | kubectl apply -f -; then
    print_error "Failed to deploy to Kubernetes"
    exit 1
fi

print_success "Deployed to Kubernetes"

# Wait for deployment to be ready
print_status "Waiting for deployment to be ready..."
if ! kubectl rollout status deployment/laravel-app -n "$NAMESPACE" --timeout=300s; then
    print_error "Deployment rollout failed or timed out"
    exit 1
fi

print_success "Deployment is ready"

# Run database migrations for production
if [ "$ENVIRONMENT" = "production" ]; then
    print_status "Running database migrations..."

    # Create a job to run migrations
    JOB_NAME="migration-$(date +%s)"
    kubectl create job "$JOB_NAME" \
        --from=deployment/laravel-app \
        --namespace="$NAMESPACE" \
        -- php artisan migrate --force

    # Wait for migration job to complete
    kubectl wait --for=condition=complete job/"$JOB_NAME" -n "$NAMESPACE" --timeout=300s

    # Show migration logs
    kubectl logs job/"$JOB_NAME" -n "$NAMESPACE"

    # Clean up migration job
    kubectl delete job "$JOB_NAME" -n "$NAMESPACE"

    print_success "Database migrations completed"
fi

# Show deployment status
print_status "Deployment Status:"
kubectl get pods -n "$NAMESPACE" -l app=laravel-app
kubectl get services -n "$NAMESPACE"

print_success "Deployment completed successfully!"
print_status "Your application should be available at the configured ingress URL"
