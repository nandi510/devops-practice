# 🚀 DevOps Practice Project

**Stack:** Node.js + MySQL | Docker | Jenkins CI/CD | EKS | ArgoCD | AWS ALB Ingress

---

## 📐 Architecture

```
Developer
   │  git push
   ▼
GitHub Repo
   │  webhook
   ▼
Jenkins (single server)
   ├── npm test
   ├── docker build
   ├── docker push ──→ Docker Hub
   └── update image tag in k8s manifest → git push
                                              │
                                        ArgoCD watches
                                              │ auto-sync
                                              ▼
                                     EKS Cluster (AWS)
                                      ├── app-deployment (Node.js)
                                      ├── mysql (StatefulSet)
                                      └── AWS ALB Ingress
                                              │
                                        Internet Traffic
```

---

## 📁 Project Structure

```
devops-practice/
├── app/                          # Node.js application
│   ├── src/index.js              # Express API (users CRUD + /health)
│   ├── Dockerfile                # Multi-stage build
│   └── package.json
│
├── docker/
│   └── mysql/init.sql            # DB init script
│
├── docker-compose.yml            # Local dev (app + mysql)
│
├── k8s/
│   └── base/
│       ├── namespace.yaml
│       ├── kustomization.yaml
│       ├── configmap/            # Non-sensitive config
│       ├── secret/               # DB credentials (plain for now)
│       ├── deployment/
│       │   ├── app-deployment.yaml
│       │   └── mysql-statefulset.yaml
│       ├── service/services.yaml
│       ├── ingress/ingress.yaml  # AWS ALB Controller
│       └── hpa/app-hpa.yaml
│
├── jenkins/
│   └── Jenkinsfile               # CI/CD pipeline
│
├── argocd/
│   └── application.yaml          # GitOps - ArgoCD app definition
│
├── scripts/
│   ├── eks-setup.sh              # Configure kubectl for EKS
│   ├── install-aws-lb-controller.sh
│   └── install-argocd.sh
│
└── docs/
    └── JENKINS_SETUP.md
```

---

## ✅ Step-by-Step Setup

### Step 1 — Configure kubectl for your EKS cluster
```bash
chmod +x scripts/*.sh
./scripts/eks-setup.sh
```

### Step 2 — Install AWS Load Balancer Controller
```bash
# Edit CLUSTER_NAME and AWS_REGION first
./scripts/install-aws-lb-controller.sh
```

### Step 3 — Install ArgoCD
```bash
./scripts/install-argocd.sh
```

### Step 4 — Push project to GitHub
```bash
git init
git add .
git commit -m "initial project setup"
git remote add origin https://github.com/YOUR_ORG/devops-practice.git
git push -u origin main
```

### Step 5 — Edit placeholders
Search and replace these in the project:
| Placeholder | Replace with |
|---|---|
| `YOUR_DOCKERHUB_USERNAME` | your Docker Hub username |
| `YOUR_ORG/devops-practice` | your GitHub repo path |
| `your-eks-cluster-name` | your EKS cluster name |
| `app.yourdomain.com` | your domain (or remove for ALB DNS) |

### Step 6 — Configure Jenkins
See `docs/JENKINS_SETUP.md`

### Step 7 — Apply ArgoCD Application
```bash
kubectl apply -f argocd/application.yaml
```
ArgoCD will auto-sync k8s manifests on every Git push.

### Step 8 — Local Dev with Docker Compose
```bash
docker-compose up -d
# App:   http://localhost:3000
# MySQL: localhost:3306
```

---

## 🔌 API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | /health | Health check |
| GET | /users | List all users |
| POST | /users | Create user `{name, email}` |
| DELETE | /users/:id | Delete user |

---

## 🔮 Future Upgrades (Already Stubbed)

| Feature | Status | Where |
|---|---|---|
| SonarQube code analysis | Commented out | `jenkins/Jenkinsfile` |
| Trivy image scan | Commented out | `jenkins/Jenkinsfile` |
| AWS Secrets Manager | TODO comment | `k8s/base/secret/` |
| HTTPS / ACM | TODO comment | `k8s/base/ingress/` |
| Multi-env overlays | Folder exists | `k8s/overlays/dev,prod` |
