好，那我直接给你一套**可运行的 Spring Boot3 WebSocket 路由框架 + Cocos TS NetManager**，实现：

✅ cmd -> handler 自动分发
✅ 支持 @WsCmd 注解注册
✅ 支持 session 管理、uid 绑定
✅ 支持统一返回格式（cmd/seq/code/msg/data）
✅ Cocos 客户端支持 send + request/response + push 监听
✅ 断线重连 snapshot 接口预留

下面是核心代码结构（你直接复制到项目即可）。

---

# 一、后端 Spring Boot3 WebSocket 路由框架

## 1）消息结构（WsMessage）

```java
// WsMessage.java
import lombok.Data;

@Data
public class WsMessage {
    private int cmd;
    private long seq;
    private int code;
    private String msg;
    private Object data;

    public static WsMessage ok(int cmd, long seq, Object data) {
        WsMessage m = new WsMessage();
        m.setCmd(cmd);
        m.setSeq(seq);
        m.setCode(0);
        m.setMsg("ok");
        m.setData(data);
        return m;
    }

    public static WsMessage fail(int cmd, long seq, int code, String msg) {
        WsMessage m = new WsMessage();
        m.setCmd(cmd);
        m.setSeq(seq);
        m.setCode(code);
        m.setMsg(msg);
        return m;
    }
}
```

---

## 2）注解定义（@WsCmd）

```java
// WsCmd.java
import java.lang.annotation.*;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface WsCmd {
    int value();
}
```

---

## 3）Session 管理器（WsSessionManager）

```java
// WsSessionManager.java
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketSession;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class WsSessionManager {

    private final Map<Long, WebSocketSession> uidSessionMap = new ConcurrentHashMap<>();
    private final Map<String, Long> sessionUidMap = new ConcurrentHashMap<>();

    public void bindUid(WebSocketSession session, long uid) {
        uidSessionMap.put(uid, session);
        sessionUidMap.put(session.getId(), uid);
    }

    public void unbind(WebSocketSession session) {
        Long uid = sessionUidMap.remove(session.getId());
        if (uid != null) {
            uidSessionMap.remove(uid);
        }
    }

    public Long getUid(WebSocketSession session) {
        return sessionUidMap.get(session.getId());
    }

    public WebSocketSession getSession(long uid) {
        return uidSessionMap.get(uid);
    }
}
```

---

## 4）Handler 注册器（WsCmdRegistry）

启动时扫描所有 `@WsCmd` 方法。

```java
// WsCmdRegistry.java
import lombok.Getter;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

@Component
public class WsCmdRegistry {

    @Getter
    private final Map<Integer, HandlerMethod> handlers = new HashMap<>();

    public WsCmdRegistry(ApplicationContext ctx) {
        Map<String, Object> beans = ctx.getBeansWithAnnotation(org.springframework.stereotype.Component.class);

        for (Object bean : beans.values()) {
            for (Method method : bean.getClass().getDeclaredMethods()) {
                WsCmd ann = method.getAnnotation(WsCmd.class);
                if (ann != null) {
                    int cmd = ann.value();
                    if (handlers.containsKey(cmd)) {
                        throw new RuntimeException("重复 WsCmd 注册 cmd=" + cmd);
                    }
                    method.setAccessible(true);
                    handlers.put(cmd, new HandlerMethod(bean, method));
                }
            }
        }
    }

    public record HandlerMethod(Object bean, Method method) {}
}
```

---

## 5）WebSocket 消息分发器（WsDispatcher）

```java
// WsDispatcher.java
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

@Component
@RequiredArgsConstructor
public class WsDispatcher {

    private final ObjectMapper objectMapper;
    private final WsCmdRegistry registry;

    public void dispatch(WebSocketSession session, String payload) throws Exception {
        WsMessage req = objectMapper.readValue(payload, WsMessage.class);

        WsCmdRegistry.HandlerMethod handler = registry.getHandlers().get(req.getCmd());
        if (handler == null) {
            send(session, WsMessage.fail(req.getCmd(), req.getSeq(), 404, "cmd not found"));
            return;
        }

        Object result = handler.method().invoke(handler.bean(), session, req);

        if (result != null) {
            send(session, result);
        }
    }

    public void send(WebSocketSession session, Object obj) throws Exception {
        String json = objectMapper.writeValueAsString(obj);
        session.sendMessage(new TextMessage(json));
    }
}
```

---

## 6）WebSocket 主入口（GameWebSocketHandler）

```java
// GameWebSocketHandler.java
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.*;

@Component
@RequiredArgsConstructor
public class GameWebSocketHandler extends TextWebSocketHandler {

    private final WsDispatcher dispatcher;
    private final WsSessionManager sessionManager;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        System.out.println("WS Connected: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        dispatcher.dispatch(session, message.getPayload());
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        sessionManager.unbind(session);
        System.out.println("WS Closed: " + session.getId());
    }
}
```

---

## 7）WebSocket 配置（WebSocketConfig）

```java
// WebSocketConfig.java
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.*;

@Configuration
@EnableWebSocket
@RequiredArgsConstructor
public class WebSocketConfig implements WebSocketConfigurer {

    private final GameWebSocketHandler gameWebSocketHandler;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(gameWebSocketHandler, "/ws")
                .setAllowedOrigins("*");
    }
}
```

---

## 8）示例业务 Handler（AuthHandler）

`SYS_AUTH` 处理 token 鉴权，绑定 uid。

```java
// AuthWsHandler.java
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketSession;

import java.util.Map;

@Component
public class AuthWsHandler {

    private final WsSessionManager sessionManager;

    public AuthWsHandler(WsSessionManager sessionManager) {
        this.sessionManager = sessionManager;
    }

    @WsCmd(Cmd.SYS_AUTH)
    public WsMessage auth(WebSocketSession session, WsMessage req) {

        Map<String, Object> data = (Map<String, Object>) req.getData();
        String token = (String) data.get("token");

        // TODO: 校验 token -> uid
        long uid = 10001;

        sessionManager.bindUid(session, uid);

        return WsMessage.ok(req.getCmd(), req.getSeq(), Map.of(
                "uid", uid,
                "serverTime", System.currentTimeMillis()
        ));
    }
}
```

---

## 9）示例房间 Handler（RoomWsHandler）

```java
// RoomWsHandler.java
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketSession;

import java.util.Map;

@Component
public class RoomWsHandler {

    private final WsSessionManager sessionManager;

    public RoomWsHandler(WsSessionManager sessionManager) {
        this.sessionManager = sessionManager;
    }

    @WsCmd(Cmd.ROOM_JOIN)
    public WsMessage joinRoom(WebSocketSession session, WsMessage req) {
        Long uid = sessionManager.getUid(session);
        if (uid == null) {
            return WsMessage.fail(req.getCmd(), req.getSeq(), 401, "not authed");
        }

        Map<String, Object> data = (Map<String, Object>) req.getData();
        String roomId = (String) data.get("roomId");

        // TODO: roomService.join(uid, roomId)

        return WsMessage.ok(req.getCmd(), req.getSeq(), Map.of(
                "roomId", roomId,
                "seat", 1
        ));
    }
}
```

---

# 二、服务端推送工具（PushService）

```java
// WsPushService.java
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

@Service
@RequiredArgsConstructor
public class WsPushService {

    private final WsSessionManager sessionManager;
    private final ObjectMapper objectMapper;

    public void pushToUid(long uid, WsMessage msg) {
        try {
            WebSocketSession session = sessionManager.getSession(uid);
            if (session == null || !session.isOpen()) return;

            String json = objectMapper.writeValueAsString(msg);
            session.sendMessage(new TextMessage(json));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

推送例子：

```java
pushService.pushToUid(uid, WsMessage.ok(Cmd.PUSH_ROOM_JOINED, 0, payload));
```

---

# 三、Cocos TS 客户端 NetManager（支持 request/response）

## 1）协议对象定义

```ts
export interface WsMessage {
  cmd: number;
  seq: number;
  code?: number;
  msg?: string;
  data?: any;
}
```

---

## 2）NetManager.ts

```ts
// NetManager.ts
import { Cmd } from "./Cmd";

type Handler = (msg: WsMessage) => void;

export class NetManager {
  private ws: WebSocket | null = null;
  private seq: number = 1;

  private handlers: Map<number, Handler[]> = new Map();
  private pending: Map<number, (msg: WsMessage) => void> = new Map();

  connect(url: string) {
    this.ws = new WebSocket(url);

    this.ws.onopen = () => {
      console.log("WS connected");
    };

    this.ws.onmessage = (ev) => {
      const msg: WsMessage = JSON.parse(ev.data);

      // 先处理 request-response
      if (msg.seq && this.pending.has(msg.seq)) {
        const cb = this.pending.get(msg.seq)!;
        this.pending.delete(msg.seq);
        cb(msg);
        return;
      }

      // push handler
      const list = this.handlers.get(msg.cmd);
      if (list) {
        list.forEach(fn => fn(msg));
      }
    };

    this.ws.onclose = () => {
      console.log("WS closed");
    };

    this.ws.onerror = (err) => {
      console.error("WS error", err);
    };
  }

  send(cmd: number, data: any = {}) {
    if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
      console.error("ws not open");
      return;
    }

    const msg: WsMessage = {
      cmd,
      seq: 0,
      data
    };

    this.ws.send(JSON.stringify(msg));
  }

  request(cmd: number, data: any = {}): Promise<WsMessage> {
    return new Promise((resolve, reject) => {
      if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
        reject("ws not open");
        return;
      }

      const seq = this.seq++;
      const msg: WsMessage = {
        cmd,
        seq,
        data
      };

      this.pending.set(seq, resolve);
      this.ws.send(JSON.stringify(msg));

      // 超时保护
      setTimeout(() => {
        if (this.pending.has(seq)) {
          this.pending.delete(seq);
          reject("timeout cmd=" + cmd);
        }
      }, 5000);
    });
  }

  on(cmd: number, handler: Handler) {
    if (!this.handlers.has(cmd)) {
      this.handlers.set(cmd, []);
    }
    this.handlers.get(cmd)!.push(handler);
  }

  off(cmd: number, handler: Handler) {
    const list = this.handlers.get(cmd);
    if (!list) return;

    const idx = list.indexOf(handler);
    if (idx >= 0) list.splice(idx, 1);
  }

  close() {
    this.ws?.close();
    this.ws = null;
  }
}
```

---

# 四、Cocos 客户端使用示例

## 1）连接 + 鉴权

```ts
const net = new NetManager();
net.connect("ws://localhost:8080/ws");

net.request(Cmd.SYS_AUTH, { token: "xxx" })
  .then(res => {
    console.log("auth ok", res.data);
  });
```

---

## 2）监听房间推送

```ts
net.on(Cmd.PUSH_ROOM_JOINED, (msg) => {
  console.log("有人加入房间", msg.data);
});
```

---

## 3）请求加入房间

```ts
net.request(Cmd.ROOM_JOIN, { roomId: "R10001" })
  .then(res => {
    console.log("join ok", res.data);
  })
  .catch(err => console.error(err));
```

---

# 五、断线重连 Snapshot（标准实现方式）

客户端断线后重连：

```ts
net.request(Cmd.SYS_RECONNECT, {
  roomId: "R10001",
  lastFrame: 100
});
```

服务端返回：

* room snapshot
* game snapshot
* 当前 frame

---

# 六、你下一步一定要做的优化（必须）

### 1）Handler 扫描别只扫描 @Component

现在 registry 是简单版，建议扫描所有 Bean（否则 @Service 也找不到）

### 2）消息 data 建议用 DTO，而不是 Map

否则后期维护非常痛苦。

### 3）推送必须异步队列

不要在游戏线程直接 sendMessage。

---

如果你希望我继续，我可以给你升级版：

✅ Spring Boot WebSocket：支持 `@WsController + @WsCmd`
✅ 支持自动 JSON->DTO 参数绑定
✅ 支持权限注解 `@NeedAuth`
✅ 支持 Netty（高并发）替代 Spring WS

你要哪个版本？（简单版够用，企业版更强）
