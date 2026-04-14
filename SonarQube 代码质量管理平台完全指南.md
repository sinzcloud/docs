# SonarQube 代码质量管理平台完全指南

## 一、SonarQube 简介

### 1.1 什么是 SonarQube？

SonarQube 是一个开源的代码质量管理平台，用于持续检查代码质量，发现 Bug、漏洞、代码异味。

### 1.2 核心功能

| 功能 | 说明 |
|------|------|
| **Bug 检测** | 潜在的运行时错误 |
| **漏洞检测** | 安全漏洞 |
| **代码异味** | 可维护性问题 |
| **代码覆盖率** | 测试覆盖情况 |
| **重复代码** | 重复代码块检测 |
| **复杂度分析** | 圈复杂度 |
| **技术债务** | 修复问题所需时间 |

---

## 二、安装与启动

### 2.1 Docker 安装（推荐）

```bash
# 拉取镜像
docker pull sonarqube:latest

# 运行 SonarQube（开发模式）
docker run -d --name sonarqube \
  -p 9000:9000 \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  sonarqube:latest

# 访问
http://localhost:9000
# 默认账号密码: admin / admin
```

### 2.2 Docker Compose 安装

**docker-compose-sonar.yml**

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    container_name: sonar-postgres
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonar
      POSTGRES_DB: sonar
    volumes:
      - postgres-data:/var/lib/postgresql/data

  sonarqube:
    image: sonarqube:latest
    container_name: sonarqube
    ports:
      - "9000:9000"
    environment:
      - SONAR_JDBC_URL=jdbc:postgresql://postgres:5432/sonar
      - SONAR_JDBC_USERNAME=sonar
      - SONAR_JDBC_PASSWORD=sonar
    volumes:
      - sonar-data:/opt/sonarqube/data
      - sonar-extensions:/opt/sonarqube/extensions
    depends_on:
      - postgres

volumes:
  postgres-data:
  sonar-data:
  sonar-extensions:
```

```bash
# 启动
docker-compose -f docker-compose-sonar.yml up -d
```

### 2.3 Windows 本地安装

```bash
# 1. 下载 SonarQube
# https://www.sonarqube.org/downloads/

# 2. 解压到 D:\sonarqube

# 3. 启动
cd D:\sonarqube\bin\windows-x86-64
StartSonar.bat

# 4. 访问
http://localhost:9000
```

---

## 三、Maven 集成

### 3.1 配置 pom.xml

```xml
<properties>
    <sonar.host.url>http://localhost:9000</sonar.host.url>
    <sonar.login>admin</sonar.login>
    <sonar.password>admin</sonar.password>
    <sonar.java.source>17</sonar.java.source>
    <sonar.java.target>17</sonar.java.target>
    <sonar.coverage.jacoco.xmlReportPaths>target/site/jacoco/jacoco.xml</sonar.coverage.jacoco.xmlReportPaths>
</properties>

<build>
    <plugins>
        <!-- JaCoCo 覆盖率插件 -->
        <plugin>
            <groupId>org.jacoco</groupId>
            <artifactId>jacoco-maven-plugin</artifactId>
            <version>0.8.11</version>
            <executions>
                <execution>
                    <goals>
                        <goal>prepare-agent</goal>
                    </goals>
                </execution>
                <execution>
                    <id>report</id>
                    <phase>test</phase>
                    <goals>
                        <goal>report</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

### 3.2 执行代码分析

```bash
# 基本分析
mvn clean verify sonar:sonar

# 指定项目Key和名称
mvn clean verify sonar:sonar \
  -Dsonar.projectKey=ddd-platform \
  -Dsonar.projectName="DDD Platform" \
  -Dsonar.projectVersion=1.0.0

# 跳过测试
mvn clean verify sonar:sonar -DskipTests

# 指定分支
mvn sonar:sonar -Dsonar.branch.name=develop
```

### 3.3 多模块项目配置

**父 pom.xml**

```xml
<properties>
    <sonar.host.url>http://localhost:9000</sonar.host.url>
    <sonar.login>admin</sonar.login>
    <sonar.password>admin</sonar.password>
    <sonar.modules>ddd-common,ddd-domain,ddd-application,ddd-infrastructure,ddd-interfaces,ddd-bootstrap</sonar.modules>
</properties>

<build>
    <pluginManagement>
        <plugins>
            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <version>0.8.11</version>
            </plugin>
        </plugins>
    </pluginManagement>
</build>
```

---

## 四、Gradle 集成

### 4.1 build.gradle

```groovy
plugins {
    id 'java'
    id 'jacoco'
    id 'org.sonarqube' version '4.4.1.3373'
}

sonarqube {
    properties {
        property "sonar.host.url", "http://localhost:9000"
        property "sonar.login", "admin"
        property "sonar.password", "admin"
        property "sonar.projectKey", "ddd-platform"
        property "sonar.projectName", "DDD Platform"
        property "sonar.java.source", "17"
        property "sonar.coverage.jacoco.xmlReportPaths", "${buildDir}/reports/jacoco/test/jacocoTestReport.xml"
    }
}

jacocoTestReport {
    reports {
        xml.required = true
        html.required = true
    }
}

test {
    finalizedBy jacocoTestReport
}
```

```bash
# 执行分析
./gradlew test sonar
```

---

## 五、质量配置

### 5.1 质量门禁（Quality Gate）

```yaml
质量门禁标准:
  - 覆盖率 >= 80%
  - 重复代码 <= 3%
  - 圈复杂度 <= 15
  - 阻塞级 Bug = 0
  - 严重级漏洞 = 0
  - 技术债务比例 <= 5%
```

### 5.2 质量配置示例

```xml
<properties>
    <!-- 质量门禁配置 -->
    <sonar.coverage.exclusions>
        **/config/**,
        **/dto/**,
        **/po/**,
        **/constant/**
    </sonar.coverage.exclusions>
    
    <!-- 排除重复检查 -->
    <sonar.cpd.exclusions>
        **/entity/*.java
    </sonar.cpd.exclusions>
    
    <!-- 排除的文件 -->
    <sonar.exclusions>
        **/generated/**,
        **/protobuf/**
    </sonar.exclusions>
</properties>
```

---

## 六、CI/CD 集成

### 6.1 Jenkins Pipeline

```groovy
pipeline {
    agent any
    
    stages {
        stage('Build & Test') {
            steps {
                sh 'mvn clean test'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}
```

### 6.2 GitLab CI

```yaml
# .gitlab-ci.yml
sonarqube:
  stage: test
  script:
    - mvn clean verify sonar:sonar
  only:
    - main
    - develop
  tags:
    - sonarqube
```

### 6.3 GitHub Actions

```yaml
# .github/workflows/sonar.yml
name: SonarQube Analysis

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  sonar:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          
      - name: Build and analyze
        run: mvn clean verify sonar:sonar
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

---

## 七、常用规则配置

### 7.1 自定义规则文件

**sonar-project.properties**

```properties
# 项目配置
sonar.projectKey=ddd-platform
sonar.projectName=DDD Platform
sonar.projectVersion=1.0.0

# 语言配置
sonar.language=java
sonar.java.source=17

# 源码目录
sonar.sources=ddd-common/src/main/java,ddd-domain/src/main/java,ddd-application/src/main/java

# 测试目录
sonar.tests=ddd-common/src/test/java,ddd-domain/src/test/java

# 覆盖率
sonar.coverage.exclusions=**/*DTO.java,**/*PO.java,**/config/*.java

# 重复检查排除
sonar.cpd.exclusions=**/entity/*.java

# 排除文件
sonar.exclusions=**/generated-sources/**,**/protobuf/**

# 报告路径
sonar.junit.reportsPath=target/surefire-reports
sonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml
```

### 7.2 质量配置示例

```java
// 会被 SonarQube 检测的问题示例

// 1. 空 catch 块
try {
    // ...
} catch (Exception e) {
    // 空块 - 会被检测为代码异味
}

// 2. 魔法数字
if (status == 1) {  // 1 是魔法数字，应定义为常量
    // ...
}

// 3. 未使用的变量
String unused = "never used";  // 未使用变量

// 4. 过于复杂的方法
public void complexMethod() {
    // 圈复杂度 > 10 会警告
}

// 5. 重复代码
// 相同代码出现多次会被检测
```

---

## 八、插件扩展

### 8.1 常用插件

| 插件 | 说明 |
|------|------|
| **Java** | Java 代码分析（内置）|
| **JaCoCo** | 代码覆盖率 |
| **Checkstyle** | 代码风格 |
| **SpotBugs** | Bug 检测 |
| **PMD** | 代码分析 |

### 8.2 安装插件

```bash
# Docker 安装插件
docker exec -it sonarqube bash
cd /opt/sonarqube/extensions/plugins
wget https://github.com/checkstyle/sonar-checkstyle/releases/download/xxx.jar

# 重启 SonarQube
docker restart sonarqube
```

---

## 九、查看报告

### 9.1 访问 SonarQube

```bash
# 主页面
http://localhost:9000

# 项目页面
http://localhost:9000/dashboard?id=ddd-platform

# API 接口
http://localhost:9000/api/projects/search
http://localhost:9000/api/measures/component?component=ddd-platform&metricKeys=coverage,bugs
```

### 9.2 常用指标

| 指标 | 含义 | 良好标准 |
|------|------|----------|
| **Reliability** | 可靠性（Bug） | A 级 |
| **Security** | 安全性（漏洞） | A 级 |
| **Maintainability** | 可维护性（异味） | A 级 |
| **Coverage** | 测试覆盖率 | ≥ 80% |
| **Duplications** | 重复代码 | ≤ 3% |
| **Complexity** | 圈复杂度 | ≤ 15 |
| **Technical Debt** | 技术债务 | ≤ 5% |

---

## 十、最佳实践

### 10.1 质量门禁建议

```yaml
质量门禁配置:
  必须通过:
    - 覆盖率: >= 80%
    - 重复代码: <= 3%
    - 阻塞级 Bug: 0
    - 严重级漏洞: 0
  建议通过:
    - 代码异味: <= 100
    - 圈复杂度: <= 15
    - 技术债务比例: <= 5%
```

### 10.2 分析频率

| 环境 | 频率 | 说明 |
|------|------|------|
| 本地开发 | 按需 | `mvn sonar:sonar` |
| 开发分支 | 每天 | CI 自动分析 |
| 主分支 | 每次提交 | 必须通过质量门禁 |
| 正式发布 | 必须 | 生成完整报告 |

### 10.3 修复优先级

```
1. 阻塞级 Bug（必须立即修复）
2. 严重级漏洞（必须修复）
3. 主要级代码异味（尽快修复）
4. 次要级问题（计划修复）
5. 信息级提示（可选）
```

---

## 十一、命令速查

```bash
# 基础分析
mvn clean verify sonar:sonar

# 指定服务器
mvn sonar:sonar -Dsonar.host.url=http://sonar.example.com:9000

# 指定认证
mvn sonar:sonar -Dsonar.login=mytoken

# 指定分支
mvn sonar:sonar -Dsonar.branch.name=feature/xxx

# 跳过测试
mvn sonar:sonar -DskipTests

# 查看帮助
mvn sonar:help -Ddetail=true
```

---

## 十二、总结

| 阶段 | 操作 |
|------|------|
| **安装** | Docker 快速启动 |
| **配置** | pom.xml 添加插件 |
| **执行** | `mvn clean verify sonar:sonar` |
| **查看** | http://localhost:9000 |
| **集成** | Jenkins / GitLab CI |
| **质量门禁** | 设置通过标准 |

**SonarQube 是企业级代码质量管理的标准工具，强烈推荐在 CI/CD 流程中集成。**