#!/bin/bash
# =============================================================
# Install AWS Load Balancer Controller on EKS
# Run this ONCE after your EKS cluster is ready
# Pre-req: kubectl, eksctl, helm, aws-cli configured
# =============================================================

set -e

CLUSTER_NAME="devops"     # <-- CHANGE
AWS_REGION="ap-south-1"                  # <-- CHANGE (Mumbai)
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "▶ Cluster:    $CLUSTER_NAME"
echo "▶ Region:     $AWS_REGION"
echo "▶ Account ID: $AWS_ACCOUNT_ID"

# 1. Download IAM policy
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json

# 2. Create IAM Policy
aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json \
  --region $AWS_REGION || echo "Policy may already exist, continuing..."

# 3. Create IAM Service Account (IRSA)
eksctl create iamserviceaccount \
  --cluster=$CLUSTER_NAME \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --region=$AWS_REGION

# 4. Add Helm repo
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# 5. Install controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$CLUSTER_NAME \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=$AWS_REGION

echo "✅ AWS Load Balancer Controller installed."
echo "   Verify: kubectl get deployment -n kube-system aws-load-balancer-controller"
