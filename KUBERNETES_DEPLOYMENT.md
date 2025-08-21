# Kubernetes Deployment Guide for Laravel Sail Application

This guide will help you deploy your Laravel Sail application to Kubernetes.

## 📋 Prerequisites

- Kubernetes cluster (v1.24+)
- kubectl configured to access your cluster
- Docker registry access (GitHub Container Registry, Docker Hub, etc.)
- Ingress controller (nginx-ingress recommended)
- Storage class configured for persistent volumes

## 🚀 Quick Start

### 1. Setup Secrets

First, create the necessary secrets for your application:

```bash
./scripts/setup-secrets.sh
```

This will create:
- Laravel application secrets (APP_KEY, database passwords)
- MySQL secrets (root password, user password)

### 2. Build and Deploy

For development environment:
```bash
./scripts/deploy.sh -e development -b -p
```

For production environment:
```bash
./scripts/deploy.sh -e production -b -p -t v1.0.0
```

## 📁 Project Structure

```
k8s/
├── base/                    # Base Kubernetes manifests
│   ├── namespace.yaml       # Namespace definition
│   ├── configmap.yaml       # Application configuration
│   ├── secret.yaml          # Application secrets template
│   ├── deployment.yaml      # Laravel application deployment
│   ├── service.yaml         # Service definition
│   ├── pvc.yaml            # Persistent volume claims
│   ├── ingress.yaml        # Ingress configuration
│   ├── servicemonitor.yaml # Prometheus monitoring
│   └── networkpolicy.yaml  # Network security policies
├── database/               # Database-specific manifests
│   ├── mysql-configmap.yaml
│   ├── mysql-secret.yaml
│   ├── mysql-pvc.yaml
│   ├── mysql-statefulset.yaml
│   ├── mysql-service.yaml
│   └── mysql-init-configmap.yaml
└── overlays/              # Environment-specific configurations
    ├── development/       # Development environment
    ├── staging/          # Staging environment (optional)
    └── production/       # Production environment
```

## 🔧 Configuration

### Environment Variables

Update the following files for your environment:

1. **Base Configuration** (`k8s/base/configmap.yaml`):
   - `APP_URL`: Your application domain
   - Database settings
   - Cache and session configuration

2. **Secrets** (`k8s/base/secret.yaml`):
   - `APP_KEY`: Laravel application key
   - `DB_PASSWORD`: Database password
   - Other sensitive configuration

3. **Ingress** (`k8s/base/ingress.yaml`):
   - Update `your-domain.com` with your actual domain
   - Configure TLS certificates

### Image Registry

Update the image references in:
- `k8s/base/deployment.yaml`
- `k8s/overlays/*/kustomization.yaml`

Replace `your-registry/laravel-app:latest` with your actual image registry and tag.

## 🗄️ Database Setup

The deployment includes a MySQL 8.0 database with:
- Persistent storage (10Gi by default)
- Automatic initialization scripts
- Health checks and monitoring
- Testing database creation

### Database Access

To access the database directly:

```bash
kubectl exec -it mysql-0 -n laravel-app -- mysql -u laravel -p
```

## 🌐 Networking

### Ingress Configuration

The application uses nginx-ingress-controller with:
- Automatic HTTPS redirect
- TLS termination
- File upload size limit (100MB)

### Network Policies

Security policies are configured to:
- Allow ingress controller access
- Permit database communication
- Restrict unnecessary traffic

## 📊 Monitoring & Health Checks

### Health Checks

The application includes:
- **Liveness Probe**: Checks if the application is running
- **Readiness Probe**: Checks if the application can serve traffic
- **Startup Probe**: Allows time for application initialization

### Monitoring

Prometheus monitoring is configured via ServiceMonitor:
- Application metrics endpoint: `/metrics`
- Database metrics via MySQL exporter

## 🔄 Scaling

### Horizontal Pod Autoscaler (HPA)

Production environment includes HPA configuration:
- CPU utilization target: 70%
- Memory utilization target: 80%
- Min replicas: 3
- Max replicas: 10

### Manual Scaling

```bash
kubectl scale deployment laravel-app --replicas=5 -n laravel-app
```

## 🚀 CI/CD Pipeline

### GitHub Actions

The included workflow (`.github/workflows/deploy.yml`) provides:
- Automated testing with PHPUnit
- Docker image building and pushing
- Automatic deployment to development/production
- Database migration execution

### Setup Requirements

Add these secrets to your GitHub repository:
- `KUBE_CONFIG`: Base64 encoded kubeconfig file
- `KUBE_CONTEXT`: Kubernetes context name

## 🛠️ Maintenance

### Running Artisan Commands

```bash
# Run migrations
kubectl create job migration-$(date +%s) \
  --from=deployment/laravel-app \
  --namespace=laravel-app \
  -- php artisan migrate --force

# Clear cache
kubectl create job cache-clear-$(date +%s) \
  --from=deployment/laravel-app \
  --namespace=laravel-app \
  -- php artisan cache:clear

# Run custom commands
kubectl exec deployment/laravel-app -n laravel-app -- php artisan your:command
```

### Backup Database

```bash
kubectl exec mysql-0 -n laravel-app -- mysqldump -u root -p laravel > backup.sql
```

### Logs

```bash
# Application logs
kubectl logs -f deployment/laravel-app -n laravel-app

# Database logs
kubectl logs -f mysql-0 -n laravel-app

# All pods in namespace
kubectl logs -f -l app=laravel-app -n laravel-app
```

## 🔧 Troubleshooting

### Common Issues

1. **Image Pull Errors**:
   - Verify registry credentials
   - Check image name and tag
   - Ensure proper RBAC permissions

2. **Database Connection Issues**:
   - Verify MySQL is running: `kubectl get pods -n laravel-app`
   - Check service DNS: `kubectl get svc -n laravel-app`
   - Validate secrets: `kubectl get secrets -n laravel-app`

3. **Persistent Volume Issues**:
   - Check storage class: `kubectl get storageclass`
   - Verify PVC status: `kubectl get pvc -n laravel-app`
   - Review node storage capacity

4. **Ingress Issues**:
   - Verify ingress controller is running
   - Check ingress configuration: `kubectl describe ingress -n laravel-app`
   - Validate DNS configuration

### Debug Commands

```bash
# Check pod status
kubectl get pods -n laravel-app -o wide

# Describe problematic pod
kubectl describe pod <pod-name> -n laravel-app

# Check events
kubectl get events -n laravel-app --sort-by='.lastTimestamp'

# Test connectivity
kubectl exec -it deployment/laravel-app -n laravel-app -- ping mysql-service
```

## 🔒 Security Considerations

### Best Practices Implemented

1. **Non-root containers**: All containers run as non-root users
2. **Security contexts**: Proper security contexts are configured
3. **Network policies**: Traffic is restricted between components
4. **Secret management**: Sensitive data is stored in Kubernetes secrets
5. **Resource limits**: CPU and memory limits prevent resource exhaustion
6. **Read-only filesystems**: Where possible, containers use read-only root filesystems

### Additional Security Measures

1. **Pod Security Standards**: Consider implementing Pod Security Standards
2. **RBAC**: Implement proper Role-Based Access Control
3. **Image scanning**: Scan container images for vulnerabilities
4. **Secret rotation**: Regularly rotate database passwords and API keys

## 📞 Support

For issues and questions:
1. Check the troubleshooting section above
2. Review Kubernetes cluster logs
3. Consult Laravel and Kubernetes documentation
4. Open an issue in the project repository

---

## 📝 Next Steps

After successful deployment:
1. Configure domain DNS to point to your ingress
2. Set up SSL certificates (Let's Encrypt recommended)
3. Configure monitoring and alerting
4. Set up log aggregation
5. Implement backup strategies
6. Configure CI/CD pipeline for automated deployments
