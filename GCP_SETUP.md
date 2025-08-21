# 🚀 Deploy Laravel to Google Cloud Platform (GCP)

This guide will help you deploy your Laravel app to Google Kubernetes Engine (GKE) using GitHub Actions and Docker Hub.

## 📋 Prerequisites

1. **Google Cloud Platform account**
2. **Docker Hub account**
3. **GitHub repository** with this code

## 🔧 Setup Steps

### 1. **Create GKE Cluster**

```bash
# Set your project ID
export PROJECT_ID="your-project-id"
export CLUSTER_NAME="laravel-cluster"
export ZONE="us-central1-a"

# Enable required APIs
gcloud services enable container.googleapis.com
gcloud services enable containerregistry.googleapis.com

# Create GKE cluster
gcloud container clusters create $CLUSTER_NAME \
    --zone $ZONE \
    --num-nodes 3 \
    --enable-autoscaling \
    --min-nodes 1 \
    --max-nodes 5 \
    --machine-type e2-medium \
    --project $PROJECT_ID
```

### 2. **Create Service Account for GitHub Actions**

```bash
# Create service account
gcloud iam service-accounts create github-actions \
    --description="Service account for GitHub Actions" \
    --display-name="GitHub Actions"

# Grant necessary permissions
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/container.developer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

# Create and download key
gcloud iam service-accounts keys create key.json \
    --iam-account=github-actions@$PROJECT_ID.iam.gserviceaccount.com
```

### 3. **Setup GitHub Repository Secrets**

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:

#### Docker Hub Secrets:
- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Your Docker Hub access token (create at hub.docker.com/settings/security)

#### GCP Secrets:
- `GCP_PROJECT_ID`: Your GCP project ID
- `GCP_SERVICE_ACCOUNT_KEY`: Content of the `key.json` file (copy entire file content)
- `GKE_CLUSTER`: Your cluster name (e.g., `laravel-cluster`)
- `GKE_ZONE`: Your cluster zone (e.g., `us-central1-a`)

### 4. **Update Your Repository**

1. **Update Docker Hub username** in `k8s-simple/laravel.yaml`:
   ```yaml
   image: your-dockerhub-username/laravel-app:latest
   ```
   Replace `your-dockerhub-username` with your actual Docker Hub username.

2. **Update secrets** in `k8s-simple/secret.yaml`:
   ```bash
   # Generate new APP_KEY
   echo -n "base64:$(openssl rand -base64 32)" | base64
   
   # Generate new DB password
   echo -n "your-secure-password" | base64
   ```

### 5. **Deploy**

Push to your main/master branch:
```bash
git add .
git commit -m "Add GCP deployment setup"
git push origin main
```

The GitHub Actions workflow will automatically:
1. ✅ Run tests
2. 🐳 Build Docker image
3. 📤 Push to Docker Hub
4. 🚀 Deploy to GKE

## 🌐 Access Your Application

### Get External IP:
```bash
kubectl get services -n laravel
```

Look for the `EXTERNAL-IP` of the `laravel` service.

### Or use port forwarding:
```bash
kubectl port-forward svc/laravel 8080:80 -n laravel
# Open: http://localhost:8080
```

## 📊 Monitor Your Deployment

### Check pods:
```bash
kubectl get pods -n laravel
```

### View logs:
```bash
kubectl logs -f deployment/laravel -n laravel
```

### Check deployment status:
```bash
kubectl get deployments -n laravel
```

## 🔧 Manual Deployment (Alternative)

If you prefer to deploy manually:

```bash
# Build and push image
docker build -f Dockerfile.simple -t your-dockerhub-username/laravel-app:latest .
docker push your-dockerhub-username/laravel-app:latest

# Configure kubectl for GKE
gcloud container clusters get-credentials laravel-cluster --zone us-central1-a

# Deploy
kubectl apply -f k8s-simple/
```

## 🎛️ Scaling Your Application

### Manual scaling:
```bash
kubectl scale deployment laravel --replicas=5 -n laravel
```

### Auto-scaling (optional):
```bash
kubectl autoscale deployment laravel --cpu-percent=70 --min=2 --max=10 -n laravel
```

## 🔒 Security Best Practices

1. **Use different passwords** for production
2. **Enable network policies** if needed
3. **Set up SSL/TLS** with cert-manager
4. **Use Kubernetes secrets** for sensitive data
5. **Regularly update** base images

## 💰 Cost Optimization

- Use **preemptible nodes** for development
- Set up **cluster autoscaling**
- Monitor **resource usage**
- Consider **spot instances**

## 🆘 Troubleshooting

### Image pull errors:
```bash
# Check if image exists on Docker Hub
docker pull your-dockerhub-username/laravel-app:latest
```

### Pod not starting:
```bash
kubectl describe pod <pod-name> -n laravel
kubectl logs <pod-name> -n laravel
```

### Database connection issues:
```bash
kubectl exec -it deployment/laravel -n laravel -- ping mysql
```

### GitHub Actions failing:
1. Check secrets are set correctly
2. Verify service account permissions
3. Check workflow logs in GitHub Actions tab

## 🎯 Next Steps

1. **Set up domain name** and DNS
2. **Configure SSL certificates** 
3. **Set up monitoring** (Prometheus/Grafana)
4. **Implement backup strategy**
5. **Set up staging environment**

---

**Your Laravel app is now running on Google Cloud! 🎉**

Access it via the external IP or set up a domain for production use.
