# Maven 使用说明文档

## 目录
1. [Maven 简介](#一maven-简介)
2. [安装与配置](#二安装与配置)
3. [核心概念](#三核心概念)
4. [常用命令](#四常用命令)
5. [多模块项目管理](#五多模块项目管理)
6. [版本管理](#六版本管理)
7. [依赖管理](#七依赖管理)
8. [常见问题](#八常见问题)

---

## 一、Maven 简介

### 1.1 什么是 Maven？

Maven 是 Java 项目的**构建工具**，主要功能：
- 管理项目依赖（jar 包）
- 编译、测试、打包、发布
- 多模块项目管理

### 1.2 为什么使用 Maven？

| 场景 | 没有 Maven | 使用 Maven |
|------|-----------|-----------|
| 添加依赖 | 手动下载 jar 包 | 一行配置自动下载 |
| 编译 | 手动 javac | `mvn compile` |
| 打包 | 手动 jar | `mvn package` |
| 测试 | 手动运行 | `mvn test` |

---

## 二、安装与配置

### 2.1 下载 Maven

```bash
# 下载地址
https://maven.apache.org/download.cgi

# Windows 下载：apache-maven-3.9.9-bin.zip
# 解压到：D:\apache-maven-3.9.9
```

### 2.2 配置环境变量（Windows 11）

```cmd
# 1. 打开系统环境变量
右键"此电脑" → 属性 → 高级系统设置 → 环境变量

# 2. 新建 MAVEN_HOME
变量名：MAVEN_HOME
变量值：D:\apache-maven-3.9.9

# 3. 编辑 PATH
添加：%MAVEN_HOME%\bin

# 4. 验证安装
mvn -version
```

### 2.3 配置阿里云镜像（加速下载）

**修改 `D:\apache-maven-3.9.9\conf\settings.xml`**

```xml
<mirrors>
    <mirror>
        <id>aliyun</id>
        <mirrorOf>central</mirrorOf>
        <name>Aliyun Maven</name>
        <url>https://maven.aliyun.com/repository/public</url>
    </mirror>
</mirrors>
```

### 2.4 配置本地仓库

```xml
<!-- settings.xml -->
<localRepository>D:\maven-repo</localRepository>
```

---

## 三、核心概念

### 3.1 pom.xml（项目对象模型）

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>
    <!-- 项目坐标 -->
    <groupId>com.mycompany</groupId>     <!-- 组织/公司 -->
    <artifactId>my-project</artifactId> <!-- 项目名称 -->
    <version>1.0.0-SNAPSHOT</version>   <!-- 版本号 -->
    
    <!-- 依赖管理 -->
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>3.1.5</version>
        </dependency>
    </dependencies>
</project>
```

### 3.2 坐标（GAV）

| 组成部分 | 说明 | 示例 |
|---------|------|------|
| groupId | 组织/公司 | com.ddd.platform |
| artifactId | 项目名 | ddd-common |
| version | 版本 | 1.0.0-SNAPSHOT |

### 3.3 依赖范围（scope）

| scope | 说明 | 适用场景 |
|-------|------|----------|
| compile | 默认，编译和运行时都需要 | spring-web |
| provided | 编译需要，运行时容器提供 | lombok |
| test | 仅测试需要 | junit |
| runtime | 运行时需要，编译不需要 | mysql驱动 |

### 3.4 生命周期

```
validate → compile → test → package → verify → install → deploy
   ↓         ↓        ↓        ↓         ↓         ↓         ↓
验证      编译      测试      打包      验证      安装      部署
```

---

## 四、常用命令

### 4.1 基础命令

```bash
# 清理编译文件
mvn clean

# 编译项目
mvn compile

# 运行测试
mvn test

# 打包（生成 jar/war）
mvn package

# 安装到本地仓库
mvn install

# 部署到远程仓库
mvn deploy
```

### 4.2 组合命令

```bash
# 清理 + 打包（跳过测试）
mvn clean package -D skipTests=true

# 清理 + 安装
mvn clean install

# 清理 + 编译
mvn clean compile
```

### 4.3 指定模块

```bash
# 只编译 common 模块
mvn compile -pl ddd-common

# 编译 common 及其依赖的模块
mvn compile -pl ddd-common -am
```

### 4.4 常用参数

```bash
# 跳过测试
-D skipTests=true

# 跳过测试编译
-D maven.test.skip=true

# 指定编码
-D file.encoding=UTF-8

# 指定 profile
-P dev

# 显示详细信息
-X
```

---

## 五、多模块项目管理

### 5.1 父模块 pom.xml

```xml
<groupId>com.mycompany</groupId>
<artifactId>my-parent</artifactId>
<version>1.0.0-SNAPSHOT</version>
<packaging>pom</packaging>

<!-- 统一版本管理 -->
<properties>
    <spring-boot.version>3.1.5</spring-boot.version>
</properties>

<!-- 依赖版本管理 -->
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>${spring-boot.version}</version>
        </dependency>
    </dependencies>
</dependencyManagement>

<!-- 子模块列表 -->
<modules>
    <module>my-common</module>
    <module>my-core</module>
    <module>my-web</module>
</modules>
```

### 5.2 子模块 pom.xml

```xml
<parent>
    <groupId>com.mycompany</groupId>
    <artifactId>my-parent</artifactId>
    <version>1.0.0-SNAPSHOT</version>
</parent>

<artifactId>my-common</artifactId>
<!-- version 继承父项目，不需要写 -->
```

### 5.3 项目结构

```
my-project/
├── pom.xml              # 根 pom（可选）
├── my-parent/           # 父模块
│   └── pom.xml
├── my-common/           # 公共模块
│   ├── pom.xml
│   └── src/
├── my-core/             # 核心模块
│   ├── pom.xml
│   └── src/
└── my-web/              # Web模块
    ├── pom.xml
    └── src/
```

---

## 六、版本管理

### 6.1 版本号规范

| 类型 | 格式 | 示例 |
|------|------|------|
| 开发版 | x.x.x-SNAPSHOT | 1.0.0-SNAPSHOT |
| 正式版 | x.x.x | 1.0.0 |
| 里程碑 | x.x.x-Mx | 1.0.0-M1 |
| 候选版 | x.x.x-RCx | 1.0.0-RC1 |

### 6.2 版本操作命令

```bash
# 查看当前版本
mvn help:evaluate -D expression=project.version -q -DforceStdout

# 设置新版本（注意：-D 后面有空格）
mvn versions:set -D newVersion=1.0.1-SNAPSHOT

# 提交版本更改
mvn versions:commit

# 恢复旧版本
mvn versions:revert

# 查看依赖更新
mvn versions:display-dependency-updates
```

### 6.3 版本升级示例

```bash
# 1. 当前版本 1.0.0-SNAPSHOT
mvn help:evaluate -D expression=project.version -q -DforceStdout
# 输出: 1.0.0-SNAPSHOT

# 2. 升级到 1.0.1-SNAPSHOT
mvn versions:set -D newVersion=1.0.1-SNAPSHOT

# 3. 提交
mvn versions:commit

# 4. 验证
mvn help:evaluate -D expression=project.version -q -DforceStdout
# 输出: 1.0.1-SNAPSHOT
```

### 6.4 正式发布流程

```bash
# 1. 运行测试
mvn clean test

# 2. 设置正式版本
mvn versions:set -D newVersion=1.0.0

# 3. 打包
mvn clean package

# 4. 部署
mvn deploy

# 5. 打 Git 标签
git tag -a v1.0.0 -m "Release version 1.0.0"

# 6. 开始下一个开发版本
mvn versions:set -D newVersion=1.0.1-SNAPSHOT
```

---

## 七、依赖管理

### 7.1 添加依赖

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <version>3.1.5</version>
    </dependency>
</dependencies>
```

### 7.2 排除传递依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

### 7.3 查看依赖树

```bash
# 查看所有依赖
mvn dependency:tree

# 查看特定依赖
mvn dependency:tree -D includes=org.springframework.boot

# 查看依赖冲突
mvn dependency:tree -D verbose
```

---

## 八、常见问题

### 8.1 依赖下载慢

**解决方案**：配置阿里云镜像

```xml
<mirror>
    <id>aliyun</id>
    <mirrorOf>central</mirrorOf>
    <url>https://maven.aliyun.com/repository/public</url>
</mirror>
```

### 8.2 编译乱码

```bash
mvn compile -D file.encoding=UTF-8
```

### 8.3 版本号变成 1

**原因**：`-D` 后面没有空格

```bash
# 错误 ❌
mvn versions:set -DnewVersion=1.0.1

# 正确 ✅
mvn versions:set -D newVersion=1.0.1
```

### 8.4 依赖冲突

```bash
# 查看冲突
mvn dependency:tree -D verbose

# 排除冲突依赖
<exclusions>
    <exclusion>
        <groupId>conflict-group</groupId>
        <artifactId>conflict-artifact</artifactId>
    </exclusion>
</exclusions>
```

### 8.5 找不到符号

```bash
# 清理重新编译
mvn clean compile

# 先 install 依赖模块
mvn install -pl ddd-common -am
```

---

## 九、快速命令参考

| 命令 | 说明 |
|------|------|
| `mvn clean` | 清理 |
| `mvn compile` | 编译 |
| `mvn test` | 测试 |
| `mvn package` | 打包 |
| `mvn install` | 安装到本地 |
| `mvn deploy` | 部署到远程 |
| `mvn clean package -D skipTests=true` | 打包跳过测试 |
| `mvn versions:set -D newVersion=1.0.1` | 设置版本 |
| `mvn versions:commit` | 提交版本 |
| `mvn dependency:tree` | 查看依赖树 |

---

## 十、常用插件

```xml
<build>
    <plugins>
        <!-- 编译插件 -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <configuration>
                <source>17</source>
                <target>17</target>
                <encoding>UTF-8</encoding>
            </configuration>
        </plugin>
        
        <!-- 测试插件 -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <configuration>
                <skipTests>true</skipTests>
            </configuration>
        </plugin>
        
        <!-- Spring Boot 打包插件 -->
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

---

**文档版本**：1.0  
**更新日期**：2026-04-14  
**适用 Maven 版本**：3.9+