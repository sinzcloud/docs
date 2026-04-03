# Git 分支管理流程（新项目从 master 开始）

你现在是新项目，只有一个 master 分支。最正确的做法是：马上建立 dev 分支，然后以后所有功能都用 feature 分支开发。按下面一步步来即可。

---

## 第 1 步：确认当前分支是 master

```bash
git branch
```

如果看到：

```
* master
```

说明没问题。

---

## 第 2 步：创建 dev 分支并推送到远程

在 master 上创建 dev：

```bash
git checkout -b dev
```

推送到远程：

```bash
git push -u origin dev
```

---

## 第 3 步：以后开发功能不要直接改 dev（推荐）

每次开发新模块，按这个流程：

### ① 切到 dev 并拉最新代码

```bash
git checkout dev
git pull origin dev
```

### ② 创建 feature 分支

例如开发订单模块：

```bash
git checkout -b feature/order-module
```

### ③ 开发完成后提交

```bash
git add .
git commit -m "feat: add order module"
```

### ④ 推送 feature 分支到远程

```bash
git push -u origin feature/order-module
```

---

## 第 4 步：合并 feature 到 dev

开发完成后：

```bash
git checkout dev
git pull origin dev
git merge feature/order-module
git push origin dev
```

---

## 第 5 步：删除 feature 分支（保持仓库干净）

删除本地：

```bash
git branch -d feature/order-module
```

删除远程：

```bash
git push origin --delete feature/order-module
```

---

## 第 6 步：发布版本（dev 合并到 master）

当 dev 稳定后发布：

```bash
git checkout master
git pull origin master
git merge dev
git push origin master
```

打 tag：

```bash
git tag v0.1.0
git push origin v0.1.0
```

---

## 推荐分支规划

- master：稳定可发布版本（用于展示/发布）
- dev：日常开发集成分支
- feature/xxx：功能分支（每个模块一个）

示例：

- feature/user-module
- feature/product-module
- feature/order-module
- feature/inventory-module
- feature/payment-module
- feature/shipping-module
- feature/report-module
