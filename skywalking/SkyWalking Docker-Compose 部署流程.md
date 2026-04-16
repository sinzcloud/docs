下面给你一套**最基础、最适合新手**的 SkyWalking Docker-Compose 部署流程（OAP + UI，默认 H2 存储），复制即可用。

---

## 1）创建目录

```bash
mkdir skywalking
cd skywalking
```

---

## 2）编写 docker-compose.yml

创建文件 `docker-compose.yml`：

```yaml
version: "3.8"

services:
  oap:
    image: apache/skywalking-oap-server:9.6.0
    container_name: skywalking-oap
    restart: always
    ports:
      - "11800:11800"   # agent 上报端口
      - "12800:12800"   # OAP REST API
    environment:
      SW_STORAGE: h2

  ui:
    image: apache/skywalking-ui:9.6.0
    container_name: skywalking-ui
    restart: always
    depends_on:
      - oap
    ports:
      - "8080:8080"
    environment:
      SW_OAP_ADDRESS: http://oap:12800
```

---

## 3）启动 SkyWalking

```bash
docker-compose up -d
```

查看容器状态：

```bash
docker ps
```

---

## 4）确认日志正常

```bash
docker logs -f skywalking-oap
```

如果看到类似 “Started SkyWalking OAP Server” 就正常。

---

## 5）访问 UI

浏览器访问：

```
http://localhost:8080
```

如果是服务器部署，把 `localhost` 换成服务器 IP。

---

## 6）常见端口说明（必须记住）

* **11800**：Java Agent 上报数据用（gRPC）
* **12800**：OAP 提供 API 给 UI
* **8080**：SkyWalking UI 页面

---

## 7）下一步：Java 服务接入 Agent（核心）

SkyWalking 部署完只是第一步，还需要 Java 服务挂 agent 才能看到数据。

你只要告诉我你是：

* Windows 本地跑 Spring Boot
* 还是 Linux 服务器跑 jar

我就给你对应的 agent 下载、配置、启动命令。
