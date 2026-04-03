# GitHub Workflow（企业级协作规范）

适用于个人项目、团队项目、开源项目的 GitHub 开发协作流程。

---

## 1. 分支规范（Branch Strategy）

### 1.1 分支角色

#### master（主分支 / 发布分支）
- 永远保持可运行、可发布
- 只能通过 PR 合并进入
- 不允许直接 push（建议开启保护规则）

用途：发布版本、线上部署、展示项目成果。

#### dev（开发分支）
- 日常开发集成分支
- feature 分支完成后合并到 dev
- dev 稳定后合并到 master

用途：团队协作开发主线。

#### feature/xxx（功能分支）
- 每个功能独立分支
- 功能完成后合并到 dev
- 合并后删除分支

命名示例：
- feature/user-module
- feature/order-module
- feature/payment-callback

#### hotfix/xxx（紧急修复分支）
- 用于修复 master 上的线上紧急 bug
- 修复完成后合并回 master，并同步到 dev

命名示例：
- hotfix/login-401
- hotfix/payment-idempotent

---

## 2. Commit Message 规范

推荐 Conventional Commits：

- feat: 新增功能
- fix: 修复 bug
- docs: 文档更新
- refactor: 重构
- perf: 性能优化
- test: 测试相关
- chore: 配置/依赖/构建脚本

示例：
```bash
git commit -m "feat: add order create api"
git commit -m "fix: resolve inventory oversell issue"
git commit -m "docs: update README"
```

---

## 3. 开发流程（Feature Flow）

### 3.1 创建 dev 分支（新项目必做）
如果项目只有 master：

```bash
git checkout master
git pull origin master
git checkout -b dev
git push -u origin dev
```

---

### 3.2 开发新功能（feature -> dev）

#### Step 1：切换到 dev 并拉取最新代码
```bash
git checkout dev
git pull origin dev
```

#### Step 2：创建 feature 分支
```bash
git checkout -b feature/order-module
```

#### Step 3：开发并提交
```bash
git add .
git commit -m "feat: add order module"
```

#### Step 4：推送 feature 分支
```bash
git push -u origin feature/order-module
```

#### Step 5：提交 Pull Request（feature -> dev）
在 GitHub 上创建 PR：
- base：dev
- compare：feature/order-module

PR 描述建议写：
- 改了什么
- 影响范围
- 是否有数据库变更
- 测试方式

#### Step 6：Code Review（代码审查）
至少 1 人 Review 后才能合并（个人项目可自己 Review）。

#### Step 7：合并 PR 到 dev
建议使用：
- Squash and merge（保持 dev 历史干净）

#### Step 8：删除 feature 分支
合并后删除远程 feature 分支。

---

## 4. 发布流程（dev -> master）

当 dev 分支功能稳定后发布：

### Step 1：合并 dev 到 master
```bash
git checkout master
git pull origin master
git merge dev
git push origin master
```

### Step 2：打 tag
```bash
git tag v0.1.0
git push origin v0.1.0
```

### Step 3：发布 GitHub Release
在 GitHub Release 页面填写：
- 版本号 v0.1.0
- 更新内容
- Breaking Changes（如有）

---

## 5. Hotfix 流程（紧急修复线上）

### Step 1：从 master 拉 hotfix 分支
```bash
git checkout master
git pull origin master
git checkout -b hotfix/payment-callback
```

### Step 2：修复并提交
```bash
git add .
git commit -m "fix: payment callback idempotent"
git push origin hotfix/payment-callback
```

### Step 3：提交 PR（hotfix -> master）
PR 合并到 master。

### Step 4：同步 master 到 dev
```bash
git checkout dev
git pull origin dev
git merge master
git push origin dev
```

---

## 6. Pull Request 规范（PR Template 建议）

PR 必须包含以下信息：

- 修改内容概述
- 是否涉及数据库变更
- 测试方式
- 关联 Issue

推荐格式：

```text
## 修改内容
新增订单模块接口，支持订单创建与查询

## 数据库变更
新增 order、order_item 表

## 测试方式
curl /api/orders

## 关联 Issue
#12
```

---

## 7. Code Review Checklist（审查清单）

### 7.1 后端检查项
- Controller 是否过重（业务逻辑应放 Service）
- 是否有参数校验
- 是否有统一异常处理
- 是否有事务边界（@Transactional）
- SQL 是否有索引
- 是否可能出现 N+1 查询
- 是否有幂等设计（支付回调、下单）
- 是否有日志记录（关键流程）
- 是否影响旧接口兼容性

### 7.2 前端检查项
- API 请求是否统一封装
- 是否处理 loading、异常提示
- 表单校验是否完整
- 是否存在重复代码
- 是否有权限控制（路由守卫）

---

## 8. GitHub Actions CI（持续集成）

建议开启 CI，PR 合并前自动执行：

- mvn test
- mvn package
- npm install && npm run build（如果包含前端）

CI 未通过禁止合并。

---

## 9. Branch Protection（分支保护规则）

建议对 master 开启保护：

- 禁止直接 push
- 必须 PR 合并
- 必须 CI 通过才能合并
- 必须至少 1 人 Review
- 禁止 force push

对 dev 建议开启：
- 必须 CI 通过才能合并

---

## 10. Issue 管理规范

建议所有开发任务先创建 Issue：

Issue 内容建议包含：
- 需求背景
- 功能描述
- 验收标准（Acceptance Criteria）
- 影响模块

示例：

```text
需求：订单模块增加分页查询接口

验收标准：
1. 支持按订单状态筛选
2. 支持按创建时间范围筛选
3. 返回订单总金额、订单明细数量
```

---

## 11. Release 与版本号规范

使用语义化版本号（SemVer）：

MAJOR.MINOR.PATCH

- MAJOR：重大变更（不兼容）
- MINOR：新增功能（兼容）
- PATCH：修复 bug

示例：
- v0.1.0 初始化框架
- v0.2.0 用户模块
- v0.3.0 商品模块
- v0.4.0 订单模块
- v0.4.1 修复库存 bug

---

## 12. 推荐目录（企业项目标准）

仓库根目录建议包含：

- README.md
- LICENSE
- CHANGELOG.md
- CONTRIBUTING.md
- docs/
- .github/workflows/
- .github/ISSUE_TEMPLATE/
- .github/PULL_REQUEST_TEMPLATE.md

---

## 13. 最佳实践总结（最重要）

- master 永远保持可运行
- dev 用于持续集成开发
- feature 分支用于开发功能
- hotfix 分支用于修线上问题
- 所有合并走 PR + Review
- 必须打 tag + Release
- 必须有 CI 自动化检查

---

## 14. 常用命令速查（Cheat Sheet）

```bash
# 拉取最新代码
git pull

# 创建 feature 分支
git checkout -b feature/xxx

# 提交
git add .
git commit -m "feat: xxx"
git push -u origin feature/xxx

# 合并 feature 到 dev
git checkout dev
git merge feature/xxx
git push origin dev

# 发布版本
git checkout master
git merge dev
git push origin master
git tag v1.0.0
git push origin v1.0.0

# 紧急修复
git checkout -b hotfix/xxx
```

---
