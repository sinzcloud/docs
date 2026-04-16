下面给你一份 **Win11 + Docker Desktop（WSL2）专用** 的 Jenkins `docker-compose.yml`，目标是：
✅ Jenkins 能执行 `docker build / docker run`
✅ Pipeline 里直接部署容器
✅ 一次跑通

---

# ✅ Win11 专用 Jenkins docker-compose.yml（推荐版本）

在 Jenkins 目录下创建 `docker-compose.yml`：

```yaml
version: "3.8"

services:
  jenkins:
    image: jenkins/jenkins:lts-jdk17
    container_name: jenkins
    restart: always
    user: root
    privileged: true
    ports:
      - "8080:8080"
      - "50000:50000"
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
```

---

# ✅ 启动 Jenkins

```bash
docker compose up -d
```

查看启动日志：

```bash
docker logs -f jenkins
```

---

# ✅ 获取 Jenkins 初始密码

```bash
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

浏览器访问：

```
http://localhost:8080
```

---

# ✅ 安装 Docker CLI（关键步骤）

Jenkins 镜像默认没有 docker 命令，需要手动装一次：

```bash
docker exec -it jenkins bash
```

容器里执行：

```bash
apt update
apt install -y docker.io
docker version
```

如果能看到 Client/Server 信息，说明 OK。

---

# ✅ 验证 Jenkins 是否能控制 Docker Desktop

```bash
docker exec -it jenkins docker ps
```

能看到容器列表就成功了。

---

# ⭐ 最终效果

你后续 Jenkins Pipeline 里写：

```bash
docker build ...
docker run ...
```

就不会再报 `Permission denied`。

---

# ⚠️ 重要提醒（Win11环境特点）

你在 Win11 上 Jenkins 部署的容器和你本机 Docker Desktop 是一套 Docker 引擎，所以：

* Jenkins 部署的容器会出现在 `docker ps` 里
* Jenkins 重启不会影响你部署的业务容器（除非你 stop 它）

---
