#!/bin/bash

# Setup Kubernetes Secrets for Laravel Application
set -e

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

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

NAMESPACE="laravel-app"

print_status "Setting up Kubernetes secrets for Laravel application"

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed or not in PATH"
    exit 1
fi

# Function to generate a random password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Function to base64 encode
base64_encode() {
    echo -n "$1" | base64 | tr -d '\n'
}

# Create namespace if it doesn't exist
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

print_status "Generating Laravel APP_KEY..."
# Generate Laravel APP_KEY
if command -v php &> /dev/null; then
    APP_KEY=$(php -r "echo 'base64:' . base64_encode(random_bytes(32));")
else
    # Fallback if PHP is not available
    APP_KEY="base64:$(openssl rand -base64 32)"
fi

print_status "Please provide the following information:"

# Get database password
read -s -p "Enter database password for 'laravel' user: " DB_PASSWORD
echo
read -s -p "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
echo

# Generate random passwords if empty
if [ -z "$DB_PASSWORD" ]; then
    DB_PASSWORD=$(generate_password)
    print_warning "Generated random database password: $DB_PASSWORD"
fi

if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    MYSQL_ROOT_PASSWORD=$(generate_password)
    print_warning "Generated random MySQL root password: $MYSQL_ROOT_PASSWORD"
fi

# Create Laravel secrets
print_status "Creating Laravel application secrets..."
kubectl create secret generic laravel-secrets \
    --from-literal=APP_KEY="$APP_KEY" \
    --from-literal=DB_PASSWORD="$DB_PASSWORD" \
    --from-literal=REDIS_PASSWORD="" \
    --namespace="$NAMESPACE" \
    --dry-run=client -o yaml | kubectl apply -f -

# Create MySQL secrets
print_status "Creating MySQL secrets..."
kubectl create secret generic mysql-secret \
    --from-literal=MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
    --from-literal=MYSQL_PASSWORD="$DB_PASSWORD" \
    --namespace="$NAMESPACE" \
    --dry-run=client -o yaml | kubectl apply -f -

print_success "Secrets created successfully!"

print_status "Secret Summary:"
echo "  - Laravel APP_KEY: [HIDDEN]"
echo "  - Database password: [HIDDEN]"
echo "  - MySQL root password: [HIDDEN]"

print_warning "Please save these credentials in a secure location:"
echo "  - Database password: $DB_PASSWORD"
echo "  - MySQL root password: $MYSQL_ROOT_PASSWORD"

print_status "You can now deploy your Laravel application to Kubernetes"
