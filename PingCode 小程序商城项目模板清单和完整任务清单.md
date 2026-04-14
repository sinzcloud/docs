这里是一套**PingCode 小程序商城项目模板清单**（企业常用的标准做法），你照着建就能直接跑项目。

---

# 1. 项目初始化配置（必做）

## 1.1 项目类型

选择：**敏捷 Scrum 项目**

迭代周期建议：**2 周 / Sprint**

---

## 1.2 角色权限（团队常用）

* 产品经理（PM）：需求管理、迭代规划、查看报表
* 开发（后端/前端/小程序）：任务、缺陷处理、代码关联
* 测试（QA）：缺陷、用例、测试计划
* 运维/DevOps：发布记录、环境管理文档
* 项目负责人/Tech Lead：全权限

---

## 1.3 工作流（推荐状态）

### 需求状态（Story）

* 草稿
* 评审中
* 已确认（可进入迭代）
* 开发中
* 测试中
* 已验收
* 已上线

### 任务状态（Task）

* 待处理（Todo）
* 开发中（Doing）
* 开发自测（Self-Test）
* 提测（Ready for QA）
* 测试中（Testing）
* 已完成（Done）

### Bug 状态

* 新建
* 已确认
* 修复中
* 待验证
* 已关闭
* 拒绝 / 延期

---

# 2. 字段设计（强烈建议加）

给 Story/Task/Bug 加字段，后期统计非常爽：

## 通用字段

* 优先级：P0 / P1 / P2 / P3
* 模块：用户/商品/订单/支付/营销/后台
* 端：小程序端 / 后端 / 管理后台
* 版本：v1.0 / v1.1 / v1.2
* 需求来源：老板/运营/用户反馈/市场
* 预计工时、实际工时

## Bug 专用字段

* 严重程度：致命/严重/一般/建议
* 复现概率：必现/偶现
* 发现环境：测试/预发/生产

---

# 3. 史诗 Epic 模板（直接照抄）

在 PingCode 产品模块里建立这些 Epic：

1. 用户与认证（登录、授权、地址）
2. 商品中心（分类、搜索、详情）
3. 购物车系统
4. 订单系统
5. 支付系统（微信支付）
6. 物流与售后（发货、退款）
7. 营销中心（优惠券、活动）
8. 运营后台（商品、订单管理）
9. 消息通知（订阅消息）
10. 数据统计（订单、用户、GMV）
11. 系统基础（配置、日志、权限、部署）

---

# 4. v1.0 MVP 需求拆分模板（Story 列表）

下面是商城项目 v1.0 最常见需求列表（建议都建成 Story）。

---

## Epic：用户与认证

* Story：微信一键登录
* Story：用户信息完善（昵称、头像）
* Story：收货地址管理（增删改查）
* Story：用户个人中心

---

## Epic：商品中心

* Story：商品分类页
* Story：商品列表页
* Story：商品详情页
* Story：商品搜索
* Story：商品规格 SKU 选择

---

## Epic：购物车系统

* Story：加入购物车
* Story：购物车列表
* Story：购物车数量修改
* Story：购物车商品删除

---

## Epic：订单系统

* Story：确认订单页（地址+商品+优惠）
* Story：提交订单（创建订单）
* Story：订单列表
* Story：订单详情
* Story：取消订单（未支付）
* Story：订单超时自动取消

---

## Epic：支付系统

* Story：微信支付下单
* Story：支付回调处理（成功/失败）
* Story：支付结果页

---

## Epic：运营后台（最简）

* Story：后台登录（账号密码）
* Story：商品管理（上架/下架/库存修改）
* Story：订单管理（发货、查看）

---

## Epic：系统基础

* Story：日志与异常统一处理
* Story：接口鉴权 JWT
* Story：Swagger 接口文档
* Story：部署上线（Docker）

---

# 5. 每条 Story 的模板（建议复制粘贴）

在 PingCode 里每条 Story 建议包含：

### 标题

【订单】提交订单

### 描述

用户从购物车/立即购买进入确认页后提交订单。

### 验收标准（重点）

* 必须登录才能提交
* 必须选择收货地址
* 订单金额计算正确（商品金额+运费-优惠）
* 库存不足时提示
* 创建订单后状态为“待支付”
* 返回支付参数

### 关联模块

订单系统

### 优先级

P0

---

# 6. Task 拆分模板（研发任务颗粒度）

以【订单】提交订单 Story 为例拆 Task（建议 1-2 天可完成）：

## 后端任务

* Task：订单表结构设计
* Task：订单创建接口开发
* Task：订单金额计算逻辑
* Task：库存扣减/锁定逻辑
* Task：订单状态机实现
* Task：单元测试 + 接口测试

## 小程序端任务

* Task：确认订单页面 UI
* Task：地址选择组件
* Task：订单提交接口对接
* Task：支付页面跳转

## 测试任务

* Task：提交订单测试用例编写
* Task：异常场景测试（库存不足/地址为空）
* Task：回归测试

---

# 7. Sprint 计划模板（建议这样排）

## Sprint 1（基础框架 + 登录 + 商品）

* 用户微信登录
* 商品分类/列表/详情
* 基础架构（RBAC/JWT/异常处理）
* 数据库初始化

交付目标：能浏览商品 + 登录

---

## Sprint 2（购物车 + 下单）

* 购物车功能全套
* 确认订单页
* 提交订单（待支付）

交付目标：能生成订单

---

## Sprint 3（支付 + 订单管理）

* 微信支付
* 支付回调
* 订单列表/详情
* 取消订单、超时取消

交付目标：能完整支付闭环

---

## Sprint 4（后台管理 + 发货）

* 后台登录
* 商品管理
* 订单管理发货
* 物流信息录入

交付目标：运营能发货

---

## Sprint 5（上线准备）

* 订阅消息通知
* 性能优化
* 压测
* 安全检查
* 上线部署脚本

交付目标：上线

---

# 8. Bug 管理模板（QA 提交规范）

Bug 标题建议：
【订单】支付回调重复导致订单状态异常

Bug 内容必须包含：

* 复现步骤
* 期望结果 vs 实际结果
* 截图/视频
* 日志信息（如果有）
* 影响范围（用户是否可下单）
* 严重程度（致命/严重/一般）

---

# 9. 文档库目录结构（企业最常用）

PingCode 知识库建议建这些目录：

* 01_需求文档（PRD、原型）
* 02_接口文档（Swagger地址、示例请求）
* 03_数据库设计（ER图、表结构）
* 04_架构设计（DDD/模块划分）
* 05_部署运维（Docker、Nginx、CI/CD）
* 06_发布记录（版本号、变更清单）
* 07_问题沉淀（线上事故复盘）

---

# 10. 最重要的三张报表（项目负责人必看）

在 PingCode 里重点盯：

* **燃尽图**（Sprint 是否延期）
* **缺陷趋势**（质量是否变差）
* **任务累计流图**（瓶颈在开发还是测试）

---

# 11. 你照着做的最终效果（一个标准闭环）

最终你会得到：

* 需求（Story）有验收标准
* 需求拆任务（Task）可执行
* 任务进入 Sprint 看板流转
* 测试提 Bug 回到任务修复
* Sprint 结束发布版本
* 文档沉淀可追溯

这就是企业常用的研发管理闭环。

---


下面是**小程序商城 v1.0（MVP）完整任务清单**，可以直接放到 PingCode/Jira 里当项目计划用。内容包含：

* 模块划分
* 数据库表结构（核心表）
* 接口列表（按模块）
* Sprint 规划（2周一个 Sprint）
* 工作量估算（人日）

> 说明：估算以「熟练团队」为基准：后端 1 人、小程序端 1 人、管理后台 1 人、测试 1 人（可兼职）。

---

# 一、v1.0 模块划分（MVP）

## C端小程序（用户端）

1. 登录与用户中心
2. 商品中心（分类/列表/详情/搜索）
3. 购物车
4. 订单（下单/支付/查询/取消）
5. 地址管理

## B端管理后台（运营端 Web）

1. 登录
2. 商品管理（上架/库存/价格）
3. 订单管理（发货/状态修改）

## 后端服务（Spring Boot 3）

1. 用户与认证模块（JWT）
2. 商品模块
3. 订单模块
4. 支付模块（微信支付）
5. 后台 RBAC 权限模块
6. 基础模块（文件上传、配置、日志）

---

# 二、数据库表结构（v1.0 必要表）

> 这里是最小可用表设计（后续 v1.1 扩展优惠券、退款、物流跟踪等）。

---

## 1）用户表 user

| 字段         | 类型           | 说明       |
| ---------- | ------------ | -------- |
| id         | bigint PK    | 用户ID     |
| openid     | varchar(64)  | 微信openid |
| nickname   | varchar(50)  | 昵称       |
| avatar     | varchar(255) | 头像       |
| phone      | varchar(20)  | 手机号（可选）  |
| status     | tinyint      | 1正常 0禁用  |
| created_at | datetime     | 创建时间     |

---

## 2）地址表 user_address

| 字段         | 类型           | 说明   |
| ---------- | ------------ | ---- |
| id         | bigint PK    | 地址ID |
| user_id    | bigint       | 用户ID |
| name       | varchar(50)  | 收货人  |
| phone      | varchar(20)  | 手机   |
| province   | varchar(50)  | 省    |
| city       | varchar(50)  | 市    |
| district   | varchar(50)  | 区    |
| detail     | varchar(255) | 详细地址 |
| is_default | tinyint      | 是否默认 |
| created_at | datetime     | 创建时间 |

---

## 3）商品表 product

| 字段          | 类型            | 说明      |
| ----------- | ------------- | ------- |
| id          | bigint PK     | 商品ID    |
| category_id | bigint        | 分类ID    |
| title       | varchar(200)  | 商品标题    |
| cover       | varchar(255)  | 主图      |
| price       | decimal(10,2) | 售价      |
| stock       | int           | 库存      |
| status      | tinyint       | 1上架 0下架 |
| created_at  | datetime      | 创建时间    |

---

## 4）分类表 product_category

| 字段     | 类型          | 说明   |
| ------ | ----------- | ---- |
| id     | bigint PK   | 分类ID |
| name   | varchar(50) | 分类名  |
| sort   | int         | 排序   |
| status | tinyint     | 是否启用 |

---

## 5）购物车表 cart_item

| 字段         | 类型        | 说明   |
| ---------- | --------- | ---- |
| id         | bigint PK | 主键   |
| user_id    | bigint    | 用户ID |
| product_id | bigint    | 商品ID |
| quantity   | int       | 数量   |
| created_at | datetime  | 创建时间 |

---

## 6）订单表 order

| 字段               | 类型                 | 说明      |
| ---------------- | ------------------ | ------- |
| id               | bigint PK          | 订单ID    |
| order_no         | varchar(50) unique | 订单号     |
| user_id          | bigint             | 用户ID    |
| total_amount     | decimal(10,2)      | 总金额     |
| pay_amount       | decimal(10,2)      | 实付金额    |
| status           | tinyint            | 状态      |
| address_snapshot | json/text          | 下单时地址快照 |
| created_at       | datetime           | 创建时间    |
| paid_at          | datetime           | 支付时间    |
| cancel_at        | datetime           | 取消时间    |

订单状态建议：

* 0待支付
* 1已支付
* 2已取消
* 3已发货
* 4已完成

---

## 7）订单项 order_item

| 字段         | 类型            | 说明     |
| ---------- | ------------- | ------ |
| id         | bigint PK     | 主键     |
| order_id   | bigint        | 订单ID   |
| product_id | bigint        | 商品ID   |
| title      | varchar(200)  | 商品标题快照 |
| price      | decimal(10,2) | 单价快照   |
| quantity   | int           | 数量     |

---

## 8）支付表 payment

| 字段           | 类型            | 说明     |
| ------------ | ------------- | ------ |
| id           | bigint PK     | 主键     |
| order_id     | bigint        | 订单ID   |
| order_no     | varchar(50)   | 订单号    |
| pay_no       | varchar(100)  | 微信支付单号 |
| pay_status   | tinyint       | 支付状态   |
| pay_amount   | decimal(10,2) | 支付金额   |
| callback_raw | text          | 回调原文   |
| created_at   | datetime      | 创建时间   |

---

## 9）后台 RBAC（admin_user/admin_role/admin_permission）

最简版：

* admin_user
* admin_role
* admin_permission
* admin_user_role
* admin_role_permission

---

# 三、接口列表（按模块）

---

## A. 小程序端认证 Auth API

| 方法   | URL               | 说明         |
| ---- | ----------------- | ---------- |
| POST | /api/auth/wxLogin | 微信登录换token |
| GET  | /api/auth/me      | 获取当前用户信息   |

---

## B. 用户地址 Address API

| 方法     | URL                       |
| ------ | ------------------------- |
| GET    | /api/address/list         |
| POST   | /api/address/add          |
| PUT    | /api/address/update       |
| DELETE | /api/address/delete/{id}  |
| POST   | /api/address/default/{id} |

---

## C. 商品 Product API

| 方法  | URL                                          |
| --- | -------------------------------------------- |
| GET | /api/category/list                           |
| GET | /api/product/list?categoryId=&keyword=&page= |
| GET | /api/product/detail/{id}                     |

---

## D. 购物车 Cart API

| 方法     | URL                   |
| ------ | --------------------- |
| GET    | /api/cart/list        |
| POST   | /api/cart/add         |
| PUT    | /api/cart/updateQty   |
| DELETE | /api/cart/delete/{id} |
| POST   | /api/cart/clear       |

---

## E. 订单 Order API

| 方法   | URL                    |         |
| ---- | ---------------------- | ------- |
| POST | /api/order/confirm     | 订单确认页数据 |
| POST | /api/order/create      | 创建订单    |
| GET  | /api/order/list        |         |
| GET  | /api/order/detail/{id} |         |
| POST | /api/order/cancel/{id} |         |

---

## F. 支付 Payment API

| 方法   | URL                       |        |
| ---- | ------------------------- | ------ |
| POST | /api/pay/wx/prepay        | 生成预支付单 |
| POST | /api/pay/wx/notify        | 微信支付回调 |
| GET  | /api/pay/status/{orderNo} | 查询支付状态 |

---

## G. 管理后台 Admin API

### 登录

| 方法   | URL              |
| ---- | ---------------- |
| POST | /api/admin/login |

### 商品管理

| 方法   | URL                             |
| ---- | ------------------------------- |
| GET  | /api/admin/product/list         |
| POST | /api/admin/product/add          |
| PUT  | /api/admin/product/update       |
| POST | /api/admin/product/onSale/{id}  |
| POST | /api/admin/product/offSale/{id} |

### 订单管理

| 方法   | URL                           |
| ---- | ----------------------------- |
| GET  | /api/admin/order/list         |
| GET  | /api/admin/order/detail/{id}  |
| POST | /api/admin/order/deliver/{id} |

---

# 四、Sprint 规划（v1.0 版本，2周/迭代）

下面给你一套非常标准的拆法（可直接建 Sprint）。

---

# Sprint 1（基础架构 + 登录 + 商品浏览）

目标：用户能登录并浏览商品

### 后端任务（约 10 人日）

* 搭建 Spring Boot 3 项目骨架（1d）
* MySQL + JPA/MyBatis 初始化（1d）
* JWT 登录鉴权框架（2d）
* 微信登录接口（openid换token）（2d）
* 商品分类接口（1d）
* 商品列表/详情接口（2d）
* Swagger + 全局异常处理（1d）

### 小程序端任务（约 8 人日）

* 项目初始化、路由、网络封装（1d）
* 登录流程（微信授权+token存储）（2d）
* 首页分类+商品列表（2d）
* 商品详情页（2d）
* UI统一样式/组件封装（1d）

### 测试任务（约 4 人日）

* 测试用例模板（1d）
* 登录+商品浏览测试（2d）
* bug回归（1d）

**Sprint 1 合计：22 人日**

---

# Sprint 2（购物车 + 地址管理）

目标：用户能加入购物车，维护地址

### 后端任务（约 9 人日）

* 地址 CRUD 接口（2d）
* 默认地址逻辑（1d）
* 购物车 CRUD 接口（3d）
* 商品库存校验接口（1d）
* 购物车/地址联调支持（2d）

### 小程序端任务（约 9 人日）

* 地址列表/新增/编辑页面（3d）
* 购物车页面（2d）
* 加入购物车按钮逻辑（1d）
* 数量增减/删除/勾选（2d）
* UI联调修复（1d）

### 测试任务（约 4 人日）

* 地址功能测试（2d）
* 购物车测试（2d）

**Sprint 2 合计：22 人日**

---

# Sprint 3（订单系统：确认单 + 下单 + 查询）

目标：可以生成订单并查看订单详情

### 后端任务（约 12 人日）

* 订单表+订单项表设计（1d）
* 订单号生成规则（1d）
* 确认订单接口（计算金额、地址、购物车商品）（2d）
* 创建订单接口（库存扣减/锁定）（3d）
* 订单列表接口（1d）
* 订单详情接口（1d）
* 取消订单接口（2d）
* 超时取消任务（定时任务）（1d）

### 小程序端任务（约 10 人日）

* 确认订单页面（3d）
* 下单流程联调（2d）
* 订单列表页面（2d）
* 订单详情页面（2d）
* 取消订单操作（1d）

### 测试任务（约 5 人日）

* 下单流程测试（2d）
* 异常场景测试（库存不足/地址为空）（2d）
* 回归（1d）

**Sprint 3 合计：27 人日**

---

# Sprint 4（微信支付 + 后台运营端）

目标：完成支付闭环，运营可管理商品/订单

### 后端任务（约 12 人日）

* 微信支付 V3 接入（prepay）（3d）
* 支付回调 notify 处理（幂等）（3d）
* 支付状态查询接口（1d）
* 支付成功订单状态变更（1d）
* 管理员登录（RBAC）（2d）
* 后台商品 CRUD（1d）
* 后台订单列表/详情（1d）

### 管理后台任务（约 10 人日）

（如果你用 Vue/React）

* 后台登录页（1d）
* 商品列表/新增/编辑（4d）
* 上下架、库存修改（2d）
* 订单列表/详情（2d）
* 发货操作（1d）

### 小程序端任务（约 5 人日）

* 支付按钮联调（2d）
* 支付结果页（1d）
* 已支付订单展示（1d）
* UI/交互优化（1d）

### 测试任务（约 6 人日）

* 支付流程测试（沙箱）（3d）
* 后台功能测试（2d）
* 回归（1d）

**Sprint 4 合计：33 人日**

---

# Sprint 5（上线准备：稳定性、部署、验收）

目标：上线可用，功能稳定

### 后端任务（约 8 人日）

* Docker 化部署（2d）
* Nginx 配置（1d）
* 日志、链路追踪、监控（2d）
* 性能优化（SQL/索引）（2d）
* 安全检查（接口权限、参数校验）（1d）

### 小程序端任务（约 6 人日）

* 全流程体验优化（2d）
* 异常提示与容错（2d）
* 上线版本配置（环境切换）（2d）

### 管理后台任务（约 4 人日）

* UI优化（1d）
* 权限校验补齐（1d）
* 运营使用说明文档（2d）

### 测试任务（约 8 人日）

* 全链路回归测试（4d）
* 压测验证（2d）
* 验收支持（2d）

**Sprint 5 合计：26 人日**

---

# 五、总体工作量评估（v1.0）

| Sprint   | 人日         |
| -------- | ---------- |
| Sprint 1 | 22         |
| Sprint 2 | 22         |
| Sprint 3 | 27         |
| Sprint 4 | 33         |
| Sprint 5 | 26         |
| **总计**   | **130 人日** |

### 转换成周期（常见团队）

如果团队配置是：

* 后端 2 人
* 小程序端 1 人
* 后台前端 1 人
* 测试 1 人

总产能约：**5 人 * 10 工作日 = 50 人日 / Sprint**

130 人日 ≈ **3 个 Sprint（6 周）+ 缓冲**
实际落地一般：**2~3 个月上线 v1.0**（含需求变更/返工）。

---

# 六、PingCode 录入方式（建议格式）

在 PingCode 里推荐这样组织：

* Epic：订单系统

  * Story：确认订单页

    * Task：确认订单接口开发（后端）
    * Task：确认订单页面开发（小程序端）
    * Task：确认订单测试用例（QA）
  * Story：提交订单
  * Story：取消订单
  * Story：订单超时取消

这样你可以直接看到每个 Epic 的完成度。

---

# 七、v1.0 关键风险点（必须提前排雷）

1. **微信支付回调幂等**（必须做，不然会重复扣库存）
2. **库存扣减策略**（下单扣？支付扣？）
3. **订单状态机**（状态乱会导致售后灾难）
4. **后台权限**（运营误操作风险）
5. **上线部署与配置**（小程序审核周期要考虑）
