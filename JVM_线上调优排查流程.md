# JVM 线上调优排查流程（标准版）

## 1）先确认现象
- RT 飙升 / 卡顿
- CPU 飙高
- 内存持续上涨
- Full GC 频繁
- OOM 重启

---

## 2）先看机器资源（排除系统问题）
```bash
top
free -h
df -h
```
确认 CPU、内存、磁盘是否异常。

---

## 3）定位 Java 进程
```bash
jps -l
```

---

## 4）看 GC 是否异常（最关键第一步）
```bash
jstat -gc pid 1000
```

判断：
- **YGC 很快增长** → 新生代压力大
- **FGC 增长** → Full GC 问题
- **Old 区接近 100%** → 老年代要爆

---

## 5）如果 CPU 高：定位热点线程
```bash
top -Hp pid
```

找最高 CPU 的线程 tid，转 16 进制：
```bash
printf "%x\n" tid
```

导出线程栈：
```bash
jstack pid > stack.txt
```

在 stack.txt 搜索 `nid=0x...` 定位代码。

---

## 6）看 GC 日志（判断停顿原因）
```bash
tail -n 200 gc.log
grep "Full GC" gc.log | tail -n 20
```

重点看：
- Full GC 间隔
- pause 时间
- Full GC 后 Old 是否下降

---

## 7）怀疑内存泄漏/老年代撑爆：dump 堆
推荐：
```bash
jcmd pid GC.heap_dump /tmp/heap.hprof
```

---

## 8）MAT 分析 dump（最终定位根因）
重点看：
- Dominator Tree（谁占内存最多）
- Leak Suspects Report（疑似泄漏点）
- 对象引用链（谁持有不释放）

---

## 9）修复代码（调优的核心）
常见修复点：
- 缓存加上限（Guava/Caffeine）
- MQ 消费堆积处理
- ThreadLocal remove
- 大对象优化（byte[]、大 List）
- 线程池限制

---

## 10）再做 JVM 参数微调（最后一步）
常用调整：
- `Xms=Xmx`
- G1：`-XX:+UseG1GC`
- 设置停顿目标：`-XX:MaxGCPauseMillis=200`
- 调整堆大小（增大 Old 或 Young）

---

## 11）可视化工具（常用辅助排查）
- **JVisualVM**：看堆、线程、CPU、dump 分析（免费常用）
- **JConsole**：查看 JVM 监控指标（简单）
- **JProfiler**：商业级性能分析器（定位慢方法、内存泄漏很强）

---

# 一句话总结（记住）
**先 jstat 看 GC → 再 jstack 看线程 → 再 dump + MAT 查堆 → 最后再调参数。**
