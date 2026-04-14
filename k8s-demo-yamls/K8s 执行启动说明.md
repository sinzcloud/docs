下面给你一份**完善的 K8s 执行启动说明**（适用于 Windows11 + Docker Desktop Kubernetes），包含：镜像构建 → YAML 部署顺序 → 域名访问 → MQTT 暴露 → 常见排错 → 重置初始化。

---

# 0）前置条件检查

确认 Kubernetes 正常：

```powershell
kubectl get nodes
```

确认 namespace `demo` 不存在或可用：

```powershell
kubectl get ns
```

---

# 1）构建 SpringBoot 镜像（必须先做）

## 1.1 打包 jar（在项目根目录 iot-platform）

```powershell
mvn clean package -DskipTests
```

确认 jar 存在：

```powershell
dir iot-application\target
```

## 1.2 构建镜像（进入 iot-application）

Dockerfile 放在 `iot-application/Dockerfile`

```powershell
cd iot-application
docker build -t iot-platform:1.0 .
```

确认镜像存在：

```powershell
docker images | findstr iot-platform
```

---

# 2）准备 YAML 文件列表

确保目录下有：

* `namespace.yaml`
* `mysql-init.yaml`
* `mysql.yaml`
* `redis.yaml`
* `influxdb.yaml`
* `emqx.yaml`
* `app-configmap.yaml`
* `app-deployment.yaml`
* `app-service.yaml`
* `ingress.yaml`（可选）

---

# 3）执行部署顺序（严格按这个）

进入 yaml 目录后执行：

## 3.1 创建 Namespace

```powershell
kubectl apply -f namespace.yaml
```

---

## 3.2 部署 MySQL 初始化脚本（init.sql）

```powershell
kubectl apply -f mysql-init.yaml
```

---

## 3.3 部署 MySQL

```powershell
kubectl apply -f mysql.yaml
```

等待 mysql 启动：

```powershell
kubectl -n demo get pods
```

必须看到：
`mysql-0 Running`

---

## 3.4 部署 Redis

```powershell
kubectl apply -f redis.yaml
```

---

## 3.5 部署 InfluxDB

```powershell
kubectl apply -f influxdb.yaml
```

等待 `influxdb-0 Running`

---

## 3.6 部署 EMQX

```powershell
kubectl apply -f emqx.yaml
```

---

## 3.7 部署 SpringBoot 配置 ConfigMap

⚠️ 重点：app-configmap.yaml 里 org/bucket/token 必须和 influxdb.yaml 一致。

```powershell
kubectl apply -f app-configmap.yaml
```

---

## 3.8 部署 SpringBoot Deployment

```powershell
kubectl apply -f app-deployment.yaml
```

---

## 3.9 部署 SpringBoot Service

```powershell
kubectl apply -f app-service.yaml
```

---

# 4）验证全部组件状态

```powershell
kubectl -n demo get pods
kubectl -n demo get svc
```

所有 Pod 都应该是 `Running`。

---

# 5）访问方式（本地调试推荐）

## 5.1 访问 SpringBoot

```powershell
kubectl -n demo port-forward svc/iot-platform 8080:8080
```

浏览器访问：
`http://localhost:8080`

---

## 5.2 访问 EMQX Dashboard

```powershell
kubectl -n demo port-forward svc/emqx 18083:18083
```

访问：
`http://localhost:18083`

---

## 5.3 MQTT 1883 暴露（外部客户端连接）

如果 emqx.yaml 用 NodePort（如 31883），则 MQTT 连接地址：

`tcp://localhost:31883`

查看端口：

```powershell
kubectl -n demo get svc emqx
```

---

# 6）域名访问（demo.local）

域名访问需要 Ingress Controller + Ingress YAML。

## 6.1 安装 Ingress Controller（只做一次）

```powershell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/cloud/deploy.yaml
```

检查：

```powershell
kubectl get pods -n ingress-nginx
```

必须 Running。

---

## 6.2 部署 ingress.yaml

```powershell
kubectl apply -f ingress.yaml
kubectl -n demo get ingress
```

---

## 6.3 修改 Windows hosts

编辑：

`C:\Windows\System32\drivers\etc\hosts`

加入：

```
127.0.0.1 demo.local
```

刷新 DNS：

```powershell
ipconfig /flushdns
```

---

## 6.4 Docker Desktop 必要步骤（常见坑）

Docker Desktop 有时不会自动把 ingress 80 映射到本机，需要 port-forward：

```powershell
kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 80:80
```

然后访问：

`http://demo.local`

---

# 7）查看日志（排错核心）

## 7.1 查看 SpringBoot 日志

```powershell
kubectl -n demo logs -f deploy/iot-platform
```

## 7.2 查看 MySQL 日志

```powershell
kubectl -n demo logs -f mysql-0
```

## 7.3 查看 InfluxDB 日志

```powershell
kubectl -n demo logs -f influxdb-0
```

## 7.4 查看 Pod 事件

```powershell
kubectl -n demo get events --sort-by=.metadata.creationTimestamp
```

---

# 8）验证 MySQL 初始化是否成功

```powershell
kubectl -n demo exec -it mysql-0 -- mysql -uroot -p
```

然后：

```sql
USE iot;
SHOW TABLES;
SELECT * FROM sys_user;
```

---

# 9）修改配置文件后如何生效

修改 `app-configmap.yaml` 后执行：

```powershell
kubectl apply -f app-configmap.yaml
kubectl rollout restart deployment iot-platform -n demo
```

---

# 10）InfluxDB 常见问题（401/404）

必须确保三者一致：

* influxdb.yaml 初始化的 org/bucket/token
* app-configmap.yaml 里的 org/bucket/token
* 你的代码使用的 org/bucket/token

⚠️ InfluxDB 初始化只执行一次，如果改了 influxdb.yaml 必须删 PVC：

```powershell
kubectl -n demo delete statefulset influxdb
kubectl -n demo delete pvc influxdb-data-influxdb-0
kubectl apply -f influxdb.yaml
```

---

# 11）重新初始化 MySQL（重新执行 init.sql）

MySQL 也一样，只初始化一次。要重跑 init.sql：

```powershell
kubectl -n demo delete statefulset mysql
kubectl -n demo delete pvc mysql-data-mysql-0
kubectl apply -f mysql.yaml
```

---

# 12）一键删除整套环境（清理）

```powershell
kubectl delete -f ingress.yaml
kubectl delete -f app-service.yaml
kubectl delete -f app-deployment.yaml
kubectl delete -f app-configmap.yaml
kubectl delete -f emqx.yaml
kubectl delete -f influxdb.yaml
kubectl delete -f redis.yaml
kubectl delete -f mysql.yaml
kubectl delete -f mysql-init.yaml
kubectl delete -f namespace.yaml
```

---

# 13）最推荐的启动检查顺序（快速判断是否正常）

启动后你只要检查：

```powershell
kubectl -n demo get pods
kubectl -n demo logs deploy/iot-platform
```

如果 iot-platform 日志里显示：

* MySQL 连接成功
* Redis 连接成功
* Influx 写入正常
* MQTT 连接成功

就说明整套部署成功。

---
