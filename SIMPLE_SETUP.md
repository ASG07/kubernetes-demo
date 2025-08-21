# 🚀 Simple Laravel Kubernetes Setup

This is a minimal, no-frills setup to get your Laravel app running on Kubernetes quickly.

## 🎯 Two Deployment Options

1. **Local/Manual Deployment** - Deploy directly to any Kubernetes cluster
2. **GitHub Actions + GCP** - Automated deployment to Google Cloud Platform

## What You Get

- **Simple Dockerfile** with Apache
- **5 basic YAML files** for Kubernetes
- **1 deployment script**
- **No complex features** - just the basics

## 📦 Files Created

```
├── Dockerfile.simple           # Simple container with Apache
├── docker/simple-apache.conf   # Basic Apache config
├── k8s-simple/                 # Kubernetes manifests
│   ├── namespace.yaml          # Creates 'laravel' namespace
│   ├── configmap.yaml          # App configuration
│   ├── secret.yaml             # Passwords and keys
│   ├── mysql.yaml              # MySQL database
│   └── laravel.yaml            # Laravel app
└── deploy-simple.sh            # One-command deployment
```

## 🚀 Quick Deploy

### 1. **Update Image Name**
Edit `k8s-simple/laravel.yaml` and change:
```yaml
image: your-registry/laravel:latest  # ← Put your image here
```

### 2. **Update Secrets** (Important!)
Edit `k8s-simple/secret.yaml` and change the base64 encoded values:
```bash
# Generate new APP_KEY
echo -n "base64:$(openssl rand -base64 32)" | base64

# Generate new DB password
echo -n "your-new-password" | base64
```

### 3. **Deploy**
```bash
# Build and deploy
./deploy-simple.sh --build

# Or just deploy (if image already exists)
./deploy-simple.sh
```

### 4. **Access Your App**
```bash
kubectl port-forward svc/laravel 8080:80 -n laravel
# Open: http://localhost:8080
```

## 📋 What This Setup Includes

✅ **Laravel app** running on Apache  
✅ **MySQL database** (basic setup)  
✅ **Health checks** for reliability  
✅ **Environment variables** and secrets  
✅ **Auto-migration** on deployment  
✅ **LoadBalancer service** for external access  

## ❌ What's NOT Included

❌ Persistent storage (data lost on restart)  
❌ Auto-scaling  
❌ SSL/TLS  
❌ Ingress controller  
❌ Monitoring  
❌ CI/CD pipeline  
❌ Multiple environments  

## 🔧 Common Tasks

### View Logs
```bash
kubectl logs -f deployment/laravel -n laravel
```

### Scale App
```bash
kubectl scale deployment laravel --replicas=3 -n laravel
```

### Run Artisan Commands
```bash
kubectl exec deployment/laravel -n laravel -- php artisan cache:clear
```

### Delete Everything
```bash
kubectl delete namespace laravel
```

## 🚨 Important Notes

1. **Database storage**: Uses `emptyDir` - data will be lost when MySQL pod restarts
2. **Secrets**: Default passwords are weak - change them!
3. **Image**: You need to build and push your image to a registry
4. **External access**: Uses LoadBalancer - may not work on all clusters

## 🎯 Next Steps (Optional)

If you need more features later:
1. Add persistent storage for MySQL
2. Set up an ingress controller for domain access
3. Add SSL certificates
4. Implement proper CI/CD

## 🌤️ Deploy to Google Cloud Platform

### Quick Setup for GCP + GitHub Actions:

1. **Run setup helper**:
   ```bash
   ./setup-github-secrets.sh
   ```

2. **Follow the GCP setup guide**: [GCP_SETUP.md](./GCP_SETUP.md)

3. **Push to GitHub**:
   ```bash
   git push origin main
   ```

Your app will automatically deploy to GCP! 🚀

---

**This gets you running fast with minimal complexity! 🎉**
