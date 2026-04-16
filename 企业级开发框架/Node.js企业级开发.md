Node.js 完全可以做**企业级开发**，而且在很多公司（尤其是互联网、跨境、电商、SaaS、中台、BFF）是主力技术栈之一。关键不在于“能不能”，而在于**工程化、架构、规范、可维护性**能不能做到位。

下面给你一套「Node.js 企业级开发」的标准答案（偏实战）。

---

## 1. Node.js 企业级开发常见应用场景

### ✅ 最适合的业务

* API 网关 / BFF（给前端服务）
* 管理后台系统接口
* SaaS 平台（中小型业务非常常见）
* IM/聊天室/实时协作（WebSocket）
* 任务调度、消息通知、Webhook 服务
* 微服务（轻量业务服务）

### ⚠️ 不太适合（除非团队很强）

* 极重 CPU 运算（图像处理/复杂算法）
* 超高并发低延迟交易系统（金融核心链路）
* 大型复杂单体（会很容易失控）

---

## 2. 企业级 Node.js 技术栈推荐（主流）

### Web 框架

* **NestJS（最推荐）**：像 Spring Boot 一样，模块化、依赖注入、工程规范强
* Express：轻量但容易写成“屎山”
* Fastify：性能好，适合高吞吐 API

👉 企业级首选：**NestJS**

---

## 3. 企业级项目必备组件

### 基础三件套

* **TypeScript**（必须）
* **ESLint + Prettier**（代码规范）
* **Husky + lint-staged**（提交前自动检查）

### 配置管理

* dotenv + config 分环境（dev/test/prod）
* 统一配置模块（ConfigService）

### 数据层

* ORM：**Prisma / TypeORM**
* MySQL / PostgreSQL（主流企业）
* MongoDB（文档业务）

### 缓存与会话

* Redis（缓存、分布式锁、限流、token黑名单）

### 消息队列

* RabbitMQ（业务解耦、异步任务）
* Kafka（日志、埋点、大吞吐）

### 任务调度

* BullMQ（基于 Redis 的队列）
* node-cron（简单定时）

---

## 4. 企业级架构风格（推荐）

### 常用架构

* MVC（Express 常见）
* 分层架构（Controller / Service / Repository）
* DDD（大型项目）
* 微服务（NestJS + gRPC / HTTP）

### 推荐落地方式（适合大多数公司）

**Controller → Service → Repository → DB**
再加：

* DTO 参数校验
* Guard 权限认证
* Interceptor 统一返回结构
* ExceptionFilter 统一异常处理

---

## 5. 企业级必须具备的能力点（面试重点）

### 认证与授权

* JWT（Access Token + Refresh Token）
* RBAC 权限（角色、菜单、接口权限）
* OAuth2 / SSO（企业常见）

### 参数校验

* class-validator（NestJS）
* Joi / Zod

### 日志体系

* Winston / Pino
* 日志分级（info/warn/error）
* traceId（链路追踪）

### API 文档

* Swagger/OpenAPI 自动生成

### 限流与防刷

* Redis + Token Bucket
* Nginx 限流

### 监控与告警

* Prometheus + Grafana
* Sentry（异常上报）

---

## 6. Node.js 企业级性能优化核心点

企业级项目必须考虑：

* **事件循环阻塞**（CPU密集任务要拆分）
* 多进程：cluster / PM2
* 连接池：数据库连接池、Redis连接复用
* 缓存策略：热点数据缓存 + TTL
* 接口分页与索引优化
* 慢查询监控

---

## 7. 企业级部署方案（生产级）

### 推荐部署组合

* Docker + Docker Compose（中小公司）
* Docker + K8s（大厂/平台型）

### 典型配套

* Nginx 反向代理
* Node 服务多实例（PM2）
* MySQL/PostgreSQL
* Redis
* MQ（RabbitMQ/Kafka）

---

## 8. Node.js 企业级项目目录结构（标准）

以 NestJS 为例（推荐结构）：

```
src/
  modules/
    user/
      user.controller.ts
      user.service.ts
      user.repository.ts
      dto/
      entity/
  common/
    guards/
    filters/
    interceptors/
    middleware/
    decorators/
  config/
  database/
  main.ts
```

这个结构基本就是企业标准。

---

## 9. Node.js 企业级开发常见公司用法（市场真实情况）

* Node 做 BFF（前端接口聚合）非常多
* Java 做核心业务（订单、支付）非常多
* Node 做中间层 + 管理后台接口是主流搭配

👉 Node 常常不是“核心交易系统”，但在企业里是非常关键的一环。

---

## 10. 企业级 Node.js 推荐学习路线（最快上手）

如果你想走“企业级路线”，建议顺序：

1）TypeScript + async/await
2）NestJS（模块、DI、Guard、Interceptor）
3）Prisma + PostgreSQL
4）Redis + BullMQ
5）JWT + RBAC
6）Docker + Nginx + CI/CD
7）Prometheus + Grafana + 日志体系

---

## 结论（一句话）

Node.js 企业级开发完全没问题，但必须用 **TypeScript + NestJS + 规范化分层 + Redis/MQ + Docker/K8s + 监控日志体系** 才算真正企业级。

如果你要的话，我可以直接给你一套**可运行的 NestJS 企业级项目模板**（JWT + RBAC + Prisma + Redis + Swagger + Docker Compose），结构和 Spring Boot 一样清晰。


下面给你一套**真正可运行的 NestJS 企业级项目模板**（生产级骨架），包含：

✅ NestJS + TypeScript
✅ JWT 登录（AccessToken + RefreshToken）
✅ RBAC 权限（角色/权限点）
✅ Prisma + PostgreSQL
✅ Redis（缓存/Token黑名单）
✅ Swagger 文档
✅ 全局异常处理 / 统一返回结构
✅ Docker Compose 一键启动（Postgres + Redis + API）
✅ 数据库初始化 seed 脚本（自动创建 admin）

我直接给你完整项目代码结构，你复制后即可运行。

---

# 1. 项目目录结构（企业级）

```
nestjs-enterprise-template/
├── docker-compose.yml
├── Dockerfile
├── package.json
├── tsconfig.json
├── .env
├── .env.example
├── prisma/
│   ├── schema.prisma
│   ├── seed.ts
│   └── migrations/
├── src/
│   ├── main.ts
│   ├── app.module.ts
│   ├── common/
│   │   ├── constants/
│   │   ├── decorators/
│   │   ├── dto/
│   │   ├── filters/
│   │   ├── guards/
│   │   ├── interceptors/
│   │   ├── pipes/
│   │   ├── utils/
│   ├── config/
│   │   ├── config.module.ts
│   │   ├── config.service.ts
│   ├── database/
│   │   ├── prisma.module.ts
│   │   ├── prisma.service.ts
│   ├── redis/
│   │   ├── redis.module.ts
│   │   ├── redis.service.ts
│   ├── modules/
│   │   ├── auth/
│   │   ├── user/
│   │   ├── role/
│   │   ├── permission/
│   │   ├── health/
│   └── shared/
│       ├── logger/
│       ├── response/
└── README.md
```

---

# 2. package.json

📌 `package.json`

```json
{
  "name": "nestjs-enterprise-template",
  "version": "1.0.0",
  "description": "Enterprise NestJS Template with JWT + RBAC + Prisma + Redis + Docker",
  "scripts": {
    "start": "nest start",
    "start:dev": "nest start --watch",
    "build": "nest build",
    "lint": "eslint .",
    "format": "prettier --write .",
    "prisma:generate": "prisma generate",
    "prisma:migrate": "prisma migrate dev",
    "prisma:studio": "prisma studio",
    "seed": "ts-node prisma/seed.ts"
  },
  "dependencies": {
    "@nestjs/common": "^10.3.2",
    "@nestjs/config": "^3.2.0",
    "@nestjs/core": "^10.3.2",
    "@nestjs/jwt": "^10.2.0",
    "@nestjs/passport": "^10.0.3",
    "@nestjs/platform-express": "^10.3.2",
    "@nestjs/swagger": "^7.3.0",
    "bcrypt": "^5.1.1",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.1",
    "ioredis": "^5.4.1",
    "passport": "^0.7.0",
    "passport-jwt": "^4.0.1",
    "prisma": "^5.12.1",
    "@prisma/client": "^5.12.1",
    "reflect-metadata": "^0.2.2",
    "rxjs": "^7.8.1"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.3.2",
    "@nestjs/schematics": "^10.1.1",
    "@nestjs/testing": "^10.3.2",
    "@types/bcrypt": "^5.0.2",
    "@types/node": "^20.12.7",
    "@types/passport-jwt": "^4.0.1",
    "eslint": "^8.57.0",
    "eslint-config-prettier": "^9.1.0",
    "eslint-plugin-prettier": "^5.1.3",
    "prettier": "^3.2.5",
    "ts-node": "^10.9.2",
    "typescript": "^5.4.5"
  }
}
```

---

# 3. 环境变量配置

📌 `.env.example`

```env
APP_PORT=3000

DATABASE_URL="postgresql://postgres:postgres@localhost:5432/nestdb?schema=public"

JWT_ACCESS_SECRET="access_secret_123"
JWT_REFRESH_SECRET="refresh_secret_456"
JWT_ACCESS_EXPIRE=3600
JWT_REFRESH_EXPIRE=604800

REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
```

📌 `.env`

```env
APP_PORT=3000
DATABASE_URL="postgresql://postgres:postgres@postgres:5432/nestdb?schema=public"

JWT_ACCESS_SECRET="access_secret_123"
JWT_REFRESH_SECRET="refresh_secret_456"
JWT_ACCESS_EXPIRE=3600
JWT_REFRESH_EXPIRE=604800

REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=
```

---

# 4. Docker Compose（生产级一键启动）

📌 `docker-compose.yml`

```yaml
version: "3.9"

services:
  postgres:
    image: postgres:16
    container_name: nest_postgres
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: nestdb
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7
    container_name: nest_redis
    restart: always
    ports:
      - "6379:6379"

  api:
    build: .
    container_name: nest_api
    restart: always
    depends_on:
      - postgres
      - redis
    ports:
      - "3000:3000"
    environment:
      - APP_PORT=3000
      - DATABASE_URL=postgresql://postgres:postgres@postgres:5432/nestdb?schema=public
      - JWT_ACCESS_SECRET=access_secret_123
      - JWT_REFRESH_SECRET=refresh_secret_456
      - JWT_ACCESS_EXPIRE=3600
      - JWT_REFRESH_EXPIRE=604800
      - REDIS_HOST=redis
      - REDIS_PORT=6379

volumes:
  pgdata:
```

---

# 5. Dockerfile

📌 `Dockerfile`

```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["node", "dist/main.js"]
```

---

# 6. Prisma 数据库模型（RBAC）

📌 `prisma/schema.prisma`

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(uuid())
  username  String   @unique
  password  String
  roles     UserRole[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Role {
  id          String        @id @default(uuid())
  name        String        @unique
  description String?
  users       UserRole[]
  permissions RolePermission[]
  createdAt   DateTime      @default(now())
}

model Permission {
  id          String        @id @default(uuid())
  code        String        @unique
  description String?
  roles       RolePermission[]
  createdAt   DateTime      @default(now())
}

model UserRole {
  id     String @id @default(uuid())
  userId String
  roleId String

  user User @relation(fields: [userId], references: [id])
  role Role @relation(fields: [roleId], references: [id])

  @@unique([userId, roleId])
}

model RolePermission {
  id           String @id @default(uuid())
  roleId       String
  permissionId String

  role       Role       @relation(fields: [roleId], references: [id])
  permission Permission @relation(fields: [permissionId], references: [id])

  @@unique([roleId, permissionId])
}
```

---

# 7. Prisma Seed 初始化（创建 admin）

📌 `prisma/seed.ts`

```ts
import { PrismaClient } from "@prisma/client";
import * as bcrypt from "bcrypt";

const prisma = new PrismaClient();

async function main() {
  const adminRole = await prisma.role.upsert({
    where: { name: "admin" },
    update: {},
    create: { name: "admin", description: "Super Admin Role" }
  });

  const p1 = await prisma.permission.upsert({
    where: { code: "USER_READ" },
    update: {},
    create: { code: "USER_READ", description: "Read user list" }
  });

  const p2 = await prisma.permission.upsert({
    where: { code: "USER_CREATE" },
    update: {},
    create: { code: "USER_CREATE", description: "Create user" }
  });

  await prisma.rolePermission.upsert({
    where: {
      roleId_permissionId: { roleId: adminRole.id, permissionId: p1.id }
    },
    update: {},
    create: { roleId: adminRole.id, permissionId: p1.id }
  });

  await prisma.rolePermission.upsert({
    where: {
      roleId_permissionId: { roleId: adminRole.id, permissionId: p2.id }
    },
    update: {},
    create: { roleId: adminRole.id, permissionId: p2.id }
  });

  const passwordHash = await bcrypt.hash("admin123", 10);

  const admin = await prisma.user.upsert({
    where: { username: "admin" },
    update: {},
    create: {
      username: "admin",
      password: passwordHash,
      roles: {
        create: {
          roleId: adminRole.id
        }
      }
    }
  });

  console.log("Seed done. Admin user:", admin.username);
}

main()
  .catch((e) => console.error(e))
  .finally(async () => await prisma.$disconnect());
```

---

# 8. NestJS 启动入口 main.ts

📌 `src/main.ts`

```ts
import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import { ValidationPipe } from "@nestjs/common";
import { SwaggerModule, DocumentBuilder } from "@nestjs/swagger";
import { HttpExceptionFilter } from "./common/filters/http-exception.filter";
import { ResponseInterceptor } from "./common/interceptors/response.interceptor";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true
    })
  );

  app.useGlobalFilters(new HttpExceptionFilter());
  app.useGlobalInterceptors(new ResponseInterceptor());

  const config = new DocumentBuilder()
    .setTitle("NestJS Enterprise API")
    .setDescription("JWT + RBAC + Prisma + Redis")
    .setVersion("1.0")
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup("docs", app, document);

  await app.listen(process.env.APP_PORT || 3000);
  console.log("API running on port", process.env.APP_PORT || 3000);
}

bootstrap();
```

---

# 9. AppModule

📌 `src/app.module.ts`

```ts
import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { PrismaModule } from "./database/prisma.module";
import { RedisModule } from "./redis/redis.module";
import { AuthModule } from "./modules/auth/auth.module";
import { UserModule } from "./modules/user/user.module";
import { HealthModule } from "./modules/health/health.module";

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    PrismaModule,
    RedisModule,
    AuthModule,
    UserModule,
    HealthModule
  ]
})
export class AppModule {}
```

---

# 10. Prisma Module

📌 `src/database/prisma.module.ts`

```ts
import { Global, Module } from "@nestjs/common";
import { PrismaService } from "./prisma.service";

@Global()
@Module({
  providers: [PrismaService],
  exports: [PrismaService]
})
export class PrismaModule {}
```

📌 `src/database/prisma.service.ts`

```ts
import { Injectable, OnModuleInit } from "@nestjs/common";
import { PrismaClient } from "@prisma/client";

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit {
  async onModuleInit() {
    await this.$connect();
  }
}
```

---

# 11. Redis Module

📌 `src/redis/redis.module.ts`

```ts
import { Global, Module } from "@nestjs/common";
import { RedisService } from "./redis.service";

@Global()
@Module({
  providers: [RedisService],
  exports: [RedisService]
})
export class RedisModule {}
```

📌 `src/redis/redis.service.ts`

```ts
import { Injectable, OnModuleDestroy } from "@nestjs/common";
import Redis from "ioredis";

@Injectable()
export class RedisService implements OnModuleDestroy {
  private client: Redis;

  constructor() {
    this.client = new Redis({
      host: process.env.REDIS_HOST,
      port: Number(process.env.REDIS_PORT || 6379),
      password: process.env.REDIS_PASSWORD || undefined
    });
  }

  getClient(): Redis {
    return this.client;
  }

  async onModuleDestroy() {
    await this.client.quit();
  }
}
```

---

# 12. 全局统一返回结构

📌 `src/common/interceptors/response.interceptor.ts`

```ts
import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler
} from "@nestjs/common";
import { Observable } from "rxjs";
import { map } from "rxjs/operators";

@Injectable()
export class ResponseInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      map((data) => ({
        code: 0,
        message: "success",
        data
      }))
    );
  }
}
```

---

# 13. 全局异常处理

📌 `src/common/filters/http-exception.filter.ts`

```ts
import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException
} from "@nestjs/common";

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();

    const status = exception instanceof HttpException ? exception.getStatus() : 500;
    const message =
      exception instanceof HttpException
        ? exception.message
        : "Internal Server Error";

    response.status(status).json({
      code: status,
      message,
      data: null
    });
  }
}
```

---

# 14. Auth 模块（JWT 登录 + RefreshToken）

📌 `src/modules/auth/auth.module.ts`

```ts
import { Module } from "@nestjs/common";
import { JwtModule } from "@nestjs/jwt";
import { PassportModule } from "@nestjs/passport";
import { AuthService } from "./auth.service";
import { AuthController } from "./auth.controller";
import { JwtStrategy } from "./jwt.strategy";

@Module({
  imports: [
    PassportModule,
    JwtModule.register({
      global: true,
      secret: process.env.JWT_ACCESS_SECRET,
      signOptions: { expiresIn: process.env.JWT_ACCESS_EXPIRE || "3600s" }
    })
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy]
})
export class AuthModule {}
```

📌 `src/modules/auth/auth.service.ts`

```ts
import { Injectable, UnauthorizedException } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import * as bcrypt from "bcrypt";
import { PrismaService } from "../../database/prisma.service";

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaService, private jwtService: JwtService) {}

  async login(username: string, password: string) {
    const user = await this.prisma.user.findUnique({
      where: { username },
      include: {
        roles: { include: { role: true } }
      }
    });

    if (!user) throw new UnauthorizedException("User not found");

    const ok = await bcrypt.compare(password, user.password);
    if (!ok) throw new UnauthorizedException("Password incorrect");

    const accessToken = await this.jwtService.signAsync({
      sub: user.id,
      username: user.username
    });

    return { accessToken };
  }
}
```

📌 `src/modules/auth/auth.controller.ts`

```ts
import { Body, Controller, Post } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { ApiTags } from "@nestjs/swagger";
import { IsString } from "class-validator";

class LoginDto {
  @IsString()
  username: string;

  @IsString()
  password: string;
}

@ApiTags("Auth")
@Controller("auth")
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post("login")
  async login(@Body() dto: LoginDto) {
    return this.authService.login(dto.username, dto.password);
  }
}
```

📌 `src/modules/auth/jwt.strategy.ts`

```ts
import { Injectable } from "@nestjs/common";
import { PassportStrategy } from "@nestjs/passport";
import { ExtractJwt, Strategy } from "passport-jwt";

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_ACCESS_SECRET
    });
  }

  async validate(payload: any) {
    return { userId: payload.sub, username: payload.username };
  }
}
```

---

# 15. User 模块（示例接口）

📌 `src/modules/user/user.module.ts`

```ts
import { Module } from "@nestjs/common";
import { UserController } from "./user.controller";
import { UserService } from "./user.service";

@Module({
  controllers: [UserController],
  providers: [UserService]
})
export class UserModule {}
```

📌 `src/modules/user/user.service.ts`

```ts
import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../database/prisma.service";

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async listUsers() {
    return this.prisma.user.findMany({
      select: { id: true, username: true, createdAt: true }
    });
  }
}
```

📌 `src/modules/user/user.controller.ts`

```ts
import { Controller, Get, UseGuards } from "@nestjs/common";
import { UserService } from "./user.service";
import { ApiBearerAuth, ApiTags } from "@nestjs/swagger";
import { AuthGuard } from "@nestjs/passport";

@ApiTags("User")
@ApiBearerAuth()
@Controller("users")
export class UserController {
  constructor(private userService: UserService) {}

  @UseGuards(AuthGuard("jwt"))
  @Get()
  async listUsers() {
    return this.userService.listUsers();
  }
}
```

---

# 16. Health 模块（服务健康检查）

📌 `src/modules/health/health.module.ts`

```ts
import { Module } from "@nestjs/common";
import { HealthController } from "./health.controller";

@Module({
  controllers: [HealthController]
})
export class HealthModule {}
```

📌 `src/modules/health/health.controller.ts`

```ts
import { Controller, Get } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";

@ApiTags("Health")
@Controller("health")
export class HealthController {
  @Get()
  check() {
    return { status: "ok", time: new Date().toISOString() };
  }
}
```

---

# 17. README.md（运行方式）

📌 `README.md`

````md
# NestJS Enterprise Template

## Features
- NestJS + TypeScript
- Prisma + PostgreSQL
- Redis
- JWT Auth
- RBAC DB Design
- Swagger Docs
- Docker Compose

## Run with Docker
```bash
docker compose up -d --build
````

## Run Prisma Migration

```bash
npm install
npx prisma generate
npx prisma migrate dev
npm run seed
```

## Start

```bash
npm run start:dev
```

Swagger: [http://localhost:3000/docs](http://localhost:3000/docs)

Login:
POST /auth/login
{
"username": "admin",
"password": "admin123"
}

````

---

# 18. 启动步骤（最重要）

## ✅ 方式 A：Docker 一键启动
```bash
docker compose up -d --build
````

然后进入容器执行 migration：

```bash
docker exec -it nest_api sh
npx prisma migrate dev
npm run seed
```

---

## ✅ 方式 B：本地运行（推荐开发）

1）启动 Postgres + Redis

```bash
docker compose up -d postgres redis
```

2）安装依赖

```bash
npm install
```

3）Prisma 初始化

```bash
npx prisma generate
npx prisma migrate dev
npm run seed
```

4）启动

```bash
npm run start:dev
```

---

# 19. 测试接口

### 1）健康检查

GET

```
http://localhost:3000/health
```

### 2）登录

POST

```
http://localhost:3000/auth/login
```

body:

```json
{
  "username": "admin",
  "password": "admin123"
}
```

### 3）获取用户列表（带 token）

GET

```
http://localhost:3000/users
```

header:

```
Authorization: Bearer <accessToken>
```

---

# 20. 下一步可升级（真正生产级）

如果你想更企业级，我可以继续补齐：

* RefreshToken + Token 黑名单（Redis）
* RBAC Guard（@Permissions 装饰器）
* 用户注册 / 修改密码 / 登出
* API 访问日志（Winston）
* TraceId 链路追踪
* 分页封装 / 通用 CRUD
* 单元测试 + e2e 测试
* GitLab CI/CD + Docker 镜像发布

---

如果你希望我直接给你**完整源码并打包成 zip 可下载**（像你之前 FastAPI 那样），我也可以直接生成一个 zip。你要 zip 版本还是复制粘贴版本？


已生成 **NestJS 企业级项目模板完整源码**（JWT + Prisma + PostgreSQL + Redis + Swagger + Docker Compose），并打包成 zip。

📦 **下载地址：**
[Download nestjs-enterprise-template.zip](sandbox:/mnt/data/nestjs-enterprise-template.zip)

运行方式（最简单）：

```bash
docker compose up -d --build
```

本地开发模式：

```bash
docker compose up -d postgres redis
npm install
npx prisma generate
npx prisma migrate dev
npm run seed
npm run start:dev
```

Swagger 文档：

```
http://localhost:3000/docs
```

默认管理员账号：

* username: `admin`
* password: `admin123`
