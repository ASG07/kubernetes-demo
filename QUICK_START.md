# 🚀 Quick Start Guide - Laravel to Kubernetes

## TL;DR - Get Running Fast

### 1. **Setup Secrets** (2 minutes)
```bash
./scripts/setup-secrets.sh
```
Enter your database passwords when prompted.

### 2. **Deploy to Development** (5 minutes)
```bash
# Build and deploy to development
./scripts/deploy.sh -e development -b -p

# Check deployment status
kubectl get pods -n laravel-app
```

### 3. **Access Your App**
```bash
# Port forward to access locally
kubectl port-forward svc/laravel-service 8080:80 -n laravel-app

# Open browser to: http://localhost:8080
```

## 🔧 Before You Start

### Required Tools
- Docker
- kubectl (configured for your cluster)
- Kubernetes cluster with:
  - Ingress controller
  - Storage class

### Update Configuration
1. **Image Registry**: Edit `k8s/base/deployment.yaml`
   ```yaml
   image: your-registry/laravel-app:latest  # ← Change this
   ```

2. **Domain**: Edit `k8s/base/ingress.yaml`
   ```yaml
   host: your-domain.com  # ← Change this
   ```

## 🌍 Environments

### Development
```bash
./scripts/deploy.sh -e development -b -p
```
- 1 replica
- Lower resource limits
- Debug mode enabled

### Production
```bash
./scripts/deploy.sh -e production -b -p -t v1.0.0
```
- 5 replicas
- Auto-scaling enabled
- Optimized for performance
- Runs migrations automatically

## 📊 Monitoring

### Check Status
```bash
# Pods status
kubectl get pods -n laravel-app

# Service endpoints
kubectl get svc -n laravel-app

# Ingress configuration
kubectl get ingress -n laravel-app
```

### View Logs
```bash
# Application logs
kubectl logs -f deployment/laravel-app -n laravel-app

# Database logs
kubectl logs -f mysql-0 -n laravel-app
```

## 🔧 Common Commands

### Run Artisan Commands
```bash
# Migrate database
kubectl create job migration-$(date +%s) \
  --from=deployment/laravel-app \
  --namespace=laravel-app \
  -- php artisan migrate --force

# Clear cache
kubectl exec deployment/laravel-app -n laravel-app -- php artisan cache:clear

# Interactive shell
kubectl exec -it deployment/laravel-app -n laravel-app -- bash
```

### Scale Application
```bash
# Manual scaling
kubectl scale deployment laravel-app --replicas=3 -n laravel-app

# Check HPA (production only)
kubectl get hpa -n laravel-app
```

## 🚨 Troubleshooting

### Pod Won't Start
```bash
# Check pod status
kubectl describe pod <pod-name> -n laravel-app

# Check events
kubectl get events -n laravel-app --sort-by='.lastTimestamp'
```

### Database Connection Issues
```bash
# Test database connectivity
kubectl exec -it deployment/laravel-app -n laravel-app -- ping mysql-service

# Check database pod
kubectl get pods -l app=mysql -n laravel-app

# Access database directly
kubectl exec -it mysql-0 -n laravel-app -- mysql -u laravel -p
```

### Image Pull Issues
1. Verify image exists in registry
2. Check kubectl can access registry
3. Update image name in deployment.yaml

## 🎯 Next Steps

1. **Configure DNS** → Point your domain to ingress IP
2. **Setup SSL** → Configure cert-manager for HTTPS
3. **Monitoring** → Deploy Prometheus/Grafana
4. **CI/CD** → Setup GitHub Actions workflow
5. **Backups** → Configure database backup strategy

## 📞 Need Help?

- Check the full guide: [KUBERNETES_DEPLOYMENT.md](./KUBERNETES_DEPLOYMENT.md)
- View logs: `kubectl logs -f deployment/laravel-app -n laravel-app`
- Debug pod: `kubectl describe pod <pod-name> -n laravel-app`

---

**Your Laravel app is now running on Kubernetes! 🎉**
