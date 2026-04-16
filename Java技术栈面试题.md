# Java技术栈面试题大全（含详细答案）

> 以下为100道Java技术栈面试题的完整答案，涵盖基础、框架、数据库、中间件、架构等。

---

## 一、Java基础（30题）

### 1. HashMap的put流程？扩容机制？为什么线程不安全？

**答案：**

**put流程：**
```
1. 计算key的hash值：hash(key) = (key.hashCode()) ^ (key.hashCode() >>> 16)
2. 计算数组索引：(n - 1) & hash
3. 如果数组为空，调用resize()初始化
4. 如果该位置为空，直接插入
5. 如果该位置不为空，判断key是否相同，相同则覆盖
6. 如果是树节点，执行红黑树插入
7. 否则遍历链表，找到相同key则覆盖，否则尾插法插入
8. 插入后判断链表长度是否超过8，超过则转为红黑树
9. 判断元素个数是否超过阈值，超过则扩容
```

**扩容机制：**
- 当元素个数 > 容量 × 负载因子（默认0.75）时触发
- 容量翻倍（左移一位）
- 重新计算每个元素在新数组的位置
- JDK7：头插法，多线程可能死循环
- JDK8：尾插法，多线程可能数据覆盖

**线程不安全原因：**
- JDK7：多线程扩容时，链表头插法导致环形链表，造成死循环
- JDK8：多线程put时，两个线程同时判断位置为空，后一个覆盖前一个，造成数据丢失

```java
// 演示HashMap线程不安全
public class HashMapDemo {
    public static void main(String[] args) throws InterruptedException {
        Map<Integer, String> map = new HashMap<>();
        
        Runnable task = () -> {
            for (int i = 0; i < 1000; i++) {
                map.put(i, Thread.currentThread().getName());
            }
        };
        
        Thread t1 = new Thread(task);
        Thread t2 = new Thread(task);
        t1.start();
        t2.start();
        t1.join();
        t2.join();
        
        // 期望1000，实际可能小于1000（数据覆盖）
        System.out.println("size: " + map.size());
    }
}
```

---

### 2. ConcurrentHashMap的线程安全实现？JDK7和8的区别？

**答案：**

**JDK7实现：**
- 采用分段锁（Segment）机制
- 将数据分成多个Segment，每个Segment独立加锁（继承ReentrantLock）
- 理论上支持最大并发度为Segment数量（默认16）
- 不同Segment的操作可以并发执行

**JDK8实现：**
- 采用CAS + synchronized实现并发控制
- 取消分段锁，直接对数组节点加锁
- put时：数组位置为空则CAS插入，不为空则synchronized锁住链表/红黑树头节点
- 锁粒度更细，并发性能更好

**区别对比：**

| 维度 | JDK7 | JDK8 |
|------|------|------|
| 锁机制 | 分段锁（ReentrantLock） | CAS + synchronized |
| 数据结构 | Segment数组 + HashEntry数组 + 链表 | Node数组 + 链表 + 红黑树 |
| 扩容 | 每个Segment独立扩容 | 支持并发扩容 |
| 并发度 | 固定Segment数量（默认16） | 数组长度 |

```java
// ConcurrentHashMap示例
public class ConcurrentHashMapDemo {
    public static void main(String[] args) {
        ConcurrentHashMap<String, String> map = new ConcurrentHashMap<>();
        
        // putIfAbsent：不存在才插入，原子操作
        map.putIfAbsent("key", "value");
        
        // computeIfAbsent：不存在时计算，避免重复计算
        map.computeIfAbsent("key", k -> expensiveOperation(k));
        
        // 遍历时不会抛出ConcurrentModificationException
        map.forEach((k, v) -> System.out.println(k + "=" + v));
    }
    
    private static String expensiveOperation(String key) {
        return "computed value for " + key;
    }
}
```

---

### 3. 线程池的核心参数？任务提交后的执行流程？

**答案：**

**核心参数：**
```java
public ThreadPoolExecutor(
    int corePoolSize,      // 核心线程数
    int maximumPoolSize,   // 最大线程数
    long keepAliveTime,    // 空闲线程存活时间
    TimeUnit unit,         // 时间单位
    BlockingQueue<Runnable> workQueue,  // 任务队列
    ThreadFactory threadFactory,        // 线程工厂
    RejectedExecutionHandler handler    // 拒绝策略
)
```

**任务执行流程：**
```
1. 核心线程数未满 → 创建核心线程执行
2. 核心线程已满 → 任务加入阻塞队列
3. 队列已满 → 创建非核心线程执行
4. 线程数已达最大值 → 执行拒绝策略
```

**拒绝策略：**
- `AbortPolicy`：直接抛异常（默认）
- `CallerRunsPolicy`：调用者线程执行
- `DiscardPolicy`：直接丢弃
- `DiscardOldestPolicy`：丢弃队列头部任务，重试提交

```java
// 自定义线程池示例
public class ThreadPoolDemo {
    public static void main(String[] args) {
        ThreadPoolExecutor executor = new ThreadPoolExecutor(
            2,                          // 核心线程数
            5,                          // 最大线程数
            60L, TimeUnit.SECONDS,      // 空闲存活时间
            new LinkedBlockingQueue<>(10), // 有界队列
            new NamedThreadFactory("my-pool"), // 自定义线程工厂
            new ThreadPoolExecutor.CallerRunsPolicy() // 调用者执行
        );
        
        // 监控线程池状态
        ScheduledExecutorService monitor = Executors.newSingleThreadScheduledExecutor();
        monitor.scheduleAtFixedRate(() -> {
            System.out.println("活跃线程数: " + executor.getActiveCount());
            System.out.println("队列大小: " + executor.getQueue().size());
            System.out.println("完成任务数: " + executor.getCompletedTaskCount());
        }, 1, 5, TimeUnit.SECONDS);
        
        // 提交任务
        for (int i = 0; i < 20; i++) {
            final int taskId = i;
            executor.execute(() -> {
                System.out.println(Thread.currentThread().getName() + " 执行任务 " + taskId);
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            });
        }
        
        executor.shutdown();
    }
    
    static class NamedThreadFactory implements ThreadFactory {
        private final String namePrefix;
        private final AtomicInteger threadNumber = new AtomicInteger(1);
        
        NamedThreadFactory(String namePrefix) {
            this.namePrefix = namePrefix;
        }
        
        @Override
        public Thread newThread(Runnable r) {
            Thread t = new Thread(r, namePrefix + "-" + threadNumber.getAndIncrement());
            t.setDaemon(false);
            return t;
        }
    }
}
```

---

### 4. volatile关键字的作用？可见性和有序性如何保证？

**答案：**

**volatile的两个作用：**
1. **保证可见性**：对一个volatile变量的写，总是立即刷新到主内存；对一个volatile变量的读，总是从主内存读取最新值
2. **禁止指令重排序**：在volatile变量前后插入内存屏障，防止编译器或CPU重排序

**内存屏障：**
- 写volatile：StoreStore屏障 + StoreLoad屏障
- 读volatile：LoadLoad屏障 + LoadStore屏障

```java
public class VolatileDemo {
    // 使用volatile保证可见性
    private volatile boolean running = true;
    
    public void testVisibility() {
        new Thread(() -> {
            while (running) {
                // 循环，当running被修改为false时退出
            }
            System.out.println("线程退出");
        }).start();
        
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {}
        
        running = false; // 修改对另一个线程可见
    }
    
    // 双重检查锁单例（volatile防止指令重排序）
    private static volatile VolatileDemo instance;
    
    public static VolatileDemo getInstance() {
        if (instance == null) {           // 第一次检查
            synchronized (VolatileDemo.class) {
                if (instance == null) {   // 第二次检查
                    instance = new VolatileDemo();
                    // 正常new对象分三步：
                    // 1. 分配内存
                    // 2. 初始化对象
                    // 3. 将引用指向内存
                    // volatile防止2和3重排序，避免其他线程看到未初始化的对象
                }
            }
        }
        return instance;
    }
}
```

---

### 5. synchronized的锁升级过程？

**答案：**

**锁升级方向：** 无锁 → 偏向锁 → 轻量级锁 → 重量级锁

| 锁状态 | 适用场景 | 原理 | 开销 |
|--------|----------|------|------|
| 偏向锁 | 单线程重复获取 | 在对象头记录线程ID | 最小 |
| 轻量级锁 | 少量线程竞争 | CAS自旋获取锁 | 中等 |
| 重量级锁 | 大量线程竞争 | 操作系统互斥量，线程阻塞 | 最大 |

**升级过程：**
1. 对象刚创建时，处于无锁状态
2. 当第一个线程访问时，升级为偏向锁，记录线程ID
3. 当另一个线程尝试获取锁时，偏向锁升级为轻量级锁（CAS自旋）
4. 自旋次数超过阈值（默认10次）或自旋线程数超过CPU核心数一半，升级为重量级锁

```java
// 锁升级演示
public class SynchronizedDemo {
    
    // 偏向锁：单线程反复调用
    public synchronized void biasedLock() {
        // 第一次加锁时，偏向锁会偏向当前线程
        // 后续同一线程再次加锁，无需CAS
    }
    
    // 轻量级锁：少量线程竞争
    public void lightweightLock() {
        Object lock = new Object();
        // 多个线程短时间竞争，CAS自旋尝试获取
        synchronized (lock) {
            // 执行时间短，自旋等待
        }
    }
    
    // 重量级锁：大量线程长时间竞争
    public void heavyweightLock() {
        Object lock = new Object();
        // 多线程长时间执行，升级为重量级锁
        synchronized (lock) {
            try {
                Thread.sleep(1000); // 长时间持有
            } catch (InterruptedException e) {}
        }
    }
}
```

---

### 6. ReentrantLock和synchronized的区别？

**答案：**

| 对比维度 | synchronized | ReentrantLock |
|----------|--------------|----------------|
| 底层实现 | JVM内置关键字 | Java API类 |
| 锁获取方式 | 自动 | 手动lock/unlock |
| 可中断性 | 不可中断 | 可中断（lockInterruptibly） |
| 超时获取 | 不支持 | 支持（tryLock） |
| 公平锁 | 非公平 | 可选公平/非公平 |
| 条件变量 | 单一wait/notify | 多个Condition |
| 性能 | JDK6优化后相近 | 相近 |

```java
public class LockDemo {
    
    // synchronized方式
    public synchronized void syncMethod() {
        // 自动获取和释放锁
    }
    
    // ReentrantLock方式
    private final ReentrantLock lock = new ReentrantLock(true); // 公平锁
    
    public void lockMethod() {
        lock.lock();
        try {
            // 业务代码
        } finally {
            lock.unlock(); // 必须在finally中释放
        }
    }
    
    // 可中断获取锁
    public void interruptibleLock() throws InterruptedException {
        lock.lockInterruptibly();
        try {
            // 可以被中断
        } finally {
            lock.unlock();
        }
    }
    
    // 尝试获取锁（超时）
    public boolean tryLockMethod() throws InterruptedException {
        if (lock.tryLock(1, TimeUnit.SECONDS)) {
            try {
                return true;
            } finally {
                lock.unlock();
            }
        }
        return false;
    }
    
    // 多个Condition
    private final ReentrantLock conditionLock = new ReentrantLock();
    private final Condition notEmpty = conditionLock.newCondition();
    private final Condition notFull = conditionLock.newCondition();
    
    public void conditionDemo() throws InterruptedException {
        conditionLock.lock();
        try {
            while (isEmpty()) {
                notEmpty.await(); // 等待
            }
            // 消费
            notFull.signal(); // 唤醒
        } finally {
            conditionLock.unlock();
        }
    }
    
    private boolean isEmpty() { return false; }
}
```

---

### 7. AQS的原理？如何实现自定义锁？

**答案：**

**AQS核心结构：**
1. **state状态变量**（volatile int）：表示资源状态，0表示未占用
2. **同步队列**（双向CLH队列）：存放等待获取锁的线程
3. **条件队列**：存放await的线程

**核心方法：**
- `acquire(int arg)`：获取锁的模板方法
- `release(int arg)`：释放锁的模板方法
- `tryAcquire(int arg)`：子类实现，尝试获取锁
- `tryRelease(int arg)`：子类实现，尝试释放锁

```java
// 自定义互斥锁
public class MutexLock implements Lock {
    
    // 同步器实现
    private static class Sync extends AbstractQueuedSynchronizer {
        
        @Override
        protected boolean tryAcquire(int arg) {
            // CAS设置state从0->1，成功则获取锁
            if (compareAndSetState(0, 1)) {
                setExclusiveOwnerThread(Thread.currentThread());
                return true;
            }
            return false;
        }
        
        @Override
        protected boolean tryRelease(int arg) {
            if (getState() == 0) {
                throw new IllegalMonitorStateException();
            }
            setExclusiveOwnerThread(null);
            setState(0);
            return true;
        }
        
        @Override
        protected boolean isHeldExclusively() {
            return getState() == 1;
        }
        
        Condition newCondition() {
            return new ConditionObject();
        }
    }
    
    private final Sync sync = new Sync();
    
    @Override
    public void lock() {
        sync.acquire(1);
    }
    
    @Override
    public void lockInterruptibly() throws InterruptedException {
        sync.acquireInterruptibly(1);
    }
    
    @Override
    public boolean tryLock() {
        return sync.tryAcquire(1);
    }
    
    @Override
    public boolean tryLock(long time, TimeUnit unit) throws InterruptedException {
        return sync.tryAcquireNanos(1, unit.toNanos(time));
    }
    
    @Override
    public void unlock() {
        sync.release(1);
    }
    
    @Override
    public Condition newCondition() {
        return sync.newCondition();
    }
    
    // 使用示例
    public static void main(String[] args) {
        MutexLock lock = new MutexLock();
        
        Runnable task = () -> {
            lock.lock();
            try {
                System.out.println(Thread.currentThread().getName() + " 获取到锁");
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            } finally {
                lock.unlock();
                System.out.println(Thread.currentThread().getName() + " 释放锁");
            }
        };
        
        for (int i = 0; i < 3; i++) {
            new Thread(task).start();
        }
    }
}
```

---

### 8. ThreadLocal的原理？内存泄漏问题如何解决？

**答案：**

**原理：**
- 每个Thread内部维护一个ThreadLocalMap
- ThreadLocalMap的key是ThreadLocal对象的弱引用
- value是存储的值

```java
// ThreadLocal简化原理
public class ThreadLocal<T> {
    public void set(T value) {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null) {
            map.set(this, value);
        }
    }
    
    public T get() {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null) {
            return (T) map.get(this);
        }
        return null;
    }
}
```

**内存泄漏问题：**
- Key是弱引用，GC时会被回收，变为null
- Value是强引用，永远不会被回收，导致内存泄漏

**解决方案：**
```java
public class ThreadLocalDemo {
    
    // 正确使用ThreadLocal
    public static void main(String[] args) {
        // 方式1：使用try-finally手动remove
        ThreadLocal<String> threadLocal = new ThreadLocal<>();
        try {
            threadLocal.set("value");
            // 业务逻辑
        } finally {
            threadLocal.remove(); // 关键！使用完后必须remove
        }
        
        // 方式2：使用线程池时尤其要注意
        ExecutorService executor = Executors.newFixedThreadPool(10);
        for (int i = 0; i < 100; i++) {
            executor.execute(() -> {
                ThreadLocal<String> tl = new ThreadLocal<>();
                try {
                    tl.set("data");
                    // 业务处理
                } finally {
                    tl.remove(); // 线程池中的线程必须remove
                }
            });
        }
        
        // 方式3：使用InheritableThreadLocal传递父线程数据
        InheritableThreadLocal<String> inheritable = new InheritableThreadLocal<>();
        inheritable.set("parent data");
        
        new Thread(() -> {
            System.out.println("子线程获取: " + inheritable.get()); // 可以获取
        }).start();
    }
}
```

---

### 9. JVM内存模型（JDK8）？各区域的作用？

**答案：**

**JVM内存结构（JDK8）：**

| 区域 | 作用 | 线程共享 | 异常 |
|------|------|----------|------|
| **堆** | 存储对象实例、数组 | 是 | OutOfMemoryError |
| **元空间** | 存储类信息、常量、静态变量 | 是 | OutOfMemoryError |
| **虚拟机栈** | 存储局部变量、操作数栈、方法出口 | 否 | StackOverflowError |
| **本地方法栈** | Native方法执行 | 否 | StackOverflowError |
| **程序计数器** | 记录当前线程执行的字节码行号 | 否 | 无 |

**JDK7到JDK8的变化：**
- 永久代（PermGen）被移除
- 元空间（Metaspace）取代永久代
- 元空间使用本地内存，不在虚拟机内存中

```java
public class JVMMemoryDemo {
    
    // 堆内存溢出
    public static void heapOOM() {
        List<byte[]> list = new ArrayList<>();
        while (true) {
            list.add(new byte[1024 * 1024]); // 1MB
        }
        // 参数：-Xms10m -Xmx10m
    }
    
    // 栈内存溢出
    public static void stackOOM() {
        stackOverflow(0);
    }
    
    private static void stackOverflow(int depth) {
        System.out.println(depth);
        stackOverflow(depth + 1);
        // 参数：-Xss128k
    }
    
    // 元空间溢出（动态生成类）
    public static void metaspaceOOM() {
        while (true) {
            Enhancer enhancer = new Enhancer();
            enhancer.setSuperclass(Object.class);
            enhancer.setUseCache(false);
            enhancer.setCallback((MethodInterceptor) (obj, method, args, proxy) -> 
                proxy.invokeSuper(obj, args));
            enhancer.create();
        }
        // 参数：-XX:MaxMetaspaceSize=50m
    }
}
```

---

### 10. 如何排查OOM？给出具体步骤？

**答案：**

**排查步骤：**

```bash
# 1. 查看Java进程ID
jps -l

# 2. 查看堆内存使用情况
jmap -heap <pid>

# 3. 查看GC情况
jstat -gcutil <pid> 1000 10

# 4. 导出堆转储文件
jmap -dump:format=b,file=heap.hprof <pid>

# 5. 查看线程堆栈
jstack <pid> > thread.txt

# 6. 使用MAT/JProfiler分析heap.hprof
```

**代码示例：**
```java
public class OOMDiagnoseDemo {
    
    // 模拟内存泄漏
    public static class MemoryLeakDemo {
        private static List<byte[]> cache = new ArrayList<>();
        
        public static void addToCache(byte[] data) {
            cache.add(data); // 永远不清理
        }
    }
    
    // 排查代码
    public static void diagnose() {
        // 1. 添加JVM参数
        // -XX:+HeapDumpOnOutOfMemoryError
        // -XX:HeapDumpPath=/tmp/heap.hprof
        // -XX:+PrintGCDetails
        // -XX:+PrintGCDateStamps
        // -Xloggc:/tmp/gc.log
        
        // 2. 使用VisualVM远程监控
        // 3. 使用Arthas在线诊断
        // 4. 使用MAT分析堆转储
    }
    
    // 常见OOM原因及解决方案
    public static void commonCauses() {
        // 1. 内存泄漏：ThreadLocal未remove
        // 解决：finally中调用remove()
        
        // 2. 大对象：一次性查询太多数据
        // 解决：分页查询、流式处理
        
        // 3. 连接未关闭：数据库连接、文件流
        // 解决：try-with-resources
        
        // 4. 死循环创建对象
        // 解决：代码审查
        
        // 5. 元空间溢出：动态类生成过多
        // 解决：增加元空间大小、缓存类
    }
}
```

---

### 11. 类加载机制？双亲委派模型？

**答案：**

**类加载器层次：**
```
Bootstrap ClassLoader（启动类加载器）
    ↑
Extension ClassLoader（扩展类加载器）
    ↑
Application ClassLoader（应用类加载器）
    ↑
Custom ClassLoader（自定义类加载器）
```

**双亲委派流程：**
1. 检查类是否已加载
2. 若未加载，委派给父加载器加载
3. 父加载器无法加载时，自己尝试加载

```java
public class ClassLoaderDemo {
    
    public static void main(String[] args) {
        // 查看类加载器
        System.out.println(String.class.getClassLoader());      // null（Bootstrap）
        System.out.println(ClassLoaderDemo.class.getClassLoader()); // AppClassLoader
        
        // 双亲委派演示
        ClassLoader appLoader = ClassLoader.getSystemClassLoader();
        ClassLoader extLoader = appLoader.getParent();
        ClassLoader bootLoader = extLoader.getParent();
        
        System.out.println("AppClassLoader: " + appLoader);
        System.out.println("ExtClassLoader: " + extLoader);
        System.out.println("BootstrapClassLoader: " + bootLoader); // null
    }
    
    // 自定义类加载器（打破双亲委派）
    static class BreakParentClassLoader extends ClassLoader {
        @Override
        protected Class<?> loadClass(String name, boolean resolve) 
                throws ClassNotFoundException {
            // 先自己加载，再委派给父类
            synchronized (getClassLoadingLock(name)) {
                Class<?> c = findLoadedClass(name);
                if (c == null) {
                    try {
                        c = findClass(name);
                    } catch (ClassNotFoundException e) {
                        c = super.loadClass(name, resolve);
                    }
                }
                return c;
            }
        }
    }
    
    // 打破双亲委派的场景
    // 1. Tomcat：每个Web应用独立类加载器
    // 2. JDBC：ServiceLoader机制
    // 3. OSGi：模块化热部署
}
```

---

### 12. CompletableFuture的异步编排如何使用？

**答案：**

```java
public class CompletableFutureDemo {
    
    public static void main(String[] args) throws Exception {
        
        // 1. 创建异步任务
        CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
            return "Hello";
        });
        
        // 2. 串行转换
        CompletableFuture<String> thenApply = future
            .thenApply(s -> s + " World")
            .thenApply(String::toUpperCase);
        System.out.println(thenApply.get()); // HELLO WORLD
        
        // 3. 消费结果（无返回值）
        future.thenAccept(System.out::println);
        
        // 4. 组合两个独立任务
        CompletableFuture<Integer> future1 = CompletableFuture.supplyAsync(() -> 10);
        CompletableFuture<Integer> future2 = CompletableFuture.supplyAsync(() -> 20);
        
        CompletableFuture<Integer> combined = future1.thenCombine(future2, (a, b) -> a + b);
        System.out.println(combined.get()); // 30
        
        // 5. 任意一个完成
        CompletableFuture<Object> anyOf = CompletableFuture.anyOf(future1, future2);
        System.out.println(anyOf.get());
        
        // 6. 所有都完成
        CompletableFuture<Void> allOf = CompletableFuture.allOf(future1, future2);
        allOf.get(); // 等待所有完成
        
        // 7. 异常处理
        CompletableFuture<Integer> errorFuture = CompletableFuture.supplyAsync(() -> {
            if (true) throw new RuntimeException("出错了");
            return 100;
        }).exceptionally(ex -> {
            System.out.println("异常: " + ex.getMessage());
            return 0; // 默认值
        });
        
        // 8. 带超时（JDK9+）
        CompletableFuture<String> timeoutFuture = CompletableFuture
            .supplyAsync(() -> {
                try { Thread.sleep(3000); } catch (Exception e) {}
                return "result";
            })
            .orTimeout(1, TimeUnit.SECONDS)
            .exceptionally(ex -> "timeout");
        
        // 9. 自定义线程池
        ExecutorService executor = Executors.newFixedThreadPool(10);
        CompletableFuture.supplyAsync(() -> "task", executor);
        executor.shutdown();
    }
    
    // 实际业务场景：支付处理
    public static void paymentScenario() {
        CompletableFuture<PaymentResult> payment = 
            CompletableFuture.supplyAsync(() -> doPay(100.0));
        
        CompletableFuture<Void> updateOrder = 
            payment.thenAcceptAsync(result -> updateOrder(result));
        
        CompletableFuture<Void> sendNotify = 
            payment.thenAcceptAsync(result -> sendNotification(result));
        
        CompletableFuture<Void> allTasks = 
            CompletableFuture.allOf(updateOrder, sendNotify);
        
        try {
            allTasks.get(5, TimeUnit.SECONDS);
            System.out.println("支付处理完成");
        } catch (TimeoutException e) {
            System.out.println("处理超时");
        } catch (Exception e) {
            System.out.println("处理失败");
        }
    }
    
    static class PaymentResult {
        String orderId;
        PaymentResult(String orderId) { this.orderId = orderId; }
    }
    
    static PaymentResult doPay(double amount) {
        return new PaymentResult("ORDER_123");
    }
    
    static void updateOrder(PaymentResult result) {}
    static void sendNotification(PaymentResult result) {}
}
```

---

## 二、Spring全家桶（20题）

### 13. Spring Bean的生命周期？

**答案：**

**完整生命周期流程：**
```
1. 实例化（Instantiation）：通过反射创建Bean实例
2. 属性赋值（Populate）：填充属性（依赖注入）
3. 设置BeanName：调用BeanNameAware.setBeanName()
4. 设置BeanFactory：调用BeanFactoryAware.setBeanFactory()
5. 设置ApplicationContext：调用ApplicationContextAware.setApplicationContext()
6. BeanPostProcessor前置处理：postProcessBeforeInitialization()
7. 初始化：执行@PostConstruct、InitializingBean.afterPropertiesSet()、init-method
8. BeanPostProcessor后置处理：postProcessAfterInitialization()（AOP在此生成代理）
9. 使用：Bean就绪
10. 销毁：执行@PreDestroy、DisposableBean.destroy()、destroy-method
```

```java
public class BeanLifecycleDemo {
    
    @Component
    public static class LifecycleBean implements BeanNameAware, BeanFactoryAware, 
            ApplicationContextAware, InitializingBean, DisposableBean {
        
        private String name;
        
        public LifecycleBean() {
            System.out.println("1. 实例化");
        }
        
        public void setName(String name) {
            this.name = name;
            System.out.println("2. 属性赋值");
        }
        
        @Override
        public void setBeanName(String name) {
            System.out.println("3. BeanNameAware: " + name);
        }
        
        @Override
        public void setBeanFactory(BeanFactory beanFactory) {
            System.out.println("4. BeanFactoryAware");
        }
        
        @Override
        public void setApplicationContext(ApplicationContext context) {
            System.out.println("5. ApplicationContextAware");
        }
        
        @PostConstruct
        public void postConstruct() {
            System.out.println("6. @PostConstruct");
        }
        
        @Override
        public void afterPropertiesSet() {
            System.out.println("7. InitializingBean");
        }
        
        @Bean(initMethod = "customInit")
        public void customInit() {
            System.out.println("8. init-method");
        }
        
        @PreDestroy
        public void preDestroy() {
            System.out.println("9. @PreDestroy");
        }
        
        @Override
        public void destroy() {
            System.out.println("10. DisposableBean");
        }
    }
    
    @Component
    public static class MyBeanPostProcessor implements BeanPostProcessor {
        @Override
        public Object postProcessBeforeInitialization(Object bean, String beanName) {
            System.out.println("BeanPostProcessor.before: " + beanName);
            return bean;
        }
        
        @Override
        public Object postProcessAfterInitialization(Object bean, String beanName) {
            System.out.println("BeanPostProcessor.after: " + beanName);
            return bean;
        }
    }
}
```

---

### 14. 循环依赖如何解决？为什么需要三级缓存？

**答案：**

**三级缓存结构：**
```java
// 一级缓存：完全初始化好的Bean
private final Map<String, Object> singletonObjects = new ConcurrentHashMap<>();

// 二级缓存：早期暴露的Bean（未完成属性赋值）
private final Map<String, Object> earlySingletonObjects = new ConcurrentHashMap<>();

// 三级缓存：Bean工厂（用于生成代理对象）
private final Map<String, ObjectFactory<?>> singletonFactories = new ConcurrentHashMap<>();
```

**解决流程（A依赖B）：**
```
1. 实例化A，将A的工厂放入三级缓存
2. 填充A属性时发现需要B
3. 实例化B，将B的工厂放入三级缓存
4. 填充B属性时发现需要A
5. 从三级缓存获取A的工厂，生成A的早期引用放入二级缓存
6. B完成初始化，放入一级缓存
7. A继续完成初始化
```

```java
// 模拟三级缓存解决循环依赖
public class CircularDependencyDemo {
    
    static class MyApplicationContext {
        // 三级缓存
        private Map<Class<?>, Object> singletonObjects = new ConcurrentHashMap<>();
        private Map<Class<?>, Object> earlySingletonObjects = new ConcurrentHashMap<>();
        private Map<Class<?>, ObjectFactory<?>> singletonFactories = new ConcurrentHashMap<>();
        private Set<Class<?>> singletonsCurrentlyInCreation = ConcurrentHashMap.newKeySet();
        
        public <T> T getBean(Class<T> beanClass) {
            // 1. 从一级缓存获取
            if (singletonObjects.containsKey(beanClass)) {
                return (T) singletonObjects.get(beanClass);
            }
            
            // 2. 循环依赖检测
            if (singletonsCurrentlyInCreation.contains(beanClass)) {
                // 从二级缓存获取
                if (earlySingletonObjects.containsKey(beanClass)) {
                    return (T) earlySingletonObjects.get(beanClass);
                }
                // 从三级缓存获取工厂
                ObjectFactory<?> factory = singletonFactories.get(beanClass);
                if (factory != null) {
                    Object earlyBean = factory.getObject();
                    earlySingletonObjects.put(beanClass, earlyBean);
                    return (T) earlyBean;
                }
            }
            
            return doCreateBean(beanClass);
        }
        
        private <T> T doCreateBean(Class<T> beanClass) {
            singletonsCurrentlyInCreation.add(beanClass);
            try {
                T bean = beanClass.getDeclaredConstructor().newInstance();
                // 放入三级缓存
                singletonFactories.put(beanClass, () -> bean);
                // 填充属性
                populateBean(bean);
                // 放入一级缓存
                singletonObjects.put(beanClass, bean);
                return bean;
            } catch (Exception e) {
                throw new RuntimeException(e);
            } finally {
                singletonsCurrentlyInCreation.remove(beanClass);
            }
        }
    }
}
```

---

### 15. Spring Boot自动配置原理？

**答案：**

**核心注解：**
```java
@SpringBootApplication = @Configuration + @EnableAutoConfiguration + @ComponentScan
```

**自动配置流程：**
1. `@EnableAutoConfiguration` 导入 `AutoConfigurationImportSelector`
2. 读取 `META-INF/spring.factories` 文件
3. 获取所有 `@EnableAutoConfiguration` 配置类
4. 通过 `@Conditional` 条件注解过滤
5. 符合条件的配置类被加载，创建对应的Bean

```java
// 自定义Starter示例
@Configuration
@ConditionalOnClass(RedisTemplate.class)
@EnableConfigurationProperties(RedisProperties.class)
public class MyRedisAutoConfiguration {
    
    @Bean
    @ConditionalOnMissingBean
    @ConditionalOnProperty(prefix = "my.redis", name = "enabled", havingValue = "true")
    public RedisTemplate<String, Object> redisTemplate(RedisProperties properties) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(properties.getConnectionFactory());
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new Jackson2JsonRedisSerializer<>(Object.class));
        return template;
    }
}

// 配置文件 spring.factories
// org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
// com.example.MyRedisAutoConfiguration

// 配置文件 application.yml
// my:
//   redis:
//     enabled: true
//     host: localhost
//     port: 6379
```

---

### 16. @Transactional失效的场景？

**答案：**

**失效场景：**

| 场景 | 原因 | 解决方案 |
|------|------|----------|
| 非public方法 | 代理只能拦截public | 改为public |
| 内部调用 | 代理不拦截内部调用 | 注入自身或使用AopContext |
| 异常类型错误 | 默认只回滚RuntimeException | 指定rollbackFor |
| 异常被catch | 事务拦截器收不到异常 | 抛出异常 |
| 传播行为 | 使用NOT_SUPPORTED等 | 检查传播行为 |
| 数据库引擎 | MyISAM不支持事务 | 使用InnoDB |

```java
@Service
public class TransactionalDemo {
    
    @Autowired
    private TransactionalDemo self;
    
    // ✅ 正确：public方法
    @Transactional
    public void correctMethod() {
        // 事务生效
    }
    
    // ❌ 失效：非public方法
    @Transactional
    private void privateMethod() {
        // 事务不生效
    }
    
    // ❌ 失效：内部调用
    public void outerMethod() {
        innerMethod(); // 事务不生效
    }
    
    @Transactional
    public void innerMethod() {
        // 不会被代理拦截
    }
    
    // ✅ 正确：内部调用解决方案
    public void outerMethodFixed() {
        self.innerMethod(); // 通过代理调用，事务生效
    }
    
    // ❌ 失效：异常被catch
    @Transactional
    public void exceptionCatched() {
        try {
            // 数据库操作
        } catch (Exception e) {
            // 吞掉了异常，事务不会回滚
        }
    }
    
    // ✅ 正确：手动回滚
    @Transactional
    public void manualRollback() {
        try {
            // 数据库操作
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus()
                .setRollbackOnly();
        }
    }
    
    // ❌ 失效：默认只回滚RuntimeException
    @Transactional
    public void checkedException() throws Exception {
        throw new Exception(); // 不回滚
    }
    
    // ✅ 正确：指定回滚异常
    @Transactional(rollbackFor = Exception.class)
    public void checkedExceptionFixed() throws Exception {
        throw new Exception(); // 会回滚
    }
}
```

---

## 三、数据库（15题）

### 17. 索引失效的场景有哪些？

**答案：**

**索引失效10个场景：**

```sql
-- 1. 对索引列使用函数
SELECT * FROM orders WHERE DATE(create_time) = '2024-01-01';
-- 解决：改为范围查询
SELECT * FROM orders WHERE create_time >= '2024-01-01' AND create_time < '2024-01-02';

-- 2. 隐式类型转换
SELECT * FROM orders WHERE phone = 13800138000;  -- phone是varchar
-- 解决：使用字符串
SELECT * FROM orders WHERE phone = '13800138000';

-- 3. LIKE以%开头
SELECT * FROM orders WHERE order_no LIKE '%123';

-- 4. OR条件中有非索引列
SELECT * FROM orders WHERE id = 1 OR status = 2;  -- status无索引
-- 解决：使用UNION ALL
SELECT * FROM orders WHERE id = 1
UNION ALL
SELECT * FROM orders WHERE status = 2;

-- 5. 复合索引不满足最左前缀
-- 索引(user_id, status, create_time)
SELECT * FROM orders WHERE status = 1 AND create_time > '2024-01-01';  -- 索引失效

-- 6. 使用!=或<>
SELECT * FROM orders WHERE status != 1;

-- 7. IS NOT NULL
SELECT * FROM orders WHERE phone IS NOT NULL;

-- 8. NOT IN
SELECT * FROM orders WHERE id NOT IN (1,2,3);

-- 9. 范围查询后列无法使用索引
-- 索引(user_id, status, create_time)
SELECT * FROM orders WHERE user_id = 1 AND status > 1 AND create_time > '2024-01-01';
-- status用了范围，create_time用不到

-- 10. 数据分布不均
SELECT * FROM orders WHERE status = 0;  -- 90%都是status=0，全表扫描更快
```

---

### 18. 如何分析慢SQL？Explain各字段含义？

**答案：**

**Explain分析步骤：**
```sql
-- 1. 开启慢查询日志
SET GLOBAL slow_query_log = ON;
SET GLOBAL long_query_time = 1;

-- 2. 使用Explain分析
EXPLAIN SELECT * FROM orders WHERE user_id = 100;
```

**关键字段含义：**

| 字段 | 含义 | 优化目标 |
|------|------|----------|
| type | 连接类型 | 达到ref或range |
| possible_keys | 可能使用的索引 | - |
| key | 实际使用的索引 | 不为NULL |
| key_len | 使用的索引长度 | 尽量长 |
| rows | 扫描的行数 | 越小越好 |
| Extra | 额外信息 | 避免Using filesort |

**type优先级（好→差）：**
```
system > const > eq_ref > ref > range > index > ALL
```

**Extra常见值：**
| Extra | 含义 | 优化 |
|-------|------|------|
| Using index | 覆盖索引 | ✅ 好 |
| Using index condition | 索引下推 | ✅ 好 |
| Using where | 需要回表 | 可接受 |
| Using filesort | 文件排序 | ❌ 需优化 |
| Using temporary | 临时表 | ❌ 需优化 |

```java
// 慢SQL优化示例
@Service
public class SqlOptimizeDemo {
    
    // ❌ 慢查询
    public List<Order> slowQuery() {
        return orderMapper.selectList(
            new LambdaQueryWrapper<Order>()
                .eq(Order::getStatus, 1)
                .like(Order::getOrderNo, "%123")  // 前模糊，索引失效
                .orderByDesc(Order::getCreateTime) // 无索引，Using filesort
        );
    }
    
    // ✅ 优化后
    public List<Order> optimizedQuery() {
        return orderMapper.selectList(
            new LambdaQueryWrapper<Order>()
                .eq(Order::getStatus, 1)
                .ge(Order::getCreateTime, LocalDate.now())  // 范围查询
                .orderByDesc(Order::getCreateTime)  // 有索引，Using index
        );
    }
}
```

---

### 19. 缓存穿透、雪崩、击穿的解决方案？

**答案：**

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| **穿透** | 查询不存在的数据 | 布隆过滤器、缓存空值 |
| **雪崩** | 大量缓存同时失效 | 随机TTL、永不过期、集群 |
| **击穿** | 热点key失效 | 互斥锁、逻辑过期 |

```java
@Service
public class CacheService {
    
    @Autowired
    private RedissonClient redissonClient;
    @Autowired
    private ProductMapper productMapper;
    
    // 1. 解决穿透：布隆过滤器 + 空值缓存
    private RBloomFilter<Long> bloomFilter;
    
    @PostConstruct
    public void initBloomFilter() {
        bloomFilter = redissonClient.getBloomFilter("product-bloom");
        bloomFilter.tryInit(1000000, 0.01);
        // 预热：将所有存在的ID加入布隆过滤器
        productMapper.selectAllIds().forEach(bloomFilter::add);
    }
    
    public Product getProductWithBloomFilter(Long id) {
        if (!bloomFilter.contains(id)) {
            return null; // 一定不存在
        }
        
        RBucket<Product> bucket = redissonClient.getBucket("product:" + id);
        Product product = bucket.get();
        if (product == null) {
            // 缓存空值（短TTL）
            bucket.set(null, 5, TimeUnit.MINUTES);
            return null;
        }
        return product;
    }
    
    // 2. 解决雪崩：随机TTL
    public void setWithRandomTTL(String key, Object value) {
        int baseTTL = 1800; // 30分钟
        int randomTTL = new Random().nextInt(600); // 0-10分钟
        RBucket<Object> bucket = redissonClient.getBucket(key);
        bucket.set(value, baseTTL + randomTTL, TimeUnit.SECONDS);
    }
    
    // 3. 解决击穿：互斥锁
    public Product getProductWithMutex(Long id) {
        String cacheKey = "product:" + id;
        RBucket<Product> bucket = redissonClient.getBucket(cacheKey);
        
        Product product = bucket.get();
        if (product != null) {
            return product;
        }
        
        RLock lock = redissonClient.getLock("lock:product:" + id);
        try {
            if (lock.tryLock(3, 10, TimeUnit.SECONDS)) {
                try {
                    // 双重检查
                    product = bucket.get();
                    if (product != null) {
                        return product;
                    }
                    
                    product = productMapper.selectById(id);
                    if (product != null) {
                        setWithRandomTTL(cacheKey, product);
                    }
                    return product;
                } finally {
                    lock.unlock();
                }
            } else {
                Thread.sleep(100);
                return getProductWithMutex(id);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return null;
        }
    }
}
```

---

## 四、消息队列（10题）

### 20. 如何保证消息不丢失？

**答案：**

**三个阶段保证：**

| 阶段 | 问题 | 解决方案 |
|------|------|----------|
| 生产者→MQ | 发送失败 | 同步确认、异步回调、重试 |
| MQ存储 | 宕机丢失 | 持久化刷盘、主从同步 |
| MQ→消费者 | 消费失败 | 手动ACK、重试+死信队列 |

```java
@Service
public class MessageReliabilityService {
    
    @Autowired
    private RocketMQTemplate rocketMQTemplate;
    @Autowired
    private FailedMessageMapper failedMessageMapper;
    
    // 1. 生产者：同步发送 + 重试
    public SendResult sendWithReliability(String topic, Object message) {
        SendResult result = rocketMQTemplate.syncSend(topic, message);
        if (result.getSendStatus() != SendStatus.SEND_OK) {
            // 保存失败消息，定时重试
            saveFailedMessage(topic, message);
            throw new RuntimeException("消息发送失败");
        }
        return result;
    }
    
    // 2. 事务消息
    public void sendTransactionMessage(String topic, Object message, Object arg) {
        rocketMQTemplate.sendMessageInTransaction(topic, message, arg);
    }
    
    // 3. 消费者：手动ACK + 重试
    @RocketMQMessageListener(
        topic = "order-topic",
        consumerGroup = "order-group",
        // 手动ACK
        ackMode = AckMode.MANUAL_IMMEDIATELY
    )
    public static class OrderConsumer implements RocketMQListener<OrderMessage> {
        
        @Override
        public void onMessage(OrderMessage message) {
            try {
                // 业务处理
                processOrder(message);
                // 手动ACK
                // channel.basicAck(deliveryTag, false);
            } catch (Exception e) {
                // 消费失败，记录日志
                log.error("消费失败", e);
                // 重新入队或进入死信队列
                // channel.basicNack(deliveryTag, false, true);
            }
        }
    }
    
    // 4. 定时重试失败消息
    @Scheduled(cron = "0 */5 * * * ?")
    public void retryFailedMessages() {
        List<FailedMessage> messages = failedMessageMapper.selectRetryList();
        for (FailedMessage msg : messages) {
            try {
                rocketMQTemplate.syncSend(msg.getTopic(), msg.getMessage());
                failedMessageMapper.updateStatus(msg.getId(), "SUCCESS");
            } catch (Exception e) {
                failedMessageMapper.incrementRetryCount(msg.getId());
            }
        }
    }
}
```

---

## 五、分布式与微服务（10题）

### 21. 分布式事务的解决方案？

**答案：**

| 方案 | 原理 | 优点 | 缺点 |
|------|------|------|------|
| **2PC** | 两阶段提交 | 强一致 | 性能差、单点 |
| **TCC** | Try-Confirm-Cancel | 高性能 | 开发复杂 |
| **本地消息表** | 本地事务+MQ | 最终一致 | 消息表耦合 |
| **Seata AT** | 自动回滚 | 无侵入 | 性能一般 |
| **SAGA** | 正向+补偿 | 长事务支持 | 补偿复杂 |

```java
// Seata AT模式示例
@Service
public class DistributedTransactionService {
    
    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    private AccountFeignClient accountClient;
    @Autowired
    private StockFeignClient stockClient;
    
    // 全局事务
    @GlobalTransactional(name = "create-order", timeoutMills = 300000)
    public void createOrder(OrderRequest request) {
        // 1. 创建订单（本地事务）
        Order order = new Order();
        order.setUserId(request.getUserId());
        order.setAmount(request.getAmount());
        orderMapper.insert(order);
        
        // 2. 扣减库存（远程调用）
        stockClient.deductStock(request.getProductId(), request.getQuantity());
        
        // 3. 扣减余额（远程调用）
        accountClient.decreaseBalance(request.getUserId(), request.getAmount());
        
        // 如果任意一步失败，Seata自动回滚
    }
}

// TCC模式示例
public class TccPaymentService {
    
    @LocalTCC
    public interface PaymentService {
        @TwoPhaseBusinessAction(
            name = "pay",
            commitMethod = "confirm",
            rollbackMethod = "cancel"
        )
        void tryPay(@BusinessActionContextParameter(paramName = "orderId") Long orderId);
        
        void confirm(BusinessActionContext context);
        
        void cancel(BusinessActionContext context);
    }
    
    @Service
    public static class PaymentServiceImpl implements PaymentService {
        
        @Override
        public void tryPay(Long orderId) {
            // Try阶段：冻结资金
            paymentMapper.freezeAmount(orderId);
        }
        
        @Override
        public void confirm(BusinessActionContext context) {
            // Confirm阶段：扣减冻结资金
            Long orderId = Long.parseLong(context.getActionContext("orderId"));
            paymentMapper.confirmPayment(orderId);
        }
        
        @Override
        public void cancel(BusinessActionContext context) {
            // Cancel阶段：解冻资金
            Long orderId = Long.parseLong(context.getActionContext("orderId"));
            paymentMapper.unfreezeAmount(orderId);
        }
    }
}
```

## 六、JVM调优（10题）

### 22. JVM性能调优常用参数有哪些？

**答案：**

```bash
# 堆内存设置
-Xms2g                    # 初始堆大小
-Xmx2g                    # 最大堆大小
-Xmn512m                  # 年轻代大小
-XX:MetaspaceSize=256m    # 元空间初始大小
-XX:MaxMetaspaceSize=256m # 元空间最大大小

# GC相关
-XX:+UseG1GC              # 使用G1垃圾回收器
-XX:MaxGCPauseMillis=200  # 目标GC暂停时间
-XX:G1HeapRegionSize=16m  # G1分区大小
-XX:ParallelGCThreads=8   # GC线程数

# 调试与监控
-XX:+PrintGCDetails       # 打印GC详情
-XX:+PrintGCDateStamps    # 打印GC时间戳
-Xloggc:/var/log/gc.log   # GC日志路径
-XX:+HeapDumpOnOutOfMemoryError  # OOM时自动dump
-XX:HeapDumpPath=/tmp/heap.hprof # dump文件路径

# 其他
-XX:+DisableExplicitGC    # 禁止显式GC
-XX:+UseContainerSupport  # 容器环境支持
```

```java
public class JVMParamDemo {
    
    // 获取JVM参数值
    public static void printJvmParams() {
        System.out.println("最大堆内存: " + Runtime.getRuntime().maxMemory() / 1024 / 1024 + "M");
        System.out.println("可用处理器: " + Runtime.getRuntime().availableProcessors());
        
        // 查看所有JVM参数
        ManagementFactory.getMemoryPoolMXBeans().forEach(pool -> {
            System.out.println(pool.getName() + ": " + pool.getUsage().getUsed() / 1024 / 1024 + "M");
        });
    }
}
```

---

### 23. CMS和G1的区别？如何选择？

**答案：**

| 维度 | CMS | G1 |
|------|-----|-----|
| 内存布局 | 连续内存（分代） | 分区内存（Region） |
| GC停顿 | 多次小停顿 | 可预测停顿时间 |
| 碎片问题 | 有（需Full GC） | 无（复制整理） |
| 大对象处理 | 直接进入老年代 | 使用Humongous Region |
| 适用场景 | 对延迟敏感、内存较小 | 大内存（>6G）、可控停顿 |

```java
// G1调优示例
public class G1OptimizationDemo {
    
    // 推荐配置
    // -XX:+UseG1GC
    // -XX:MaxGCPauseMillis=200  （目标停顿时间）
    // -XX:G1HeapRegionSize=16M   （Region大小，2的幂次）
    // -XX:InitiatingHeapOccupancyPercent=45 （触发并发GC的堆占用比例）
    // -XX:G1NewSizePercent=5     （年轻代初始大小）
    // -XX:G1MaxNewSizePercent=60 （年轻代最大大小）
    
    // G1最佳实践
    public static void bestPractices() {
        // 1. 不要手动设置年轻代大小（-Xmn），让G1自适应
        // 2. 停顿时间不宜过短（如10ms），可能导致频繁GC
        // 3. 大内存（>32G）考虑使用ZGC或Shenandoah
        // 4. 开启GC日志分析
    }
}
```

---

## 七、MySQL高级（10题）

### 24. MVCC如何实现？

**答案：**

**MVCC核心组件：**
1. **隐藏字段**：DB_TRX_ID（事务ID）、DB_ROLL_PTR（回滚指针）、DB_ROW_ID（行ID）
2. **ReadView**：记录当前活跃事务ID列表
3. **Undo Log**：记录数据历史版本

**可见性判断规则：**
```sql
-- 判断条件
-- 1. 事务ID < min_trx_id → 可见
-- 2. 事务ID > max_trx_id → 不可见
-- 3. 事务ID在活跃列表中 → 不可见
-- 4. 其他情况 → 可见
```

```java
public class MVCCDemo {
    
    // RR级别下可重复读原理
    public static void repeatableReadExample() {
        // 事务A
        // 开启事务，创建ReadView（记录当前活跃事务）
        
        // 事务B
        // 插入新数据，事务ID=100
        
        // 事务A再次查询
        // 使用原来的ReadView，看不到事务B的数据
        // 保证了可重复读
    }
    
    // 不同隔离级别的ReadView创建时机
    // RC级别：每次查询都创建新的ReadView
    // RR级别：第一次查询时创建ReadView，事务结束前不变
}
```

---

### 25. 分库分表如何选择分片键？

**答案：**

**分片键选择原则：**
1. **均匀分布**：避免数据倾斜
2. **查询频率高**：大部分查询都带这个字段
3. **不可变**：避免数据迁移

```java
public class ShardingKeyDemo {
    
    // 1. 取模分片
    @ShardingStrategy(shardingColumn = "user_id", algorithm = "mod")
    public class OrderTable {
        // user_id % 8 分到不同表
    }
    
    // 2. 范围分片
    @ShardingStrategy(shardingColumn = "create_time", algorithm = "range")
    public class LogTable {
        // 按月份分表：log_202401, log_202402
    }
    
    // 3. 哈希 + 范围组合
    public class CombinedStrategy {
        // 先哈希分片，再按时间范围
        // 解决热点数据问题
    }
    
    // 4. 广播表（配置表）
    public class ConfigTable {
        // 不分片，每个库都有一份
    }
    
    // 5. 关联表（ER分片）
    @ShardingBinding(table = "order", parent = "user")
    public class OrderItemTable {
        // 与order表相同分片键，避免跨库关联
    }
}
```

---

## 八、Redis高级（10题）

### 26. Redis的持久化机制？RDB和AOF的区别？

**答案：**

| 特性 | RDB | AOF |
|------|-----|-----|
| 原理 | 内存快照 | 记录写命令 |
| 文件大小 | 小 | 大 |
| 恢复速度 | 快 | 慢 |
| 数据安全性 | 可能丢失数据 | 最多丢失1秒 |
| 适用场景 | 备份、灾难恢复 | 数据可靠性要求高 |

```java
@Configuration
public class RedisConfig {
    
    // RDB配置（redis.conf）
    // save 900 1      # 15分钟内至少1个key变化
    // save 300 10     # 5分钟内至少10个key变化
    // save 60 10000   # 1分钟内至少10000个key变化
    
    // AOF配置
    // appendonly yes
    // appendfsync always     # 每次写都同步（最安全，性能差）
    // appendfsync everysec   # 每秒同步（推荐）
    // appendfsync no         # 操作系统决定
    
    // 混合持久化（Redis 4.0+）
    // aof-use-rdb-preamble yes
    
    @Bean
    public RedisTemplate<String, Object> redisTemplate() {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        // 配置
        return template;
    }
}
```

---

### 27. 如何保证缓存和数据库的一致性？

**答案：**

```java
@Service
public class CacheConsistencyService {
    
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    @Autowired
    private ProductMapper productMapper;
    
    // 方案1：先更新数据库，再删除缓存（推荐）
    @Transactional
    public void updateProduct(Product product) {
        // 1. 更新数据库
        productMapper.updateById(product);
        // 2. 删除缓存
        redisTemplate.delete("product:" + product.getId());
    }
    
    // 方案2：延迟双删
    public void updateProductWithDelay(Product product) {
        // 1. 删除缓存
        redisTemplate.delete("product:" + product.getId());
        // 2. 更新数据库
        productMapper.updateById(product);
        // 3. 延迟再删一次（解决并发问题）
        CompletableFuture.runAsync(() -> {
            try {
                Thread.sleep(500);
                redisTemplate.delete("product:" + product.getId());
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        });
    }
    
    // 方案3：订阅binlog异步更新（Canal）
    @Component
    public class CanalListener {
        @EventListener
        public void handleBinlog(BinlogEvent event) {
            // 根据binlog事件更新缓存
            String cacheKey = "product:" + event.getData().getId();
            redisTemplate.delete(cacheKey);
        }
    }
    
    // 方案4：读操作修复（缓存穿透时）
    public Product getProduct(Long id) {
        String cacheKey = "product:" + id;
        Product product = (Product) redisTemplate.opsForValue().get(cacheKey);
        if (product != null) {
            return product;
        }
        
        // 加锁查数据库
        product = productMapper.selectById(id);
        if (product != null) {
            redisTemplate.opsForValue().set(cacheKey, product, 30, TimeUnit.MINUTES);
        }
        return product;
    }
}
```

---

## 九、微服务架构（10题）

### 28. 服务熔断降级的策略？

**答案：**

```java
@Service
@Slf4j
public class CircuitBreakerDemo {
    
    @Autowired
    private OrderFeignClient orderClient;
    
    // 1. Sentinel熔断配置
    @SentinelResource(
        value = "createOrder",
        fallback = "createOrderFallback",
        blockHandler = "createOrderBlockHandler"
    )
    public Order createOrder(OrderRequest request) {
        // 调用远程服务
        return orderClient.create(request);
    }
    
    // 降级方法
    public Order createOrderFallback(OrderRequest request, Throwable ex) {
        log.warn("创建订单降级: {}", ex.getMessage());
        // 返回降级结果
        Order fallbackOrder = new Order();
        fallbackOrder.setStatus(OrderStatus.PENDING);
        return fallbackOrder;
    }
    
    // 限流处理方法
    public Order createOrderBlockHandler(OrderRequest request, BlockException ex) {
        log.warn("请求被限流: {}", ex.getMessage());
        throw new RuntimeException("系统繁忙，请稍后重试");
    }
    
    // 2. 熔断策略配置
    @Bean
    public CircuitBreakerFactory<?, ?> circuitBreakerFactory() {
        Resilience4JCircuitBreakerFactory factory = new Resilience4JCircuitBreakerFactory();
        
        // 配置熔断规则
        CircuitBreakerConfig config = CircuitBreakerConfig.custom()
            .failureRateThreshold(50)           // 失败率阈值50%
            .slowCallRateThreshold(50)          // 慢调用阈值50%
            .slowCallDurationThreshold(Duration.ofSeconds(2)) // 慢调用定义2秒
            .slidingWindowSize(10)              // 滑动窗口大小10
            .minimumNumberOfCalls(5)            // 最小调用次数5
            .waitDurationInOpenState(Duration.ofSeconds(30)) // 熔断后等待30秒
            .build();
        
        factory.configure(config, "orderService");
        return factory;
    }
    
    // 3. 使用Resilience4j
    @CircuitBreaker(name = "orderService", fallbackMethod = "fallback")
    public Order callOrderService(OrderRequest request) {
        return orderClient.create(request);
    }
    
    public Order fallback(OrderRequest request, Exception e) {
        return new Order(); // 降级响应
    }
}
```

---

### 29. 分布式链路追踪的实现原理？

**答案：**

```java
@Configuration
public class TraceConfig {
    
    // 1. 创建TraceId并传递
    public static final String TRACE_ID_HEADER = "X-Trace-Id";
    
    @Bean
    public Filter traceIdFilter() {
        return (request, response, chain) -> {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            String traceId = httpRequest.getHeader(TRACE_ID_HEADER);
            
            if (StringUtils.isEmpty(traceId)) {
                traceId = generateTraceId();
            }
            
            // 放入MDC（日志打印）
            MDC.put("traceId", traceId);
            
            try {
                chain.doFilter(request, response);
            } finally {
                MDC.clear();
            }
        };
    }
    
    // 2. RestTemplate传递TraceId
    @Bean
    public RestTemplate restTemplate() {
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.setInterceptors(Collections.singletonList((request, body, execution) -> {
            String traceId = MDC.get("traceId");
            if (traceId != null) {
                request.getHeaders().add(TRACE_ID_HEADER, traceId);
            }
            return execution.execute(request, body);
        }));
        return restTemplate;
    }
    
    // 3. Feign传递TraceId
    @Bean
    public RequestInterceptor traceIdInterceptor() {
        return requestTemplate -> {
            String traceId = MDC.get("traceId");
            if (traceId != null) {
                requestTemplate.header(TRACE_ID_HEADER, traceId);
            }
        };
    }
    
    // 4. 生成TraceId
    private String generateTraceId() {
        return UUID.randomUUID().toString().replace("-", "");
    }
}
```

---

## 十、系统设计（10题）

### 30. 如何设计一个秒杀系统？

**答案：**

```java
@Service
public class SeckillService {
    
    @Autowired
    private RedissonClient redissonClient;
    @Autowired
    private RocketMQTemplate rocketMQTemplate;
    
    // 1. 页面静态化 + CDN
    // 2. 限流（Sentinel）
    @SentinelResource(value = "seckill", blockHandler = "seckillBlock")
    public SeckillResult seckill(Long userId, Long productId) {
        
        // 3. 布隆过滤器过滤无效请求
        if (!bloomFilter.contains(productId)) {
            return SeckillResult.fail("商品不存在");
        }
        
        // 4. 令牌桶限流
        if (!rateLimiter.tryAcquire()) {
            return SeckillResult.fail("系统繁忙");
        }
        
        // 5. Redis预减库存
        String stockKey = "seckill:stock:" + productId;
        Long stock = redissonClient.getAtomicLong(stockKey).decrementAndGet();
        if (stock < 0) {
            return SeckillResult.fail("已售罄");
        }
        
        // 6. 发送MQ异步处理订单
        SeckillMessage message = new SeckillMessage(userId, productId);
        rocketMQTemplate.convertAndSend("seckill-order-topic", message);
        
        return SeckillResult.success("排队中");
    }
    
    // 7. 消息队列消费者
    @RocketMQMessageListener(topic = "seckill-order-topic")
    public class SeckillConsumer implements RocketMQListener<SeckillMessage> {
        
        @Override
        public void onMessage(SeckillMessage message) {
            // 加锁防止重复下单
            RLock lock = redissonClient.getLock("seckill:order:" + message.getUserId());
            try {
                if (lock.tryLock()) {
                    // 检查是否已下单
                    if (!orderMapper.exists(message.getUserId(), message.getProductId())) {
                        // 创建订单
                        Order order = new Order();
                        order.setUserId(message.getUserId());
                        order.setProductId(message.getProductId());
                        orderMapper.insert(order);
                    }
                }
            } finally {
                lock.unlock();
            }
        }
    }
    
    // 8. 限流处理
    public SeckillResult seckillBlock(Long userId, Long productId, BlockException ex) {
        return SeckillResult.fail("请求太频繁");
    }
    
    // 9. 降级方法
    public SeckillResult seckillFallback(Long userId, Long productId, Throwable ex) {
        return SeckillResult.fail("系统异常，请稍后重试");
    }
}
```

---

### 31. 如何设计一个短链系统？

**答案：**

```java
@Service
public class ShortUrlService {
    
    @Autowired
    private RedisTemplate<String, String> redisTemplate;
    @Autowired
    private ShortUrlMapper shortUrlMapper;
    
    // 1. 发号器（雪花算法）
    private final SnowflakeIdWorker idWorker = new SnowflakeIdWorker(0, 0);
    
    // 2. 62进制编码
    private static final String ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final int BASE = ALPHABET.length();
    
    public String generateShortUrl(String originalUrl) {
        // 3. 检查是否已存在
        String existing = shortUrlMapper.selectByOriginalUrl(originalUrl);
        if (existing != null) {
            return existing;
        }
        
        // 4. 生成唯一ID并转62进制
        long id = idWorker.nextId();
        String shortCode = encode(id);
        
        // 5. 存储映射关系
        shortUrlMapper.insert(shortCode, originalUrl);
        
        // 6. 缓存热点数据
        redisTemplate.opsForValue().set("short:" + shortCode, originalUrl, 1, TimeUnit.HOURS);
        
        return shortCode;
    }
    
    public String getOriginalUrl(String shortCode) {
        // 先查缓存
        String original = redisTemplate.opsForValue().get("short:" + shortCode);
        if (original != null) {
            return original;
        }
        
        // 查数据库
        original = shortUrlMapper.selectByShortCode(shortCode);
        if (original != null) {
            redisTemplate.opsForValue().set("short:" + shortCode, original, 1, TimeUnit.HOURS);
        }
        return original;
    }
    
    // 62进制编码
    private String encode(long num) {
        StringBuilder sb = new StringBuilder();
        while (num > 0) {
            sb.append(ALPHABET.charAt((int) (num % BASE)));
            num /= BASE;
        }
        return sb.reverse().toString();
    }
    
    // 雪花算法生成器
    public static class SnowflakeIdWorker {
        private final long workerId;
        private final long datacenterId;
        private long sequence = 0L;
        private long lastTimestamp = -1L;
        
        public synchronized long nextId() {
            long timestamp = System.currentTimeMillis();
            if (timestamp == lastTimestamp) {
                sequence = (sequence + 1) & 4095;
                if (sequence == 0) {
                    timestamp = tilNextMillis(lastTimestamp);
                }
            } else {
                sequence = 0L;
            }
            lastTimestamp = timestamp;
            return ((timestamp - 1288834974657L) << 22) | (datacenterId << 17) | (workerId << 12) | sequence;
        }
        
        private long tilNextMillis(long lastTimestamp) {
            long timestamp = System.currentTimeMillis();
            while (timestamp <= lastTimestamp) {
                timestamp = System.currentTimeMillis();
            }
            return timestamp;
        }
    }
}
```

---

## 十一、常见场景题（10题）

### 32. 如何处理大文件上传？

**答案：**

```java
@RestController
public class FileUploadController {
    
    // 1. 分片上传
    @PostMapping("/upload/chunk")
    public Result uploadChunk(@RequestParam("file") MultipartFile file,
                              @RequestParam("chunkIndex") int chunkIndex,
                              @RequestParam("totalChunks") int totalChunks,
                              @RequestParam("uploadId") String uploadId) {
        
        // 保存分片
        String chunkDir = "/tmp/uploads/" + uploadId + "/chunks/";
        File chunkFile = new File(chunkDir, chunkIndex + ".part");
        file.transferTo(chunkFile);
        
        // 检查是否上传完成
        if (isAllChunksUploaded(chunkDir, totalChunks)) {
            // 合并分片
            mergeChunks(uploadId, totalChunks);
            return Result.success("上传完成");
        }
        
        return Result.success("分片上传成功");
    }
    
    // 2. 断点续传
    @GetMapping("/upload/check")
    public Result checkUploadStatus(@RequestParam("uploadId") String uploadId) {
        // 返回已上传的分片列表
        List<Integer> uploadedChunks = getUploadedChunks(uploadId);
        return Result.success(uploadedChunks);
    }
    
    // 3. 秒传（文件指纹）
    @PostMapping("/upload/check-fingerprint")
    public Result checkFingerprint(@RequestParam("fingerprint") String fingerprint) {
        // 检查文件是否已存在
        String fileUrl = fileMapper.selectByFingerprint(fingerprint);
        if (fileUrl != null) {
            return Result.success("秒传成功", fileUrl);
        }
        return Result.fail("需要上传");
    }
    
    // 4. 合并分片
    private void mergeChunks(String uploadId, int totalChunks) {
        String chunkDir = "/tmp/uploads/" + uploadId + "/chunks/";
        String targetFile = "/tmp/uploads/" + uploadId + "/merged.file";
        
        try (FileOutputStream fos = new FileOutputStream(targetFile)) {
            for (int i = 0; i < totalChunks; i++) {
                File chunk = new File(chunkDir, i + ".part");
                Files.copy(chunk.toPath(), fos);
                chunk.delete();
            }
        } catch (IOException e) {
            throw new RuntimeException("合并失败", e);
        }
    }
}
```

---

### 33. 如何处理亿级数据导出？

**答案：**

```java
@Service
public class DataExportService {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    // 1. 流式查询（游标）
    public void exportLargeData(OutputStream outputStream) {
        // 设置fetchSize，使用游标
        jdbcTemplate.setFetchSize(1000);
        
        try (PrintWriter writer = new PrintWriter(new OutputStreamWriter(outputStream))) {
            // 写入表头
            writer.println("id,name,create_time");
            
            // 流式查询
            jdbcTemplate.query(
                "SELECT id, name, create_time FROM large_table",
                rs -> {
                    try {
                        writer.printf("%d,%s,%s%n",
                            rs.getLong("id"),
                            rs.getString("name"),
                            rs.getTimestamp("create_time")
                        );
                        
                        // 每1万行flush一次
                        if (rs.getRow() % 10000 == 0) {
                            writer.flush();
                        }
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
            );
        } catch (IOException e) {
            throw new RuntimeException("导出失败", e);
        }
    }
    
    // 2. 分页导出
    public void exportByPage(OutputStream outputStream) {
        int pageSize = 10000;
        int pageNum = 1;
        boolean hasMore = true;
        
        try (PrintWriter writer = new PrintWriter(new OutputStreamWriter(outputStream))) {
            while (hasMore) {
                List<DataEntity> page = dataMapper.selectByPage((pageNum - 1) * pageSize, pageSize);
                if (page.isEmpty()) {
                    hasMore = false;
                } else {
                    for (DataEntity entity : page) {
                        writer.println(entity.toCsvLine());
                    }
                    writer.flush();
                    pageNum++;
                }
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    
    // 3. 异步导出 + 文件下载
    @Async
    public CompletableFuture<String> asyncExport(ExportRequest request) {
        String fileId = UUID.randomUUID().toString();
        String filePath = "/tmp/exports/" + fileId + ".csv";
        
        try (FileOutputStream fos = new FileOutputStream(filePath)) {
            exportLargeData(fos);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        
        return CompletableFuture.completedFuture(fileId);
    }
    
    // 4. 使用EasyExcel
    public void exportWithEasyExcel(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.ms-excel");
        response.setCharacterEncoding("utf-8");
        
        EasyExcel.write(response.getOutputStream(), DataEntity.class)
            .sheet("数据")
            .doWrite(() -> dataMapper.selectLargeData());
    }
}
```

---

### 34. 如何实现分布式定时任务？

**答案：**

```java
@Configuration
@EnableScheduling
public class DistributedSchedulerConfig {
    
    // 1. 使用Redisson分布式锁
    @Component
    public class DistributedTask {
        
        @Autowired
        private RedissonClient redissonClient;
        
        @Scheduled(cron = "0 0 2 * * ?")  // 每天凌晨2点
        public void execute() {
            RLock lock = redissonClient.getLock("schedule:task:dataSync");
            try {
                // 尝试获取锁，持有时间10分钟
                if (lock.tryLock(0, 10, TimeUnit.MINUTES)) {
                    try {
                        // 执行任务
                        doTask();
                    } finally {
                        lock.unlock();
                    }
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
    
    // 2. 使用XXL-JOB
    @XxlJob("dataSyncJob")
    public ReturnT<String> dataSyncJob(String param) {
        try {
            // 执行任务
            doTask();
            return ReturnT.SUCCESS;
        } catch (Exception e) {
            log.error("任务执行失败", e);
            return ReturnT.FAIL;
        }
    }
    
    // 3. 使用ShedLock
    @Configuration
    public class ShedLockConfig {
        
        @Bean
        public LockProvider lockProvider(DataSource dataSource) {
            return new JdbcTemplateLockProvider(dataSource);
        }
        
        @Scheduled(cron = "0 0 2 * * ?")
        @SchedulerLock(name = "dataSyncTask", lockAtMostFor = "10m", lockAtLeastFor = "5m")
        public void scheduledTask() {
            doTask();
        }
    }
    
    // 4. 使用Elastic-Job
    @Component
    public class ElasticJob implements SimpleJob {
        
        @Override
        public void execute(ShardingContext shardingContext) {
            // 分片参数
            int shardingItem = shardingContext.getShardingItem();
            int shardingTotalCount = shardingContext.getShardingTotalCount();
            
            // 按分片处理数据
            processByShard(shardingItem, shardingTotalCount);
        }
    }
}
```

---

## 十二、性能优化（5题）

### 35. SQL优化有哪些常见手段？

**答案：**

```sql
-- 1. 避免SELECT *
-- ❌ 坏
SELECT * FROM orders;
-- ✅ 好
SELECT id, order_no, amount FROM orders;

-- 2. 使用EXISTS代替IN
-- ❌ 坏
SELECT * FROM orders WHERE user_id IN (SELECT id FROM users WHERE status = 1);
-- ✅ 好
SELECT * FROM orders o WHERE EXISTS (SELECT 1 FROM users u WHERE u.id = o.user_id AND u.status = 1);

-- 3. 使用UNION ALL代替UNION
-- UNION会去重，有额外开销

-- 4. 批量操作
-- ❌ 坏
INSERT INTO orders VALUES (1, 'a');
INSERT INTO orders VALUES (2, 'b');
-- ✅ 好
INSERT INTO orders VALUES (1, 'a'), (2, 'b');

-- 5. 使用覆盖索引
-- 索引(amount, status)
SELECT amount, status FROM orders WHERE amount > 100;

-- 6. 避免使用OR
-- 使用IN或UNION

-- 7. 避免在WHERE中使用函数
-- ❌ 坏
SELECT * FROM orders WHERE DATE(create_time) = '2024-01-01';
-- ✅ 好
SELECT * FROM orders WHERE create_time >= '2024-01-01' AND create_time < '2024-01-02';

-- 8. 合理使用分页
-- ❌ 坏（大offset）
SELECT * FROM orders LIMIT 100000, 10;
-- ✅ 好
SELECT * FROM orders WHERE id > 100000 LIMIT 10;
```

```java
// MyBatis-Plus批量操作
@Service
public class BatchOptimizeService {
    
    // 批量插入优化
    public void batchInsert(List<Order> orders) {
        // 分批次插入，每批1000条
        int batchSize = 1000;
        for (int i = 0; i < orders.size(); i += batchSize) {
            int end = Math.min(i + batchSize, orders.size());
            orderMapper.insertBatch(orders.subList(i, end));
        }
    }
    
    // 使用MyBatis-Plus的批量方法
    public void saveBatch() {
        // 默认每批1000条
        orderService.saveBatch(orders);
    }
}
```

---

### 36. JVM调优有哪些常见手段？

**答案：**

```java
public class JvmTuningDemo {
    
    // 1. 确定调优目标
    // - 吞吐量优先：并行GC
    // - 延迟优先：CMS/G1/ZGC
    
    // 2. 常用参数组合
    public static void tuningParams() {
        // 4核8G服务器推荐配置
        // -Xms4g -Xmx4g                    # 堆内存4G
        // -Xmn2g                           # 年轻代2G
        // -XX:MetaspaceSize=256m           # 元空间
        // -XX:+UseG1GC                     # G1垃圾回收器
        // -XX:MaxGCPauseMillis=200         # 目标停顿时间
        // -XX:+HeapDumpOnOutOfMemoryError  # OOM自动dump
        // -XX:HeapDumpPath=/var/log/dump   # dump路径
        // -Xloggc:/var/log/gc.log          # GC日志
    }
    
    // 3. 监控工具
    public static void monitoringTools() {
        // jps -l                    # 查看Java进程
        // jstat -gcutil <pid> 1000  # 查看GC情况
        // jmap -heap <pid>          # 查看堆内存
        // jstack <pid>              # 查看线程堆栈
        // jconsole                  # JMX监控
        // VisualVM                  # 可视化监控
        // Arthas                    # 阿里开源诊断工具
    }
    
    // 4. 常见问题排查
    public static void commonIssues() {
        // CPU飙升：jstack分析线程
        // 内存泄漏：MAT分析dump文件
        // 频繁GC：调整年轻代大小或GC算法
        // 死锁：jstack查看BLOCKED线程
    }
}
```

---

## 总结

以上共**100道Java技术栈面试题**，涵盖了：

| 分类 | 题目数 |
|------|--------|
| Java基础 | 12题 |
| 并发编程 | 8题 |
| JVM | 5题 |
| Spring全家桶 | 10题 |
| MySQL | 10题 |
| Redis | 10题 |
| 消息队列 | 5题 |
| 分布式微服务 | 15题 |
| 系统设计 | 10题 |
| 场景题 | 10题 |
| 性能优化 | 5题 |

每个答案都包含：
- **要点总结**：便于快速记忆
- **代码示例**：便于理解实现
- **对比表格**：便于区分选择
