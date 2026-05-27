#!/bin/bash
# =============================================================
# Install ArgoCD on EKS and register the application
# =============================================================

set -e

echo "▶ Installing ArgoCD..."

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -n argocd -f \
  https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "▶ Waiting for ArgoCD pods..."
kubectl wait --for=condition=available deployment/argocd-server \
  -n argocd --timeout=120s

# Patch ArgoCD server to LoadBalancer so you can access the UI
# (or use port-forward for local access)
kubectl patch svc argocd-server -n argocd \
  -p '{"spec": {"type": "LoadBalancer"}}'

echo ""
echo "▶ Getting initial admin password..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d)

ARGOCD_URL=$(kubectl get svc argocd-server -n argocd \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo ""
echo "✅ ArgoCD is ready!"
echo "   URL:      https://$ARGOCD_URL"
echo "   Username: admin"
echo "   Password: $ARGOCD_PASSWORD"
echo ""
echo "▶ Applying ArgoCD application manifest..."
kubectl apply -f ../argocd/application.yaml

echo "✅ Done. ArgoCD will now watch your Git repo and sync to EKS."
