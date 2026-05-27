#!/bin/bash
# =============================================================
# EKS cluster setup helper (you already have the cluster)
# Just run this to configure kubectl
# =============================================================

CLUSTER_NAME="devops"   # <-- CHANGE
AWS_REGION="ap-south-1"                # <-- CHANGE

echo "▶ Updating kubeconfig for EKS cluster: $CLUSTER_NAME"
aws eks update-kubeconfig \
  --name $CLUSTER_NAME \
  --region $AWS_REGION

echo "▶ Verifying connection..."
kubectl get nodes
kubectl get namespaces

echo ""
echo "✅ kubectl is now configured for your EKS cluster."
echo "   Next steps:"
echo "   1. Run: scripts/install-aws-lb-controller.sh"
echo "   2. Run: scripts/install-argocd.sh"
echo "   3. Push your code to GitHub"
echo "   4. Configure Jenkins credentials (see docs/JENKINS_SETUP.md)"
