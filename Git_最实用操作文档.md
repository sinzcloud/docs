# Git 最实用操作文档（工程师必备）

> 目标：会用 Git 开发项目、提交代码、管理分支、解决冲突、提交 PR。

---

## 1. Git 基础概念（必须懂）

- **工作区（Working Directory）**：你正在编辑的代码  
- **暂存区（Stage / Index）**：准备提交的文件  
- **本地仓库（Local Repo）**：你本地的 Git 版本库  
- **远程仓库（Remote Repo）**：GitHub/Gitee 上的仓库  
- **commit**：一次版本记录  
- **branch**：分支（不同开发线）  
- **merge/rebase**：合并代码  

---

## 2. 初始化与克隆项目

### 2.1 初始化本地仓库
```bash
git init
```

### 2.2 克隆远程仓库
```bash
git clone https://github.com/xxx/xxx.git
```

---

## 3. 最常用的提交流程（每天都用）

### 标准流程（强烈推荐记住）
```bash
git status
git add .
git commit -m "feat: add order module"
git push
```

### 查看当前状态
```bash
git status
```

### 添加文件到暂存区
```bash
git add 文件名
git add .
```

### 提交到本地仓库
```bash
git commit -m "fix: resolve login bug"
```

### 推送到远程仓库
```bash
git push origin main
```

---

## 4. 查看日志和历史

### 查看提交历史
```bash
git log
```

### 简洁日志（推荐）
```bash
git log --oneline
```

### 查看某个文件修改历史
```bash
git log 文件名
```

---

## 5. 分支操作（核心）

### 5.1 查看分支
```bash
git branch
git branch -a
```

### 5.2 创建分支
```bash
git checkout -b feature/order
```

### 5.3 切换分支
```bash
git checkout dev
```

### 5.4 删除分支
```bash
git branch -d feature/order
```

强制删除：
```bash
git branch -D feature/order
```

---

## 6. 拉取更新（避免冲突必做）

### 拉取远程最新代码（推荐）
```bash
git pull
```

更安全：
```bash
git pull --rebase
```

### 拉取但不合并（只更新远程信息）
```bash
git fetch
```

---

## 7. 合并分支（merge）

把 `feature/order` 合并到 `dev`：

```bash
git checkout dev
git pull
git merge feature/order
git push origin dev
```

---

## 8. rebase（保持提交历史干净）

把 feature 分支更新到最新 dev：

```bash
git checkout feature/order
git pull --rebase origin dev
```

> 如果你不熟悉 rebase，团队协作建议少用，避免搞乱历史。

---

## 9. 解决冲突（最常见问题）

冲突提示示例：

```text
CONFLICT (content): Merge conflict in xxx.java
```

处理步骤：

1. 打开冲突文件，找到：
```text
<<<<<<< HEAD
你的代码
=======
别人的代码
>>>>>>> branch
```

2. 手动修改保留正确代码  
3. 重新 add + commit  

```bash
git add .
git commit -m "fix: resolve conflict"
git push
```

---

## 10. 撤销操作（救命必学）

### 10.1 撤销工作区修改（未 add）
```bash
git restore 文件名
```

### 10.2 撤销 add（回到未暂存）
```bash
git reset HEAD 文件名
```

### 10.3 撤销最近一次 commit（保留代码）
```bash
git reset --soft HEAD~1
```

### 10.4 撤销最近一次 commit（丢弃代码，慎用）
```bash
git reset --hard HEAD~1
```

---

## 11. 回滚代码（线上紧急修复常用）

更安全的回滚方式（推荐）：
```bash
git revert commitId
git push
```

---

## 12. stash（临时保存代码）

保存现场：
```bash
git stash
```

查看 stash：
```bash
git stash list
```

恢复 stash：
```bash
git stash pop
```

---

## 13. tag（打版本）

创建 tag：
```bash
git tag v1.0.0
```

推送 tag：
```bash
git push origin v1.0.0
```

推送所有 tag：
```bash
git push origin --tags
```

---

## 14. GitHub 项目最佳实践（强烈推荐）

推荐分支策略：
- `main`：稳定可发布版本
- `dev`：日常开发分支
- `feature/xxx`：功能分支
- `hotfix/xxx`：线上修复

---

## 15. Commit Message 规范（建议照着用）

常用：
- `feat:` 新功能
- `fix:` 修 bug
- `docs:` 文档
- `refactor:` 重构
- `test:` 测试
- `chore:` 杂项

示例：
```bash
git commit -m "feat: add payment callback api"
git commit -m "fix: solve order status bug"
```

---

## 16. 最常用场景总结（直接照做）

### 场景1：开发新功能
```bash
git checkout dev
git pull
git checkout -b feature/order
# 写代码
git add .
git commit -m "feat: add order create api"
git push origin feature/order
```

### 场景2：合并到 dev
```bash
git checkout dev
git pull
git merge feature/order
git push origin dev
```

### 场景3：上线发布（dev -> main）
```bash
git checkout main
git pull
git merge dev
git push origin main
git tag v1.0.0
git push origin v1.0.0
```

### 场景4：写一半要切换分支
```bash
git stash
git checkout dev
git pull
git checkout feature/order
git stash pop
```

---

## 17. 常见错误处理

push 被拒绝（远程有更新）：
```bash
git pull --rebase
git push
```

commit 写错了（修改 commit message）：
```bash
git commit --amend -m "feat: correct message"
git push -f
```

---

## 18. 必须记住的 10 个命令（最重要）

```bash
git status
git add .
git commit -m "xxx"
git push
git pull
git checkout -b feature/xxx
git merge xxx
git log --oneline
git stash pop
git revert commitId
```
