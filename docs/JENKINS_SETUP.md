# Jenkins Setup Guide

## 1. Required Plugins
Install from **Manage Jenkins → Plugins**:
- **Pipeline** (usually pre-installed)
- **Git Plugin**
- **Docker Pipeline**
- **Credentials Binding**
- **GitHub Integration** (for webhooks)

---

## 2. Credentials to Add
Go to **Manage Jenkins → Credentials → Global → Add Credential**

| ID | Type | Description |
|----|------|-------------|
| `dockerhub-credentials` | Username & Password | Docker Hub login |
| `github-token` | Username & Password | GitHub PAT (for git push in pipeline) |

---

## 3. Create the Pipeline Job
1. New Item → **Pipeline**
2. Name: `devops-practice-app`
3. **Pipeline section:**
   - Definition: **Pipeline script from SCM**
   - SCM: **Git**
   - Repository URL: your GitHub repo
   - Credentials: `github-token`
   - Branch: `*/main`
   - Script Path: `jenkins/Jenkinsfile`
4. **Build Triggers:** Check **GitHub hook trigger for GITScm polling**

---

## 4. GitHub Webhook
In your GitHub repo → **Settings → Webhooks → Add webhook**:
- Payload URL: `http://YOUR_JENKINS_IP:8080/github-webhook/`
- Content type: `application/json`
- Events: **Just the push event**

---

## 5. Jenkins needs Docker access
On your Jenkins server, add the jenkins user to the docker group:
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

---

## Future: Add SonarQube
1. Install **SonarQube Scanner** plugin
2. Configure under **Manage Jenkins → Configure System → SonarQube servers**
3. Uncomment the SonarQube stage in `jenkins/Jenkinsfile`

## Future: Add Trivy
1. Install Trivy on Jenkins server:
   ```bash
   curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
   ```
2. Uncomment the Trivy stage in `jenkins/Jenkinsfile`
