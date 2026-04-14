# Java 后端常用技术栈

## 一、技术栈全景图

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           前端（展示层）                                     │
│         Vue.js / React / Angular / 小程序 / H5                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                           网关层（Gateway）                                  │
│              Spring Cloud Gateway / Nginx / Kong / Zuul                    │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                           业务层（Business）                                 │
│                    Spring Boot / Spring MVC / 业务逻辑                       │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                           服务层（Service）                                  │
│         Dubbo / Spring Cloud / gRPC / 微服务架构                           │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                           数据层（Data）                                     │
│              MySQL / PostgreSQL / Oracle / MongoDB / ES                    │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 二、核心框架

### 2.1 Spring 全家桶（必学）

| 框架 | 说明 | 学习优先级 |
|------|------|-----------|
| **Spring Framework** | IoC、AOP、核心容器 | ⭐⭐⭐⭐⭐ |
| **Spring Boot** | 快速开发、自动配置 | ⭐⭐⭐⭐⭐ |
| **Spring MVC** | Web 层框架 | ⭐⭐⭐⭐⭐ |
| **Spring Security** | 认证授权、安全控制 | ⭐⭐⭐⭐ |
| **Spring Data JPA** | ORM 框架 | ⭐⭐⭐ |
| **Spring Cloud** | 微服务全套解决方案 | ⭐⭐⭐⭐ |

### 2.2 其他框架

| 框架 | 说明 | 适用场景 |
|------|------|----------|
| **MyBatis / MyBatis-Plus** | SQL 映射框架 | 国内主流 |
| **Hibernate / JPA** | ORM 框架 | 国外主流 |
| **JFinal** | 轻量级框架 | 小型项目 |
| **Play Framework** | 响应式框架 | 高并发 |

---

## 三、数据存储

### 3.1 关系型数据库

| 数据库 | 说明 | 学习优先级 |
|--------|------|-----------|
| **MySQL** | 开源首选，国内最流行 | ⭐⭐⭐⭐⭐ |
| **PostgreSQL** | 功能强大，开源 | ⭐⭐⭐⭐ |
| **Oracle** | 商业数据库，大企业用 | ⭐⭐⭐ |
| **SQL Server** | 微软生态 | ⭐⭐ |
| **H2** | 内存数据库，测试用 | ⭐⭐⭐ |

### 3.2 NoSQL 数据库

| 数据库 | 类型 | 说明 | 优先级 |
|--------|------|------|--------|
| **Redis** | 键值存储 | 缓存、分布式锁、会话 | ⭐⭐⭐⭐⭐ |
| **Elasticsearch** | 搜索引擎 | 全文检索、日志分析 | ⭐⭐⭐⭐ |
| **MongoDB** | 文档存储 | 海量数据、灵活 schema | ⭐⭐⭐ |
| **Cassandra** | 列存储 | 高可用、分布式 | ⭐⭐ |
| **Neo4j** | 图数据库 | 关系分析 | ⭐ |

### 3.3 消息队列

| MQ | 说明 | 优先级 |
|----|------|--------|
| **Kafka** | 高吞吐、日志采集 | ⭐⭐⭐⭐⭐ |
| **RabbitMQ** | 稳定、易用 | ⭐⭐⭐⭐ |
| **RocketMQ** | 阿里出品，金融级 | ⭐⭐⭐ |
| **Pulsar** | 云原生、多租户 | ⭐⭐ |

---

## 四、缓存技术

| 技术 | 说明 | 优先级 |
|------|------|--------|
| **Redis** | 内存缓存、分布式 | ⭐⭐⭐⭐⭐ |
| **Caffeine** | 本地缓存、高性能 | ⭐⭐⭐⭐ |
| **Ehcache** | 本地缓存、Hibernate 二级缓存 | ⭐⭐⭐ |
| **Guava Cache** | Google 出品 | ⭐⭐⭐ |

---

## 五、微服务架构

### 5.1 服务框架

| 框架 | 说明 | 优先级 |
|------|------|--------|
| **Spring Cloud Alibaba** | 国内主流微服务方案 | ⭐⭐⭐⭐⭐ |
| **Spring Cloud Netflix** | 国外主流（部分已停更） | ⭐⭐⭐ |
| **Dubbo** | 阿里 RPC 框架 | ⭐⭐⭐⭐ |
| **gRPC** | Google RPC 框架 | ⭐⭐⭐ |

### 5.2 微服务组件

| 组件 | 说明 | 对应产品 |
|------|------|----------|
| 服务注册与发现 | 服务治理 | Nacos / Eureka / Consul |
| 配置中心 | 统一配置 | Nacos / Apollo / Spring Cloud Config |
| 服务网关 | 统一入口 | Spring Cloud Gateway / Zuul |
| 负载均衡 | 流量分发 | Ribbon / LoadBalancer |
| 熔断降级 | 服务保护 | Sentinel / Hystrix |
| 链路追踪 | 调用链监控 | SkyWalking / Zipkin / Jaeger |
| 分布式事务 | 事务一致性 | Seata |

---

## 六、中间件

| 中间件 | 说明 | 优先级 |
|--------|------|--------|
| **Nginx** | Web 服务器、反向代理 | ⭐⭐⭐⭐⭐ |
| **Tomcat** | Servlet 容器 | ⭐⭐⭐⭐⭐ |
| **Undertow** | 高性能 Web 服务器 | ⭐⭐⭐ |
| **Jetty** | 轻量级 Web 服务器 | ⭐⭐⭐ |

---

## 七、开发工具

### 7.1 IDE

| 工具 | 说明 | 优先级 |
|------|------|--------|
| **IntelliJ IDEA** | Java 开发首选 | ⭐⭐⭐⭐⭐ |
| **Eclipse** | 开源免费 | ⭐⭐⭐ |
| **VS Code** | 轻量级 | ⭐⭐ |

### 7.2 构建工具

| 工具 | 说明 | 优先级 |
|------|------|--------|
| **Maven** | 项目构建、依赖管理 | ⭐⭐⭐⭐⭐ |
| **Gradle** | 灵活、性能好 | ⭐⭐⭐⭐ |

### 7.3 版本控制

| 工具 | 说明 | 优先级 |
|------|------|--------|
| **Git** | 分布式版本控制 | ⭐⭐⭐⭐⭐ |
| **GitHub/GitLab/Gitee** | 代码托管平台 | ⭐⭐⭐⭐⭐ |
| **SVN** | 集中式版本控制 | ⭐⭐ |

---

## 八、测试工具

| 工具 | 说明 | 优先级 |
|------|------|--------|
| **JUnit 5** | 单元测试 | ⭐⭐⭐⭐⭐ |
| **Mockito** | Mock 框架 | ⭐⭐⭐⭐⭐ |
| **TestNG** | 测试框架 | ⭐⭐⭐ |
| **Postman** | 接口测试 | ⭐⭐⭐⭐⭐ |
| **JMeter** | 性能测试 | ⭐⭐⭐⭐ |
| **Swagger** | API 文档 | ⭐⭐⭐⭐⭐ |

---

## 九、运维与监控

| 工具 | 说明 | 优先级 |
|------|------|--------|
| **Docker** | 容器化 | ⭐⭐⭐⭐⭐ |
| **Kubernetes** | 容器编排 | ⭐⭐⭐⭐⭐ |
| **Jenkins** | CI/CD | ⭐⭐⭐⭐ |
| **GitLab CI** | 持续集成 | ⭐⭐⭐⭐ |
| **Prometheus** | 监控告警 | ⭐⭐⭐⭐ |
| **Grafana** | 可视化 | ⭐⭐⭐⭐ |
| **ELK** | 日志收集 | ⭐⭐⭐⭐ |

---

## 十、学习路线图

### 第一阶段：基础（1-2个月）
```
Java 基础 → MySQL → JDBC → Maven/Git
```

### 第二阶段：Web开发（2-3个月）
```
Servlet/JSP → Spring → Spring MVC → MyBatis → Spring Boot
```

### 第三阶段：中间件（1-2个月）
```
Redis → RabbitMQ/Kafka → Elasticsearch → Nginx
```

### 第四阶段：微服务（2-3个月）
```
Spring Cloud → Docker → Kubernetes → Dubbo
```

### 第五阶段：进阶（持续学习）
```
高并发 → 性能优化 → 架构设计 → 源码阅读
```

---

## 十一、常用依赖坐标

### 11.1 Spring Boot 3

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.1.5</version>
</parent>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>
</dependencies>
```

### 11.2 MyBatis Plus

```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-spring-boot3-starter</artifactId>
    <version>3.5.5</version>
</dependency>
```

### 11.3 常用工具

```xml
<!-- Lombok -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
</dependency>

<!-- Hutool -->
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-all</artifactId>
    <version>5.8.23</version>
</dependency>

<!-- Fastjson2 -->
<dependency>
    <groupId>com.alibaba.fastjson2</groupId>
    <artifactId>fastjson2</artifactId>
    <version>2.0.43</version>
</dependency>
```

---

## 十二、技术栈总结

| 类别 | 必学 | 推荐 | 了解 |
|------|------|------|------|
| 框架 | Spring Boot、MyBatis | Spring Cloud | Dubbo、gRPC |
| 数据库 | MySQL、Redis | PostgreSQL | MongoDB、ES |
| 消息队列 | RabbitMQ | Kafka | RocketMQ |
| 容器 | Docker | K8s | - |
| 工具 | Maven、Git | Gradle | - |
| 测试 | JUnit、Mockito | JMeter | TestNG |

---

**建议**：先从 Spring Boot + MyBatis + MySQL + Redis 入手，这是最常用、最核心的技术栈，掌握后再逐步学习微服务相关技术。