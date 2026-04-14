**IoT 物联网（Internet of Things）**指的是：把各种“物体”（设备、传感器、机器、车辆、家电等）连接到互联网，使它们能够**采集数据、互相通信、自动控制**的一种技术体系。

---

## 物联网的核心组成

一般 IoT 系统由 4 部分构成：

1. **感知层（传感器/设备）**
   例如温度传感器、摄像头、GPS、RFID、智能电表等，用来采集信息。

2. **网络层（通信）**
   负责传输数据，比如：

   * Wi-Fi / 蓝牙
   * 4G/5G
   * NB-IoT、LoRa
   * Zigbee

3. **平台层（云/边缘计算）**
   数据存储、分析、设备管理（例如阿里云 IoT、华为云 IoT、AWS IoT）。

4. **应用层（业务场景）**
   最终提供服务，如智能家居、工业监控、智慧农业等。

---

## 常见应用场景

* **智能家居**：智能灯、智能门锁、扫地机器人
* **智慧城市**：智能路灯、交通监控、停车管理
* **工业物联网（IIoT）**：工厂设备监测、预测性维护
* **智慧农业**：土壤湿度监测、自动灌溉
* **车联网**：自动驾驶辅助、车辆定位与诊断
* **医疗物联网**：可穿戴设备监测心率血压

---

## 物联网的关键特点

* **设备互联**
* **实时数据采集**
* **自动化控制**
* **数据驱动决策**
* **远程监控与管理**

---

## IoT 常见技术关键词

* MQTT（轻量级通信协议）
* CoAP
* 传感器网络
* Edge Computing（边缘计算）
* Digital Twin（数字孪生）
* AIoT（AI + IoT）

---


**MQTT（Message Queuing Telemetry Transport）** 是物联网里最常用的通信协议之一，特点是：**轻量、低带宽、低功耗、适合不稳定网络**（比如传感器、智能设备、4G/NB-IoT）。

---

## MQTT 的核心机制：发布/订阅（Pub/Sub）

MQTT 不像 HTTP 那样“客户端请求→服务器响应”，它是：

* **发布者（Publisher）**：发送消息
* **订阅者（Subscriber）**：接收消息
* **Broker（消息服务器）**：负责转发消息（核心）

📌 设备只需要连接 Broker，不用设备之间互连。

---

## MQTT 工作流程（简单例子）

比如温度传感器：

1. 温度传感器发布消息到主题 `home/room1/temp`
2. Broker 接收消息
3. 手机 APP 订阅 `home/room1/temp`
4. Broker 把温度数据推送给手机

---

## Topic（主题）

Topic 就像消息的“频道”。

例子：

* `factory/machine1/status`
* `home/livingroom/light`
* `car/001/gps`

支持通配符：

* `+` 匹配一层：`home/+/temp`
* `#` 匹配多层：`home/#`

---

## QoS（服务质量等级）

MQTT 支持三种消息可靠性：

* **QoS 0：最多一次**
  发送一次，不管丢不丢（最快）
* **QoS 1：至少一次**
  确保送到，但可能重复
* **QoS 2：只有一次**
  最可靠，保证不重复（最慢）

---

## MQTT 主要优点

✅ 轻量（协议开销小）
✅ 适合弱网环境
✅ 支持大量设备连接
✅ 实时性强
✅ 支持离线消息（保留消息、遗嘱消息）

---

## MQTT 常见功能

### 1. Retained Message（保留消息）

Broker 会保存最新一条消息，新订阅者一订阅就能收到最新状态。

### 2. Last Will（遗嘱消息）

设备突然断开时，Broker 自动发布预设消息，比如：
`machine1 offline`

---

## MQTT 默认端口

* **1883**：普通 TCP
* **8883**：TLS 加密

---

## MQTT 常见 Broker

* Mosquitto（最常见开源）
* EMQX（国内非常流行，企业级）
* HiveMQ
* AWS IoT Core

---

下面给你一份**基于 Spring Boot 3 + EMQX 的物联网平台项目结构**（适合共享充电宝/智能设备/工业采集），属于企业常见的“平台端”架构，重点是**清晰分层 + 可扩展 + 可微服务化**。

---

# 1）总体架构（推荐）

设备端（柜机/传感器）
→ MQTT 连接 **EMQX**
→ EMQX 转发消息（MQTT）
→ Spring Boot 3 平台订阅/发布
→ MySQL/Redis/InfluxDB
→ WebSocket 推送前端
→ 管理后台/APP

---

# 2）项目模块结构（Maven 多模块）

建议用 **父工程 + 多模块**（企业标准）。

```text
iot-platform
├── pom.xml                       (parent)
├── iot-common                    (通用工具/统一返回/异常/常量)
├── iot-mqtt                      (MQTT接入层：订阅、发布、消息路由)
├── iot-device                    (设备管理：柜机、充电宝、传感器)
├── iot-order                     (订单/计费：共享充电宝必备)
├── iot-alarm                     (告警/规则引擎：阈值、离线、故障)
├── iot-user                      (用户/权限/认证：后台管理系统)
├── iot-payment                   (支付：微信/支付宝/模拟支付)
├── iot-api                       (REST API聚合层，对外接口)
├── iot-websocket                 (实时推送：大屏/后台实时数据)
├── iot-job                       (定时任务：离线检测、补偿机制)
├── iot-admin                     (后台管理入口服务，可选)
└── iot-application               (最终启动模块 SpringBootApplication)
```

> 如果你做毕业设计/中小项目，也可以合并成单体，但这个结构最接近真实公司项目。

---

# 3）推荐包结构（每个模块内部）

以 `iot-device` 为例：

```text
iot-device
└── src/main/java/com/xxx/iot/device
    ├── controller        (REST接口)
    ├── service           (业务逻辑)
    │   ├── impl
    ├── repository        (JPA/MyBatis持久层)
    ├── entity            (数据库实体)
    ├── dto               (输入输出对象)
    ├── mapper            (MyBatis mapper 可选)
    ├── config            (模块配置)
    └── constant          (模块常量)
```

---

# 4）核心模块职责说明（关键）

## iot-mqtt（最核心）

负责：

* 连接 EMQX（mica-mqtt-client / spring integration mqtt）
* 订阅 Topic：`iot/+/telemetry` `iot/+/event` `iot/+/status`
* 统一解析 JSON
* 将消息投递到业务层（DeviceService / OrderService）
* 提供 publish API（下发命令）

**这个模块相当于“设备接入网关”。**

---

## iot-device

负责：

* 柜机/设备注册
* 设备在线离线状态维护
* 槽位信息、固件版本
* 充电宝资产管理

---

## iot-order（共享充电宝必备）

负责：

* 订单状态机（INIT/EJECTING/RENTING/FINISHED/ABNORMAL）
* 计费策略（分钟计费、封顶）
* 归还结算
* 订单异常处理

---

## iot-job

负责：

* 设备心跳超时离线检测
* 命令下发超时补偿（重试）
* 异常订单扫描（超时未归还）
* 定时生成统计报表

---

## iot-websocket

负责：

* 设备实时状态推送
* 订单实时推送
* 大屏实时数据

---

# 5）Spring Boot 3 启动模块结构（iot-application）

```text
iot-application
└── src/main/java/com/xxx/iot
    ├── IotPlatformApplication.java
    ├── config
    │   ├── WebConfig.java
    │   ├── SwaggerConfig.java
    │   ├── RedisConfig.java
    │   └── SecurityConfig.java
    └── exception
        ├── GlobalExceptionHandler.java
        └── BizException.java
```

---

# 6）EMQX Topic 规范（强烈建议统一）

假设设备 ID = dev001

```text
iot/dev001/telemetry      (数据上报：温湿度、电量等)
iot/dev001/status         (在线/离线/电量状态)
iot/dev001/event          (事件：借出、归还、故障)
iot/dev001/cmd            (平台下发命令)
iot/dev001/cmd_reply      (设备回执)
```

订阅策略：

* 平台订阅：`iot/+/telemetry`
* 平台订阅：`iot/+/event`
* 平台订阅：`iot/+/status`
* 平台订阅：`iot/+/cmd_reply`

---

# 7）MQTT 消息处理链路（企业常用设计）

建议设计统一入口：

```text
MqttListener
  -> MessageParser (解析 JSON)
      -> MessageRouter (根据 event/type 路由)
          -> DeviceService / OrderService / AlarmService
              -> Repository(DB)
              -> WebSocketPush
```

这样后续扩展“新设备类型、新消息类型”不会改一堆代码。

---

# 8）推荐目录（iot-mqtt 模块）

```text
iot-mqtt
└── src/main/java/com/xxx/iot/mqtt
    ├── config
    │   └── MqttClientConfig.java
    ├── listener
    │   ├── TelemetryListener.java
    │   ├── EventListener.java
    │   ├── StatusListener.java
    │   └── CmdReplyListener.java
    ├── publish
    │   └── MqttPublishService.java
    ├── model
    │   ├── TelemetryMsg.java
    │   ├── EventMsg.java
    │   ├── StatusMsg.java
    │   ├── CmdMsg.java
    │   └── CmdReplyMsg.java
    ├── router
    │   └── MessageRouter.java
    └── constant
        └── MqttTopics.java
```

---

# 9）配置中心（application.yml 推荐写法）

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/iot
    username: root
    password: 123456
  data:
    redis:
      host: localhost
      port: 6379

iot:
  mqtt:
    broker: tcp://127.0.0.1:1883
    username: admin
    password: public
    clientId: iot-platform-001
    qos: 1
    topic:
      telemetry: iot/+/telemetry
      event: iot/+/event
      status: iot/+/status
      cmdReply: iot/+/cmd_reply
```

---

# 10）数据库结构（最少要这些）

### device（设备表）

* device_id
* name
* status
* last_seen
* firmware_version

### device_data（最新数据表）

* device_id
* temperature
* humidity
* battery
* update_time

### device_event（事件表）

* id
* device_id
* event_type
* payload
* create_time

### cmd_log（命令日志表）

* cmd_id
* device_id
* cmd_type
* status (SENT/SUCCESS/FAIL/TIMEOUT)
* create_time

> 共享充电宝还要加 order、payment、slot、powerbank 表。

---

# 11）部署结构（真实生产推荐）

```text
设备 -> EMQX集群 -> 平台SpringBoot集群 -> MySQL主从/Redis -> 前端后台
```

平台最好不要直接依赖 MQTT 的可靠性，建议加 MQ（Kafka/RabbitMQ）：

```text
EMQX -> Kafka -> SpringBoot(order/device/alarm)
```

---

# 12）推荐技术选型（Spring Boot 3）

* Spring Boot 3.2+
* JDK 17+
* MyBatis-Plus 或 Spring Data JPA
* Redis（在线状态 + 命令回执缓存）
* WebSocket（实时推送）
* EMQX（Broker）
* Prometheus + Grafana（监控）

---

如果你需要，我可以把这份结构直接扩展成：
**可运行的 Git 项目骨架（每个模块的 pom、启动类、mqtt listener、消息路由、数据库表 SQL）**，基本就是“共享充电宝平台后端模板”。
