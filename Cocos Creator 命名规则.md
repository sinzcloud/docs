下面给你一套**适合 Cocos Creator 3.x 棋牌项目（game 下有 ddz 和 mj）**的标准目录结构 + 命名规则（企业常用），你直接照搬就行。

---

# 一、推荐目录结构（模块优先）

```txt
assets/
  common/                  # 公共模块（所有模块共用）
    textures/
    prefabs/
    scripts/
    audio/
    animations/
    fonts/

  login/                   # 登录模块
    scenes/
    prefabs/
    scripts/
    textures/

  hall/                    # 大厅模块
    scenes/
    prefabs/
    scripts/
    textures/
    audio/

  room/                    # 房间模块（匹配/创建房间/座位）
    scenes/
    prefabs/
    scripts/
    textures/
    audio/

  game/                    # 游戏模块合集
    ddz/                   # 斗地主
      scenes/
      prefabs/
      scripts/
      textures/
      audio/
      animations/

    mj/                    # 麻将
      scenes/
      prefabs/
      scripts/
      textures/
      audio/
      animations/

  net/                     # 网络模块（公共网络通信）
    scripts/

  config/                  # 配置模块（表、常量、枚举）
    scripts/
```

---

# 二、每个目录放什么（结构介绍）

## `common/`

放所有模块都会用到的东西，例如：

* 通用弹窗 `Alert`
* Loading
* 通用按钮、图标
* 音效 click
* EventBus、Utils、AudioManager

---

## `login/`

放登录界面相关：

* 登录场景
* 登录 UI prefab
* 登录脚本

---

## `hall/`

大厅相关：

* 大厅场景
* 个人信息、背包、公告、排行榜等 prefab
* 大厅音乐 bgm

---

## `room/`

房间相关：

* 房间场景（匹配/创建房间/准备）
* 座位 Seat prefab
* 玩家信息面板 prefab
* 房间脚本逻辑

---

## `game/ddz`

斗地主游戏内容：

* 斗地主游戏场景
* 牌、手牌、出牌区 prefab
* 发牌/出牌动画
* 斗地主音效

---

## `game/mj`

麻将游戏内容：

* 麻将游戏场景
* 牌面、手牌、碰杠胡区域 prefab
* 麻将音效/动画

---

## `net/`

网络通信统一放这里：

* WebSocket 管理
* 消息路由 dispatcher
* proto/json 编解码

---

## `config/`

配置类、常量、枚举：

* 游戏状态枚举
* cmd 常量
* 配置表加载

---

# 三、命名规则（资源命名）

## 1）Scene 场景命名

规则：`sc_模块_名称`

例子：

* `sc_login`
* `sc_hall`
* `sc_room`
* `sc_ddz_game`
* `sc_mj_game`

---

## 2）Prefab 预制体命名

规则：`pf_模块_名称`

例子：

* `pf_common_loading`
* `pf_common_alert`
* `pf_room_seat`
* `pf_ddz_cardItem`
* `pf_ddz_handCards`
* `pf_mj_tileItem`
* `pf_mj_handTiles`

---

## 3）图片命名（Texture / Sprite）

规则：`img_模块_用途_状态`

例子：

* `img_common_btn_ok`
* `img_common_btn_ok_disable`
* `img_hall_bg`
* `img_ddz_card_back`
* `img_mj_tile_1w`

---

## 4）图集命名（Atlas）

规则：`atlas_模块_分类`

例子：

* `atlas_common_ui`
* `atlas_ddz_cards`
* `atlas_mj_tiles`

---

## 5）动画 Animation Clip 命名

规则：`anim_模块_动作`

例子：

* `anim_loading_rotate`
* `anim_popup_open`
* `anim_ddz_deal`
* `anim_mj_peng`

---

## 6）音频命名

规则：

* 背景音乐：`bgm_模块_名称`
* 音效：`sfx_模块_名称`

例子：

* `bgm_hall`
* `bgm_ddz`
* `bgm_mj`
* `sfx_click`
* `sfx_ddz_deal`
* `sfx_mj_draw`

---

## 7）字体命名

规则：`font_用途_风格`

例子：

* `font_main`
* `font_number`
* `font_bold`

---

# 四、脚本命名规则（TS）

## 1）文件名 / 类名

规则：**PascalCase（大驼峰）**，文件名=类名

例子：

* `LoadingView.ts`
* `AlertView.ts`
* `RoomController.ts`
* `DdzGameController.ts`
* `MjGameController.ts`

---

## 2）脚本后缀规范（强烈推荐）

| 后缀           | 用途      |
| ------------ | ------- |
| `View`       | UI 界面组件 |
| `Controller` | 场景控制器   |
| `Manager`    | 全局管理器   |
| `Service`    | 网络/业务服务 |
| `Model`      | 数据对象    |
| `Config`     | 配置类     |
| `Util`       | 工具类     |

---

# 五、Hierarchy 节点命名规则（UI节点）

## 节点前缀（必须统一）

| 前缀        | 含义           |
| --------- | ------------ |
| `nd`      | 普通节点         |
| `panel`   | 面板           |
| `mask`    | 遮罩           |
| `bg`      | 背景           |
| `btn`     | 按钮           |
| `lbl`     | 文本           |
| `spr`     | Sprite       |
| `img`     | 图片 Sprite    |
| `scroll`  | ScrollView   |
| `content` | ScrollView内容 |
| `item`    | 列表项          |
| `eff`     | 特效节点         |

---

## 示例（弹窗）

```txt
pf_common_alert
 ├─ mask
 └─ panel
     ├─ lblTitle
     ├─ lblContent
     ├─ btnOk
     └─ btnCancel
```

---

## 示例（斗地主手牌）

```txt
pf_ddz_handCards
 ├─ content
 │   ├─ pf_ddz_cardItem
 │   ├─ pf_ddz_cardItem
 │   └─ ...
 └─ btnTips
```

---

# 六、代码变量命名规则

规则：小驼峰 + 节点前缀

```ts
@property(Node)
btnOk: Node = null!;

@property(Label)
lblTitle: Label = null!;

@property(Sprite)
sprIcon: Sprite = null!;
```

---

# 七、事件/消息命名规则

规则：全大写 + 模块前缀

```ts
export const EVT_ROOM_ENTER = "EVT_ROOM_ENTER";
export const EVT_DDZ_GAME_START = "EVT_DDZ_GAME_START";
export const EVT_MJ_HU = "EVT_MJ_HU";
```

---

# 八、最终推荐（你项目直接用这套）

✅ `assets/game/ddz` 和 `assets/game/mj` 独立模块
✅ `common` 放公共 UI 和公共工具
✅ 所有资源统一前缀：`sc_ / pf_ / img_ / atlas_ / anim_ / bgm_ / sfx_`
✅ 脚本统一大驼峰，按 View/Controller/Manager/Service 分层

如果你要，我可以直接给你画一套 **斗地主/麻将 prefab 组件拆分清单**（Seat、Hand、OutArea、Effect、Popup）方便你直接开工。
