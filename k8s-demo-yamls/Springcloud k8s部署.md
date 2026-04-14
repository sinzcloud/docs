Windows 11（Docker Desktop Kubernetes）部署你这套 **Ingress + Gateway + Nacos + Prometheus/Grafana + EFK**，按下面步骤做即可（这是最贴近生产的做法）。

---

# 0）准备：开启 Docker Desktop Kubernetes

Docker Desktop → Settings → Kubernetes → 勾选 Enable Kubernetes → Apply & Restart

验证：

```powershell
kubectl get nodes
```

必须看到 `Ready`。

---

# 1）安装 Helm（必须）

PowerShell 执行：

```powershell
winget install Helm.Helm
```

验证：

```powershell
helm version
```

---

# 2）安装 Ingress-nginx（入口控制器）

```powershell
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace
```

检查：

```powershell
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
```

---

# 3）绑定域名 demo.local

编辑 hosts 文件（管理员）：

`C:\Windows\System32\drivers\etc\hosts`

加入：

```text
127.0.0.1 demo.local
```

刷新 DNS：

```powershell
ipconfig /flushdns
```

---

# 4）部署 Nacos（学习版）

```powershell
kubectl create namespace demo
kubectl apply -f nacos.yaml
```

访问 Nacos：

```powershell
kubectl -n demo port-forward svc/nacos 8848:8848
```

浏览器：

`http://localhost:8848/nacos`

---

# 5）部署 Gateway + 微服务（你的 SpringCloud 服务）

### 先构建镜像（本机 build）

```powershell
docker build -t gateway:1.0 .
docker build -t device-service:1.0 .
```

### 部署到 K8s

```powershell
kubectl apply -f gateway.yaml
kubectl apply -f device-service.yaml
```

检查：

```powershell
kubectl -n demo get pods
kubectl -n demo get svc
```

---

# 6）部署 Ingress（demo.local -> gateway）

```powershell
kubectl apply -f gateway-ingress.yaml
kubectl -n demo get ingress
```

访问：

`http://demo.local`

---

# 7）安装 Prometheus + Grafana（监控）

```powershell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install monitor prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
```

访问 Grafana：

```powershell
kubectl -n monitoring port-forward svc/monitor-grafana 3000:80
```

浏览器：

`http://localhost:3000`

获取 admin 密码：

```powershell
kubectl get secret -n monitoring monitor-grafana -o jsonpath="{.data.admin-password}" | % { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
```

---

# 8）安装 EFK（日志系统）

⚠️ Elasticsearch 很吃内存，Docker Desktop 建议至少 8GB。

## 8.1 安装 Elasticsearch + Kibana

```powershell
helm repo add elastic https://helm.elastic.co
helm repo update

helm install elasticsearch elastic/elasticsearch -n logging --create-namespace
helm install kibana elastic/kibana -n logging
```

## 8.2 安装 Fluent-bit

```powershell
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update

helm install fluent-bit fluent/fluent-bit -n logging
```

访问 Kibana：

```powershell
kubectl -n logging port-forward svc/kibana-kibana 5601:5601
```

浏览器：

`http://localhost:5601`

---

# 9）验证是否完整运行

```powershell
kubectl get pods -A
```

你应该看到：

* ingress-nginx Running
* nacos Running
* gateway Running
* prometheus/grafana Running
* elasticsearch Running
* kibana Running
* fluent-bit Running

---

# 10）最常用排错命令（Windows 必备）

```powershell
kubectl -n demo logs -f deploy/gateway
kubectl -n demo logs -f deploy/device-service
kubectl -n demo describe pod pod名
kubectl -n demo get events --sort-by=.metadata.creationTimestamp
```

---

# 重要建议（Docker Desktop 环境）

* **EFK 很重**，如果你电脑内存不够，建议改用：
  **Loki + Promtail + Grafana**（轻量很多）

---

如果你想，我可以给你一套“Win11 Docker Desktop 最佳实践”的脚本：
`install_all.ps1` 一键安装 Ingress + Nacos + Monitor + Loki（替代 EFK）。
