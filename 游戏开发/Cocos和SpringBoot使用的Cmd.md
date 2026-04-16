下面我直接给你生成两份 **可直接复制使用**的文件：

* `Cmd.ts`（Cocos Creator 客户端用）
* `Cmd.java`（Spring Boot 后端用）

内容保持一致，方便前后端对齐。

---

# 1）Cmd.ts（Cocos Creator 客户端）

```ts
// Cmd.ts
// 前后端协议 CMD 常量表（WebSocket/Push）
// 建议：客户端与服务端保持同一份编号

export class Cmd {

  // ===========================
  // 1000-1099 System
  // ===========================
  static readonly SYS_CONNECT = 1000;
  static readonly SYS_HEARTBEAT = 1001;
  static readonly SYS_AUTH = 1002;
  static readonly SYS_KICK = 1003;
  static readonly SYS_CLIENT_INFO = 1004;
  static readonly SYS_TIME_SYNC = 1005;
  static readonly SYS_RECONNECT = 1006;
  static readonly SYS_RECONNECT_RESULT = 1007;
  static readonly SYS_CHANGE_SERVER = 1008;
  static readonly SYS_NETWORK_TEST = 1009;
  static readonly SYS_PING = 1010;
  static readonly SYS_PONG = 1011;
  static readonly SYS_SET_LANGUAGE = 1012;
  static readonly SYS_SET_REGION = 1013;
  static readonly SYS_SET_DEVICE = 1014;
  static readonly SYS_SET_PUSH_TOKEN = 1015;
  static readonly SYS_CLIENT_LOG_UPLOAD = 1016;
  static readonly SYS_SERVER_NOTICE_PULL = 1017;
  static readonly SYS_MAINTAIN_INFO = 1018;
  static readonly SYS_FORCE_UPDATE = 1019;
  static readonly SYS_ERROR_REPORT = 1020;
  static readonly SYS_RATE_LIMIT = 1021;
  static readonly SYS_PROTO_VERSION = 1022;
  static readonly SYS_ENCRYPT_KEY = 1023;
  static readonly SYS_KEEP_ALIVE = 1024;
  static readonly SYS_CLIENT_READY = 1025;

  // ===========================
  // 1100-1199 User
  // ===========================
  static readonly USER_INFO_GET = 1100;
  static readonly USER_INFO_UPDATE = 1101;
  static readonly USER_LEVEL_UP = 1102;
  static readonly USER_EXP_SYNC = 1103;
  static readonly USER_CURRENCY_SYNC = 1104;
  static readonly USER_VIP_SYNC = 1105;
  static readonly USER_BIND_PHONE = 1106;
  static readonly USER_BIND_EMAIL = 1107;
  static readonly USER_REALNAME_VERIFY = 1108;
  static readonly USER_LOGIN_RECORD = 1109;
  static readonly USER_ONLINE_QUERY = 1110;
  static readonly USER_ONLINE_PUSH = 1111;
  static readonly USER_LOGOUT = 1112;
  static readonly USER_ACCOUNT_FREEZE = 1113;
  static readonly USER_ACCOUNT_UNFREEZE = 1114;
  static readonly USER_AVATAR_SET = 1115;
  static readonly USER_SIGN_IN = 1116;
  static readonly USER_SIGN_IN_INFO = 1117;
  static readonly USER_RED_DOT_SYNC = 1118;
  static readonly USER_PROFILE_CARD = 1119;
  static readonly USER_GPS_UPLOAD = 1120;
  static readonly USER_IP_REPORT = 1121;
  static readonly USER_PRIVACY_SET = 1122;
  static readonly USER_SETTING_GET = 1123;
  static readonly USER_SETTING_SET = 1124;
  static readonly USER_CLIENT_BIND = 1125;

  // ===========================
  // 1200-1299 Hall
  // ===========================
  static readonly HALL_ENTER = 1200;
  static readonly HALL_EXIT = 1201;
  static readonly HALL_INIT_DATA = 1202;
  static readonly HALL_BANNER_LIST = 1203;
  static readonly HALL_NOTICE_LIST = 1204;
  static readonly HALL_NOTICE_READ = 1205;
  static readonly HALL_ROOM_LIST = 1206;
  static readonly HALL_MODE_LIST = 1207;
  static readonly HALL_RECOMMEND_LIST = 1208;
  static readonly HALL_RANK_LIST = 1209;
  static readonly HALL_RANK_DETAIL = 1210;
  static readonly HALL_ONLINE_COUNT = 1211;
  static readonly HALL_SERVER_LIST = 1212;
  static readonly HALL_SERVER_SELECT = 1213;
  static readonly HALL_DAILY_REWARD = 1214;
  static readonly HALL_ACTIVITY_LIST = 1215;
  static readonly HALL_MATCH_RULES = 1216;
  static readonly HALL_GAME_LIST = 1217;
  static readonly HALL_GAME_ENTER = 1218;
  static readonly HALL_GAME_EXIT = 1219;
  static readonly HALL_PLAYER_LIST = 1220;
  static readonly HALL_FRIEND_RECOMMEND = 1221;
  static readonly HALL_AD_CONFIG = 1222;
  static readonly HALL_AD_REPORT = 1223;
  static readonly HALL_TASK_INFO = 1224;
  static readonly HALL_SYSTEM_CONFIG = 1225;
  static readonly HALL_PATCH_INFO = 1226;
  static readonly HALL_VERSION_CHECK = 1227;
  static readonly HALL_RESOURCE_CDN = 1228;
  static readonly HALL_MOTD = 1229;

  // ===========================
  // 1300-1399 Match
  // ===========================
  static readonly MATCH_START = 1300;
  static readonly MATCH_CANCEL = 1301;
  static readonly MATCH_STATUS_QUERY = 1302;
  static readonly MATCH_CONFIRM = 1303;
  static readonly MATCH_CONFIRM_CANCEL = 1304;
  static readonly MATCH_SET_LEVEL = 1305;
  static readonly MATCH_SET_MODE = 1306;
  static readonly MATCH_SET_GAME_TYPE = 1307;
  static readonly MATCH_RETRY = 1308;
  static readonly MATCH_FAST_JOIN = 1309;
  static readonly MATCH_INVITE_JOIN = 1310;
  static readonly MATCH_TEAM_CREATE = 1311;
  static readonly MATCH_TEAM_JOIN = 1312;
  static readonly MATCH_TEAM_LEAVE = 1313;
  static readonly MATCH_TEAM_KICK = 1314;
  static readonly MATCH_TEAM_READY = 1315;
  static readonly MATCH_TEAM_UNREADY = 1316;
  static readonly MATCH_TEAM_CHAT = 1317;
  static readonly MATCH_TEAM_INFO = 1318;
  static readonly MATCH_TEAM_DISSOLVE = 1319;
  static readonly MATCH_QUEUE_INFO = 1320;
  static readonly MATCH_ESTIMATE_TIME = 1321;
  static readonly MATCH_REGION_SET = 1322;
  static readonly MATCH_AI_FILL = 1323;
  static readonly MATCH_PING_TEST = 1324;

  // ===========================
  // 1400-1499 Room
  // ===========================
  static readonly ROOM_CREATE = 1400;
  static readonly ROOM_JOIN = 1401;
  static readonly ROOM_LEAVE = 1402;
  static readonly ROOM_READY = 1403;
  static readonly ROOM_UNREADY = 1404;
  static readonly ROOM_KICK_PLAYER = 1405;
  static readonly ROOM_CHANGE_OWNER = 1406;
  static readonly ROOM_SET_RULE = 1407;
  static readonly ROOM_GET_RULE = 1408;
  static readonly ROOM_INFO = 1409;
  static readonly ROOM_PLAYER_LIST = 1410;
  static readonly ROOM_SEAT_CHANGE = 1411;
  static readonly ROOM_SEAT_LOCK = 1412;
  static readonly ROOM_SEAT_UNLOCK = 1413;
  static readonly ROOM_CHAT = 1414;
  static readonly ROOM_EMOJI = 1415;
  static readonly ROOM_VOICE = 1416;
  static readonly ROOM_GPS_SYNC = 1417;
  static readonly ROOM_DISSOLVE_REQUEST = 1418;
  static readonly ROOM_DISSOLVE_VOTE = 1419;
  static readonly ROOM_DISSOLVE_RESULT = 1420;
  static readonly ROOM_START_GAME = 1421;
  static readonly ROOM_CANCEL_START = 1422;
  static readonly ROOM_PLAYER_OFFLINE = 1423;
  static readonly ROOM_PLAYER_ONLINE = 1424;
  static readonly ROOM_RECONNECT_SNAPSHOT = 1425;
  static readonly ROOM_TIME_SYNC = 1426;
  static readonly ROOM_SET_PASSWORD = 1427;
  static readonly ROOM_UNLOCK_PASSWORD = 1428;
  static readonly ROOM_INVITE_CODE = 1429;
  static readonly ROOM_INVITE_ACCEPT = 1430;
  static readonly ROOM_INVITE_REJECT = 1431;
  static readonly ROOM_CHANGE_MODE = 1432;
  static readonly ROOM_CHANGE_GAME = 1433;
  static readonly ROOM_ROBOT_ADD = 1434;
  static readonly ROOM_ROBOT_REMOVE = 1435;
  static readonly ROOM_SPECTATOR_JOIN = 1436;
  static readonly ROOM_SPECTATOR_LEAVE = 1437;
  static readonly ROOM_SPECTATOR_LIST = 1438;
  static readonly ROOM_HOST_HEARTBEAT = 1439;
  static readonly ROOM_FORCE_CLOSE = 1440;
  static readonly ROOM_TABLE_INFO = 1441;
  static readonly ROOM_PLAYER_INFO = 1442;
  static readonly ROOM_PLAYER_SCORE_SYNC = 1443;
  static readonly ROOM_RULE_VALIDATE = 1444;
  static readonly ROOM_CUSTOM_PROP_SET = 1445;
  static readonly ROOM_CUSTOM_PROP_GET = 1446;

  // ===========================
  // 1500-1599 Social/Chat
  // ===========================
  static readonly CHAT_PRIVATE_SEND = 1500;
  static readonly CHAT_PRIVATE_PULL = 1501;
  static readonly CHAT_PRIVATE_READ = 1502;
  static readonly CHAT_WORLD_SEND = 1503;
  static readonly CHAT_WORLD_PULL = 1504;
  static readonly CHAT_ROOM_SEND = 1505;
  static readonly CHAT_SYSTEM_PULL = 1506;
  static readonly CHAT_QUICK_MSG = 1507;
  static readonly CHAT_REPORT_PLAYER = 1508;
  static readonly CHAT_BLOCK_PLAYER = 1509;
  static readonly CHAT_UNBLOCK_PLAYER = 1510;
  static readonly FRIEND_LIST = 1511;
  static readonly FRIEND_ADD_REQUEST = 1512;
  static readonly FRIEND_ADD_ACCEPT = 1513;
  static readonly FRIEND_ADD_REJECT = 1514;
  static readonly FRIEND_DELETE = 1515;
  static readonly FRIEND_REMARK_SET = 1516;
  static readonly FRIEND_ONLINE_STATUS = 1517;
  static readonly FRIEND_GIFT_SEND = 1518;
  static readonly FRIEND_GIFT_LIST = 1519;
  static readonly FRIEND_INVITE_ROOM = 1520;
  static readonly FRIEND_INVITE_GAME = 1521;
  static readonly FRIEND_APPLY_LIST = 1522;
  static readonly FRIEND_SEARCH = 1523;
  static readonly FRIEND_RECOMMEND = 1524;

  // ===========================
  // 1600-1699 Mail/Bag/Shop
  // ===========================
  static readonly MAIL_LIST = 1600;
  static readonly MAIL_READ = 1601;
  static readonly MAIL_REWARD_CLAIM = 1602;
  static readonly MAIL_DELETE = 1603;
  static readonly BAG_LIST = 1604;
  static readonly BAG_USE_ITEM = 1605;
  static readonly BAG_SELL_ITEM = 1606;
  static readonly BAG_ITEM_SYNC = 1607;
  static readonly SHOP_LIST = 1608;
  static readonly SHOP_BUY = 1609;
  static readonly SHOP_ORDER_QUERY = 1610;
  static readonly SHOP_RECHARGE = 1611;
  static readonly SHOP_RECHARGE_RESULT = 1612;
  static readonly SHOP_VIP_GIFT = 1613;
  static readonly SHOP_FIRST_RECHARGE = 1614;
  static readonly SHOP_LIMIT_LIST = 1615;
  static readonly SHOP_LIMIT_BUY = 1616;
  static readonly SHOP_AD_REWARD = 1617;
  static readonly SHOP_CURRENCY_EXCHANGE = 1618;
  static readonly SHOP_GIFT_CODE_REDEEM = 1619;
  static readonly SHOP_SUBSCRIPTION_INFO = 1620;
  static readonly SHOP_SUBSCRIPTION_BUY = 1621;
  static readonly SHOP_SUBSCRIPTION_CANCEL = 1622;

  // ===========================
  // 1700-1799 Record/Replay
  // ===========================
  static readonly RECORD_LIST = 1700;
  static readonly RECORD_DETAIL = 1701;
  static readonly RECORD_SHARE = 1702;
  static readonly RECORD_DELETE = 1703;
  static readonly REPLAY_LIST = 1704;
  static readonly REPLAY_DETAIL = 1705;
  static readonly REPLAY_DOWNLOAD = 1706;
  static readonly REPLAY_PLAY_START = 1707;
  static readonly REPLAY_PLAY_STOP = 1708;
  static readonly REPLAY_FRAME_SYNC = 1709;
  static readonly REPLAY_FAST_FORWARD = 1710;
  static readonly REPLAY_REWIND = 1711;
  static readonly REPLAY_PAUSE = 1712;
  static readonly REPLAY_RESUME = 1713;
  static readonly RECORD_RANK_SYNC = 1714;
  static readonly RECORD_EXPORT = 1715;

  // ===========================
  // 1800-1899 Activity/Task
  // ===========================
  static readonly ACTIVITY_LIST = 1800;
  static readonly ACTIVITY_DETAIL = 1801;
  static readonly ACTIVITY_CLAIM = 1802;
  static readonly TASK_LIST = 1803;
  static readonly TASK_PROGRESS_SYNC = 1804;
  static readonly TASK_CLAIM = 1805;
  static readonly TASK_DAILY_RESET = 1806;
  static readonly TASK_WEEKLY_RESET = 1807;
  static readonly ACHIEVEMENT_LIST = 1808;
  static readonly ACHIEVEMENT_CLAIM = 1809;
  static readonly ACTIVITY_RANK_LIST = 1810;
  static readonly ACTIVITY_INVITE = 1811;
  static readonly ACTIVITY_INVITE_REWARD = 1812;
  static readonly ACTIVITY_SIGNIN = 1813;
  static readonly ACTIVITY_SIGNIN_CLAIM = 1814;
  static readonly ACTIVITY_LIMIT_TIME = 1815;

  // ===========================
  // 1900-1999 GM
  // ===========================
  static readonly GM_BROADCAST = 1900;
  static readonly GM_KICK_PLAYER = 1901;
  static readonly GM_BAN_PLAYER = 1902;
  static readonly GM_UNBAN_PLAYER = 1903;
  static readonly GM_MUTE_PLAYER = 1904;
  static readonly GM_UNMUTE_PLAYER = 1905;
  static readonly GM_ADD_CURRENCY = 1906;
  static readonly GM_ADD_ITEM = 1907;
  static readonly GM_RESET_ROOM = 1908;
  static readonly GM_QUERY_PLAYER = 1909;
  static readonly GM_QUERY_ROOM = 1910;
  static readonly GM_FORCE_FINISH_GAME = 1911;
  static readonly GM_LOG_QUERY = 1912;
  static readonly GM_SERVER_STATUS = 1913;
  static readonly GM_MAINTAIN_SET = 1914;
  static readonly GM_MAINTAIN_CANCEL = 1915;
  static readonly GM_CONFIG_RELOAD = 1916;

  // ===========================
  // 2000-2399 DDZ 斗地主
  // ===========================
  static readonly DDZ_ENTER = 2000;
  static readonly DDZ_EXIT = 2001;
  static readonly DDZ_GAME_START = 2002;
  static readonly DDZ_DEAL_CARDS = 2003;
  static readonly DDZ_SHOW_HAND = 2004;
  static readonly DDZ_CALL_SCORE = 2005;
  static readonly DDZ_CALL_SCORE_RESULT = 2006;
  static readonly DDZ_GRAB_LANDLORD = 2007;
  static readonly DDZ_GRAB_RESULT = 2008;
  static readonly DDZ_LANDLORD_CONFIRM = 2009;
  static readonly DDZ_BOTTOM_CARDS_SHOW = 2010;
  static readonly DDZ_MULTIPLIER_SYNC = 2011;
  static readonly DDZ_TURN_NOTIFY = 2012;
  static readonly DDZ_PLAY_CARDS = 2013;
  static readonly DDZ_PLAY_RESULT = 2014;
  static readonly DDZ_PASS = 2015;
  static readonly DDZ_PASS_RESULT = 2016;
  static readonly DDZ_HINT_REQUEST = 2017;
  static readonly DDZ_HINT_RESULT = 2018;
  static readonly DDZ_BOMB_NOTIFY = 2019;
  static readonly DDZ_ROCKET_NOTIFY = 2020;
  static readonly DDZ_SPRING_NOTIFY = 2021;
  static readonly DDZ_GAME_OVER = 2022;
  static readonly DDZ_SCORE_SYNC = 2023;
  static readonly DDZ_ROOM_SNAPSHOT = 2024;
  static readonly DDZ_TIMEOUT_AUTO_PLAY = 2025;
  static readonly DDZ_TRUSTEE_SET = 2026;
  static readonly DDZ_TRUSTEE_CANCEL = 2027;
  static readonly DDZ_CHAT_QUICK = 2028;
  static readonly DDZ_EMOJI = 2029;
  static readonly DDZ_VOICE = 2030;
  static readonly DDZ_RULE_SYNC = 2031;
  static readonly DDZ_CARD_COUNT_SYNC = 2032;
  static readonly DDZ_LAST_PLAY_SYNC = 2033;
  static readonly DDZ_GAME_PAUSE = 2034;
  static readonly DDZ_GAME_RESUME = 2035;
  static readonly DDZ_RECONNECT = 2036;
  static readonly DDZ_RECONNECT_RESULT = 2037;
  static readonly DDZ_DOUBLE_REQUEST = 2038;
  static readonly DDZ_DOUBLE_RESULT = 2039;
  static readonly DDZ_AUTO_HINT = 2040;
  static readonly DDZ_PLAY_INVALID = 2041;
  static readonly DDZ_PLAY_CONFIRM = 2042;
  static readonly DDZ_TURN_TIMER_SYNC = 2043;
  static readonly DDZ_BASE_SCORE_SYNC = 2044;
  static readonly DDZ_TASK_TRIGGER = 2045;
  static readonly DDZ_PLAYER_STAT_SYNC = 2046;
  static readonly DDZ_GAME_LOG = 2047;
  static readonly DDZ_TEST_CMD = 2048;

  static readonly DDZ_RANK_INFO = 2200;
  static readonly DDZ_RANK_MATCH_START = 2201;
  static readonly DDZ_RANK_MATCH_RESULT = 2202;
  static readonly DDZ_SEASON_INFO = 2203;
  static readonly DDZ_SEASON_REWARD = 2204;
  static readonly DDZ_ACHIEVEMENT_SYNC = 2205;
  static readonly DDZ_MVP_SYNC = 2206;
  static readonly DDZ_SPECIAL_EFFECT = 2207;
  static readonly DDZ_SKIN_LIST = 2208;
  static readonly DDZ_SKIN_SET = 2209;
  static readonly DDZ_CARD_BACK_SET = 2210;
  static readonly DDZ_TABLE_THEME_SET = 2211;
  static readonly DDZ_SHARE_RESULT = 2212;
  static readonly DDZ_REWARD_AD_CLAIM = 2213;
  static readonly DDZ_REPORT_CHEAT = 2214;
  static readonly DDZ_ANTI_CHEAT_SYNC = 2215;
  static readonly DDZ_OBSERVER_JOIN = 2216;
  static readonly DDZ_OBSERVER_LEAVE = 2217;
  static readonly DDZ_OBSERVER_LIST = 2218;
  static readonly DDZ_RECORD_UPLOAD = 2219;
  static readonly DDZ_REPLAY_UPLOAD = 2220;
  static readonly DDZ_REPLAY_READY = 2221;
  static readonly DDZ_TABLE_INFO = 2222;
  static readonly DDZ_TABLE_STATE_SYNC = 2223;
  static readonly DDZ_EVENT_TRIGGER = 2224;
  static readonly DDZ_DAILY_REWARD = 2225;
  static readonly DDZ_WEEKLY_REWARD = 2226;
  static readonly DDZ_MONTHLY_REWARD = 2227;
  static readonly DDZ_ROOM_CHAT = 2228;
  static readonly DDZ_PLAYER_INFO_SYNC = 2229;
  static readonly DDZ_FRIEND_INVITE = 2230;
  static readonly DDZ_AI_DIFFICULTY_SET = 2231;
  static readonly DDZ_AI_STATE_SYNC = 2232;
  static readonly DDZ_GAME_CONFIG_SYNC = 2233;
  static readonly DDZ_CLIENT_DEBUG = 2234;
  static readonly DDZ_SERVER_DEBUG = 2235;

  // ===========================
  // 3000-3399 MJ 麻将
  // ===========================
  static readonly MJ_ENTER = 3000;
  static readonly MJ_EXIT = 3001;
  static readonly MJ_GAME_START = 3002;
  static readonly MJ_DEAL_TILES = 3003;
  static readonly MJ_DRAW_TILE = 3004;
  static readonly MJ_DISCARD_TILE = 3005;
  static readonly MJ_DISCARD_RESULT = 3006;
  static readonly MJ_ACTION_HINT = 3007;
  static readonly MJ_ACTION_REQUEST = 3008;
  static readonly MJ_ACTION_RESULT = 3009;
  static readonly MJ_CHI_REQUEST = 3010;
  static readonly MJ_PENG_REQUEST = 3011;
  static readonly MJ_GANG_REQUEST = 3012;
  static readonly MJ_HU_REQUEST = 3013;
  static readonly MJ_TING_REQUEST = 3014;
  static readonly MJ_TING_RESULT = 3015;
  static readonly MJ_PASS = 3016;
  static readonly MJ_PASS_RESULT = 3017;
  static readonly MJ_TURN_NOTIFY = 3018;
  static readonly MJ_WALL_COUNT_SYNC = 3019;
  static readonly MJ_FLOWER_DRAW = 3020;
  static readonly MJ_FLOWER_SYNC = 3021;
  static readonly MJ_SCORE_SYNC = 3022;
  static readonly MJ_GAME_OVER = 3023;
  static readonly MJ_ROOM_SNAPSHOT = 3024;
  static readonly MJ_TIMEOUT_AUTO_PLAY = 3025;
  static readonly MJ_TRUSTEE_SET = 3026;
  static readonly MJ_TRUSTEE_CANCEL = 3027;
  static readonly MJ_CHAT_QUICK = 3028;
  static readonly MJ_EMOJI = 3029;
  static readonly MJ_VOICE = 3030;
  static readonly MJ_RULE_SYNC = 3031;
  static readonly MJ_DORA_SYNC = 3032;
  static readonly MJ_RECONNECT = 3033;
  static readonly MJ_RECONNECT_RESULT = 3034;
  static readonly MJ_TURN_TIMER_SYNC = 3035;
  static readonly MJ_READY_HAND_HINT = 3036;
  static readonly MJ_LAST_DISCARD_SYNC = 3037;
  static readonly MJ_DISCARD_INVALID = 3038;
  static readonly MJ_ACTION_PRIORITY = 3039;
  static readonly MJ_GAME_LOG = 3040;

  static readonly MJ_SEASON_INFO = 3200;
  static readonly MJ_SEASON_REWARD = 3201;
  static readonly MJ_RANK_INFO = 3202;
  static readonly MJ_RANK_MATCH_START = 3203;
  static readonly MJ_RANK_MATCH_RESULT = 3204;
  static readonly MJ_SPECIAL_HAND_NOTIFY = 3205;
  static readonly MJ_GANG_SCORE_SYNC = 3206;
  static readonly MJ_PIAO_FEN_REQUEST = 3207;
  static readonly MJ_PIAO_FEN_RESULT = 3208;
  static readonly MJ_ZHUANG_NOTIFY = 3209;
  static readonly MJ_CONTINUE_BANKER = 3210;
  static readonly MJ_PLAYER_STAT_SYNC = 3211;
  static readonly MJ_MVP_SYNC = 3212;
  static readonly MJ_SKIN_LIST = 3213;
  static readonly MJ_SKIN_SET = 3214;
  static readonly MJ_TILE_BACK_SET = 3215;
  static readonly MJ_TABLE_THEME_SET = 3216;
  static readonly MJ_SHARE_RESULT = 3217;
  static readonly MJ_REWARD_AD_CLAIM = 3218;
  static readonly MJ_REPORT_CHEAT = 3219;
  static readonly MJ_ANTI_CHEAT_SYNC = 3220;
  static readonly MJ_OBSERVER_JOIN = 3221;
  static readonly MJ_OBSERVER_LEAVE = 3222;
  static readonly MJ_OBSERVER_LIST = 3223;
  static readonly MJ_RECORD_UPLOAD = 3224;
  static readonly MJ_REPLAY_UPLOAD = 3225;
  static readonly MJ_REPLAY_READY = 3226;
  static readonly MJ_EVENT_TRIGGER = 3227;
  static readonly MJ_GAME_CONFIG_SYNC = 3228;
  static readonly MJ_AI_DIFFICULTY_SET = 3229;
  static readonly MJ_AI_STATE_SYNC = 3230;

  // ===========================
  // 9000-9099 System Push
  // ===========================
  static readonly PUSH_SERVER_BROADCAST = 9000;
  static readonly PUSH_SYSTEM_NOTICE = 9001;
  static readonly PUSH_MAINTAIN_NOTICE = 9002;
  static readonly PUSH_KICK = 9003;
  static readonly PUSH_FORCE_LOGOUT = 9004;
  static readonly PUSH_CURRENCY_CHANGE = 9005;
  static readonly PUSH_LEVEL_UP = 9006;
  static readonly PUSH_MAIL_NEW = 9007;
  static readonly PUSH_ACTIVITY_UPDATE = 9008;
  static readonly PUSH_TASK_UPDATE = 9009;
  static readonly PUSH_FRIEND_ONLINE = 9010;
  static readonly PUSH_FRIEND_OFFLINE = 9011;
  static readonly PUSH_CHAT_WORLD = 9012;
  static readonly PUSH_CHAT_PRIVATE = 9013;
  static readonly PUSH_CHAT_ROOM = 9014;
  static readonly PUSH_ROOM_INVITE = 9015;
  static readonly PUSH_MATCH_FOUND = 9016;
  static readonly PUSH_PAYMENT_SUCCESS = 9017;
  static readonly PUSH_PAYMENT_FAILED = 9018;
  static readonly PUSH_ACCOUNT_FREEZE = 9019;
  static readonly PUSH_ACCOUNT_UNFREEZE = 9020;
  static readonly PUSH_CONFIG_RELOAD = 9021;
  static readonly PUSH_SERVER_TIME = 9022;
  static readonly PUSH_RED_DOT_SYNC = 9023;
  static readonly PUSH_RESOURCE_UPDATE = 9024;
  static readonly PUSH_CUSTOM_MESSAGE = 9025;

  // ===========================
  // 9100-9199 Room Push
  // ===========================
  static readonly PUSH_ROOM_CREATED = 9100;
  static readonly PUSH_ROOM_JOINED = 9101;
  static readonly PUSH_ROOM_LEFT = 9102;
  static readonly PUSH_ROOM_READY_CHANGED = 9103;
  static readonly PUSH_ROOM_OWNER_CHANGED = 9104;
  static readonly PUSH_ROOM_RULE_CHANGED = 9105;
  static readonly PUSH_ROOM_DISSOLVE_REQUEST = 9106;
  static readonly PUSH_ROOM_DISSOLVE_VOTE = 9107;
  static readonly PUSH_ROOM_DISSOLVE_RESULT = 9108;
  static readonly PUSH_ROOM_PLAYER_OFFLINE = 9109;
  static readonly PUSH_ROOM_PLAYER_ONLINE = 9110;
  static readonly PUSH_ROOM_SEAT_CHANGED = 9111;
  static readonly PUSH_ROOM_SPECTATOR_JOINED = 9112;
  static readonly PUSH_ROOM_SPECTATOR_LEFT = 9113;
  static readonly PUSH_ROOM_CHAT = 9114;
  static readonly PUSH_ROOM_VOICE = 9115;
  static readonly PUSH_ROOM_GPS_SYNC = 9116;
  static readonly PUSH_ROOM_TIMER_SYNC = 9117;
  static readonly PUSH_ROOM_FORCE_CLOSE = 9118;
  static readonly PUSH_ROOM_SCORE_SYNC = 9119;

  // ===========================
  // 9200-9299 Match Push
  // ===========================
  static readonly PUSH_MATCH_START = 9200;
  static readonly PUSH_MATCH_WAITING = 9201;
  static readonly PUSH_MATCH_FOUND2 = 9202; // 避免与9016重复(可删掉9016或删掉此条)
  static readonly PUSH_MATCH_CONFIRM_REQUIRED = 9203;
  static readonly PUSH_MATCH_CONFIRM_RESULT = 9204;
  static readonly PUSH_MATCH_CANCELLED = 9205;
  static readonly PUSH_MATCH_FAILED = 9206;
  static readonly PUSH_MATCH_TIMEOUT = 9207;
  static readonly PUSH_MATCH_TEAM_UPDATE = 9208;
  static readonly PUSH_MATCH_REGION_CHANGED = 9209;
  static readonly PUSH_MATCH_RETRY = 9210;

  // ===========================
  // 9300-9399 Game Push
  // ===========================
  static readonly PUSH_GAME_START = 9300;
  static readonly PUSH_GAME_END = 9301;
  static readonly PUSH_GAME_STATE_SYNC = 9302;
  static readonly PUSH_GAME_TURN_CHANGE = 9303;
  static readonly PUSH_GAME_TIMER_SYNC = 9304;
  static readonly PUSH_GAME_PLAYER_ACTION = 9305;
  static readonly PUSH_GAME_SCORE_SYNC = 9306;
  static readonly PUSH_GAME_RECONNECT_SNAPSHOT = 9307;
  static readonly PUSH_GAME_PAUSE = 9308;
  static readonly PUSH_GAME_RESUME = 9309;
  static readonly PUSH_GAME_CHAT = 9310;
  static readonly PUSH_GAME_EMOJI = 9311;
  static readonly PUSH_GAME_VOICE = 9312;
  static readonly PUSH_GAME_EFFECT = 9313;
  static readonly PUSH_GAME_ANTI_CHEAT = 9314;
  static readonly PUSH_GAME_OBSERVER_JOIN = 9315;
  static readonly PUSH_GAME_OBSERVER_LEAVE = 9316;
  static readonly PUSH_GAME_LOG = 9317;

  // ===========================
  // 9400-9499 Pay Push
  // ===========================
  static readonly PUSH_PAY_ORDER_CREATED = 9400;
  static readonly PUSH_PAY_ORDER_PAID = 9401;
  static readonly PUSH_PAY_ORDER_FAILED = 9402;
  static readonly PUSH_PAY_ORDER_REFUND = 9403;
  static readonly PUSH_PAY_CURRENCY_SYNC = 9404;
  static readonly PUSH_PAY_SUBSCRIPTION_SYNC = 9405;

  // ===========================
  // 9500-9599 Risk Push
  // ===========================
  static readonly PUSH_RISK_WARNING = 9500;
  static readonly PUSH_RISK_LIMIT = 9501;
  static readonly PUSH_RISK_BAN = 9502;
  static readonly PUSH_RISK_UNBAN = 9503;
  static readonly PUSH_RISK_CHEAT_DETECTED = 9504;
  static readonly PUSH_RISK_DEVICE_BLOCK = 9505;
  static readonly PUSH_RISK_IP_BLOCK = 9506;
  static readonly PUSH_RISK_PAYMENT_RISK = 9507;

  // ===========================
  // 9900-9999 Debug
  // ===========================
  static readonly DEBUG_ECHO = 9900;
  static readonly DEBUG_PRINT = 9901;
  static readonly DEBUG_FORCE_DISCONNECT = 9902;
  static readonly DEBUG_FAKE_PUSH = 9903;
  static readonly DEBUG_ROOM_RESET = 9904;
  static readonly DEBUG_GAME_RESET = 9905;
  static readonly DEBUG_ADD_BOT = 9906;
  static readonly DEBUG_REMOVE_BOT = 9907;
  static readonly DEBUG_ADD_SCORE = 9908;
  static readonly DEBUG_CLEAR_DATA = 9909;
}
```

> 注意：我在 `PUSH_MATCH_FOUND` 这里做了 `9016` 和 `9202` 两个版本，你最终必须只保留一个，否则重复语义会乱。

---

# 2）Cmd.java（Spring Boot 后端用）

```java
// Cmd.java
// 前后端协议 CMD 常量表（WebSocket/Push）

public final class Cmd {

    private Cmd() {}

    // ===========================
    // 1000-1099 System
    // ===========================
    public static final int SYS_CONNECT = 1000;
    public static final int SYS_HEARTBEAT = 1001;
    public static final int SYS_AUTH = 1002;
    public static final int SYS_KICK = 1003;
    public static final int SYS_CLIENT_INFO = 1004;
    public static final int SYS_TIME_SYNC = 1005;
    public static final int SYS_RECONNECT = 1006;
    public static final int SYS_RECONNECT_RESULT = 1007;
    public static final int SYS_CHANGE_SERVER = 1008;
    public static final int SYS_NETWORK_TEST = 1009;
    public static final int SYS_PING = 1010;
    public static final int SYS_PONG = 1011;
    public static final int SYS_SET_LANGUAGE = 1012;
    public static final int SYS_SET_REGION = 1013;
    public static final int SYS_SET_DEVICE = 1014;
    public static final int SYS_SET_PUSH_TOKEN = 1015;
    public static final int SYS_CLIENT_LOG_UPLOAD = 1016;
    public static final int SYS_SERVER_NOTICE_PULL = 1017;
    public static final int SYS_MAINTAIN_INFO = 1018;
    public static final int SYS_FORCE_UPDATE = 1019;
    public static final int SYS_ERROR_REPORT = 1020;
    public static final int SYS_RATE_LIMIT = 1021;
    public static final int SYS_PROTO_VERSION = 1022;
    public static final int SYS_ENCRYPT_KEY = 1023;
    public static final int SYS_KEEP_ALIVE = 1024;
    public static final int SYS_CLIENT_READY = 1025;

    // ===========================
    // 1100-1199 User
    // ===========================
    public static final int USER_INFO_GET = 1100;
    public static final int USER_INFO_UPDATE = 1101;
    public static final int USER_LEVEL_UP = 1102;
    public static final int USER_EXP_SYNC = 1103;
    public static final int USER_CURRENCY_SYNC = 1104;
    public static final int USER_VIP_SYNC = 1105;
    public static final int USER_BIND_PHONE = 1106;
    public static final int USER_BIND_EMAIL = 1107;
    public static final int USER_REALNAME_VERIFY = 1108;
    public static final int USER_LOGIN_RECORD = 1109;
    public static final int USER_ONLINE_QUERY = 1110;
    public static final int USER_ONLINE_PUSH = 1111;
    public static final int USER_LOGOUT = 1112;
    public static final int USER_ACCOUNT_FREEZE = 1113;
    public static final int USER_ACCOUNT_UNFREEZE = 1114;
    public static final int USER_AVATAR_SET = 1115;
    public static final int USER_SIGN_IN = 1116;
    public static final int USER_SIGN_IN_INFO = 1117;
    public static final int USER_RED_DOT_SYNC = 1118;
    public static final int USER_PROFILE_CARD = 1119;
    public static final int USER_GPS_UPLOAD = 1120;
    public static final int USER_IP_REPORT = 1121;
    public static final int USER_PRIVACY_SET = 1122;
    public static final int USER_SETTING_GET = 1123;
    public static final int USER_SETTING_SET = 1124;
    public static final int USER_CLIENT_BIND = 1125;

    // ===========================
    // 1200-1299 Hall
    // ===========================
    public static final int HALL_ENTER = 1200;
    public static final int HALL_EXIT = 1201;
    public static final int HALL_INIT_DATA = 1202;
    public static final int HALL_BANNER_LIST = 1203;
    public static final int HALL_NOTICE_LIST = 1204;
    public static final int HALL_NOTICE_READ = 1205;
    public static final int HALL_ROOM_LIST = 1206;
    public static final int HALL_MODE_LIST = 1207;
    public static final int HALL_RECOMMEND_LIST = 1208;
    public static final int HALL_RANK_LIST = 1209;
    public static final int HALL_RANK_DETAIL = 1210;
    public static final int HALL_ONLINE_COUNT = 1211;
    public static final int HALL_SERVER_LIST = 1212;
    public static final int HALL_SERVER_SELECT = 1213;
    public static final int HALL_DAILY_REWARD = 1214;
    public static final int HALL_ACTIVITY_LIST = 1215;
    public static final int HALL_MATCH_RULES = 1216;
    public static final int HALL_GAME_LIST = 1217;
    public static final int HALL_GAME_ENTER = 1218;
    public static final int HALL_GAME_EXIT = 1219;
    public static final int HALL_PLAYER_LIST = 1220;
    public static final int HALL_FRIEND_RECOMMEND = 1221;
    public static final int HALL_AD_CONFIG = 1222;
    public static final int HALL_AD_REPORT = 1223;
    public static final int HALL_TASK_INFO = 1224;
    public static final int HALL_SYSTEM_CONFIG = 1225;
    public static final int HALL_PATCH_INFO = 1226;
    public static final int HALL_VERSION_CHECK = 1227;
    public static final int HALL_RESOURCE_CDN = 1228;
    public static final int HALL_MOTD = 1229;

    // ===========================
    // 1300-1399 Match
    // ===========================
    public static final int MATCH_START = 1300;
    public static final int MATCH_CANCEL = 1301;
    public static final int MATCH_STATUS_QUERY = 1302;
    public static final int MATCH_CONFIRM = 1303;
    public static final int MATCH_CONFIRM_CANCEL = 1304;
    public static final int MATCH_SET_LEVEL = 1305;
    public static final int MATCH_SET_MODE = 1306;
    public static final int MATCH_SET_GAME_TYPE = 1307;
    public static final int MATCH_RETRY = 1308;
    public static final int MATCH_FAST_JOIN = 1309;
    public static final int MATCH_INVITE_JOIN = 1310;
    public static final int MATCH_TEAM_CREATE = 1311;
    public static final int MATCH_TEAM_JOIN = 1312;
    public static final int MATCH_TEAM_LEAVE = 1313;
    public static final int MATCH_TEAM_KICK = 1314;
    public static final int MATCH_TEAM_READY = 1315;
    public static final int MATCH_TEAM_UNREADY = 1316;
    public static final int MATCH_TEAM_CHAT = 1317;
    public static final int MATCH_TEAM_INFO = 1318;
    public static final int MATCH_TEAM_DISSOLVE = 1319;
    public static final int MATCH_QUEUE_INFO = 1320;
    public static final int MATCH_ESTIMATE_TIME = 1321;
    public static final int MATCH_REGION_SET = 1322;
    public static final int MATCH_AI_FILL = 1323;
    public static final int MATCH_PING_TEST = 1324;

    // ===========================
    // 1400-1499 Room
    // ===========================
    public static final int ROOM_CREATE = 1400;
    public static final int ROOM_JOIN = 1401;
    public static final int ROOM_LEAVE = 1402;
    public static final int ROOM_READY = 1403;
    public static final int ROOM_UNREADY = 1404;
    public static final int ROOM_KICK_PLAYER = 1405;
    public static final int ROOM_CHANGE_OWNER = 1406;
    public static final int ROOM_SET_RULE = 1407;
    public static final int ROOM_GET_RULE = 1408;
    public static final int ROOM_INFO = 1409;
    public static final int ROOM_PLAYER_LIST = 1410;
    public static final int ROOM_SEAT_CHANGE = 1411;
    public static final int ROOM_SEAT_LOCK = 1412;
    public static final int ROOM_SEAT_UNLOCK = 1413;
    public static final int ROOM_CHAT = 1414;
    public static final int ROOM_EMOJI = 1415;
    public static final int ROOM_VOICE = 1416;
    public static final int ROOM_GPS_SYNC = 1417;
    public static final int ROOM_DISSOLVE_REQUEST = 1418;
    public static final int ROOM_DISSOLVE_VOTE = 1419;
    public static final int ROOM_DISSOLVE_RESULT = 1420;
    public static final int ROOM_START_GAME = 1421;
    public static final int ROOM_CANCEL_START = 1422;
    public static final int ROOM_PLAYER_OFFLINE = 1423;
    public static final int ROOM_PLAYER_ONLINE = 1424;
    public static final int ROOM_RECONNECT_SNAPSHOT = 1425;
    public static final int ROOM_TIME_SYNC = 1426;
    public static final int ROOM_SET_PASSWORD = 1427;
    public static final int ROOM_UNLOCK_PASSWORD = 1428;
    public static final int ROOM_INVITE_CODE = 1429;
    public static final int ROOM_INVITE_ACCEPT = 1430;
    public static final int ROOM_INVITE_REJECT = 1431;
    public static final int ROOM_CHANGE_MODE = 1432;
    public static final int ROOM_CHANGE_GAME = 1433;
    public static final int ROOM_ROBOT_ADD = 1434;
    public static final int ROOM_ROBOT_REMOVE = 1435;
    public static final int ROOM_SPECTATOR_JOIN = 1436;
    public static final int ROOM_SPECTATOR_LEAVE = 1437;
    public static final int ROOM_SPECTATOR_LIST = 1438;
    public static final int ROOM_HOST_HEARTBEAT = 1439;
    public static final int ROOM_FORCE_CLOSE = 1440;
    public static final int ROOM_TABLE_INFO = 1441;
    public static final int ROOM_PLAYER_INFO = 1442;
    public static final int ROOM_PLAYER_SCORE_SYNC = 1443;
    public static final int ROOM_RULE_VALIDATE = 1444;
    public static final int ROOM_CUSTOM_PROP_SET = 1445;
    public static final int ROOM_CUSTOM_PROP_GET = 1446;

    // ===========================
    // 2000-2399 DDZ
    // ===========================
    public static final int DDZ_ENTER = 2000;
    public static final int DDZ_EXIT = 2001;
    public static final int DDZ_GAME_START = 2002;
    public static final int DDZ_DEAL_CARDS = 2003;
    public static final int DDZ_SHOW_HAND = 2004;
    public static final int DDZ_CALL_SCORE = 2005;
    public static final int DDZ_CALL_SCORE_RESULT = 2006;
    public static final int DDZ_GRAB_LANDLORD = 2007;
    public static final int DDZ_GRAB_RESULT = 2008;
    public static final int DDZ_LANDLORD_CONFIRM = 2009;
    public static final int DDZ_BOTTOM_CARDS_SHOW = 2010;
    public static final int DDZ_MULTIPLIER_SYNC = 2011;
    public static final int DDZ_TURN_NOTIFY = 2012;
    public static final int DDZ_PLAY_CARDS = 2013;
    public static final int DDZ_PLAY_RESULT = 2014;
    public static final int DDZ_PASS = 2015;
    public static final int DDZ_PASS_RESULT = 2016;
    public static final int DDZ_HINT_REQUEST = 2017;
    public static final int DDZ_HINT_RESULT = 2018;
    public static final int DDZ_BOMB_NOTIFY = 2019;
    public static final int DDZ_ROCKET_NOTIFY = 2020;
    public static final int DDZ_SPRING_NOTIFY = 2021;
    public static final int DDZ_GAME_OVER = 2022;
    public static final int DDZ_SCORE_SYNC = 2023;
    public static final int DDZ_ROOM_SNAPSHOT = 2024;
    public static final int DDZ_TIMEOUT_AUTO_PLAY = 2025;
    public static final int DDZ_TRUSTEE_SET = 2026;
    public static final int DDZ_TRUSTEE_CANCEL = 2027;
    public static final int DDZ_CHAT_QUICK = 2028;
    public static final int DDZ_EMOJI = 2029;
    public static final int DDZ_VOICE = 2030;
    public static final int DDZ_RULE_SYNC = 2031;
    public static final int DDZ_CARD_COUNT_SYNC = 2032;
    public static final int DDZ_LAST_PLAY_SYNC = 2033;
    public static final int DDZ_GAME_PAUSE = 2034;
    public static final int DDZ_GAME_RESUME = 2035;
    public static final int DDZ_RECONNECT = 2036;
    public static final int DDZ_RECONNECT_RESULT = 2037;
    public static final int DDZ_DOUBLE_REQUEST = 2038;
    public static final int DDZ_DOUBLE_RESULT = 2039;
    public static final int DDZ_AUTO_HINT = 2040;
    public static final int DDZ_PLAY_INVALID = 2041;
    public static final int DDZ_PLAY_CONFIRM = 2042;
    public static final int DDZ_TURN_TIMER_SYNC = 2043;
    public static final int DDZ_BASE_SCORE_SYNC = 2044;
    public static final int DDZ_TASK_TRIGGER = 2045;
    public static final int DDZ_PLAYER_STAT_SYNC = 2046;
    public static final int DDZ_GAME_LOG = 2047;
    public static final int DDZ_TEST_CMD = 2048;

    public static final int DDZ_RANK_INFO = 2200;
    public static final int DDZ_RANK_MATCH_START = 2201;
    public static final int DDZ_RANK_MATCH_RESULT = 2202;
    public static final int DDZ_SEASON_INFO = 2203;
    public static final int DDZ_SEASON_REWARD = 2204;
    public static final int DDZ_ACHIEVEMENT_SYNC = 2205;
    public static final int DDZ_MVP_SYNC = 2206;
    public static final int DDZ_SPECIAL_EFFECT = 2207;
    public static final int DDZ_SKIN_LIST = 2208;
    public static final int DDZ_SKIN_SET = 2209;
    public static final int DDZ_CARD_BACK_SET = 2210;
    public static final int DDZ_TABLE_THEME_SET = 2211;
    public static final int DDZ_SHARE_RESULT = 2212;
    public static final int DDZ_REWARD_AD_CLAIM = 2213;
    public static final int DDZ_REPORT_CHEAT = 2214;
    public static final int DDZ_ANTI_CHEAT_SYNC = 2215;
    public static final int DDZ_OBSERVER_JOIN = 2216;
    public static final int DDZ_OBSERVER_LEAVE = 2217;
    public static final int DDZ_OBSERVER_LIST = 2218;
    public static final int DDZ_RECORD_UPLOAD = 2219;
    public static final int DDZ_REPLAY_UPLOAD = 2220;
    public static final int DDZ_REPLAY_READY = 2221;
    public static final int DDZ_TABLE_INFO = 2222;
    public static final int DDZ_TABLE_STATE_SYNC = 2223;
    public static final int DDZ_EVENT_TRIGGER = 2224;
    public static final int DDZ_DAILY_REWARD = 2225;
    public static final int DDZ_WEEKLY_REWARD = 2226;
    public static final int DDZ_MONTHLY_REWARD = 2227;
    public static final int DDZ_ROOM_CHAT = 2228;
    public static final int DDZ_PLAYER_INFO_SYNC = 2229;
    public static final int DDZ_FRIEND_INVITE = 2230;
    public static final int DDZ_AI_DIFFICULTY_SET = 2231;
    public static final int DDZ_AI_STATE_SYNC = 2232;
    public static final int DDZ_GAME_CONFIG_SYNC = 2233;
    public static final int DDZ_CLIENT_DEBUG = 2234;
    public static final int DDZ_SERVER_DEBUG = 2235;

    // ===========================
    // 3000-3399 MJ
    // ===========================
    public static final int MJ_ENTER = 3000;
    public static final int MJ_EXIT = 3001;
    public static final int MJ_GAME_START = 3002;
    public static final int MJ_DEAL_TILES = 3003;
    public static final int MJ_DRAW_TILE = 3004;
    public static final int MJ_DISCARD_TILE = 3005;
    public static final int MJ_DISCARD_RESULT = 3006;
    public static final int MJ_ACTION_HINT = 3007;
    public static final int MJ_ACTION_REQUEST = 3008;
    public static final int MJ_ACTION_RESULT = 3009;
    public static final int MJ_CHI_REQUEST = 3010;
    public static final int MJ_PENG_REQUEST = 3011;
    public static final int MJ_GANG_REQUEST = 3012;
    public static final int MJ_HU_REQUEST = 3013;
    public static final int MJ_TING_REQUEST = 3014;
    public static final int MJ_TING_RESULT = 3015;
    public static final int MJ_PASS = 3016;
    public static final int MJ_PASS_RESULT = 3017;
    public static final int MJ_TURN_NOTIFY = 3018;
    public static final int MJ_WALL_COUNT_SYNC = 3019;
    public static final int MJ_FLOWER_DRAW = 3020;
    public static final int MJ_FLOWER_SYNC = 3021;
    public static final int MJ_SCORE_SYNC = 3022;
    public static final int MJ_GAME_OVER = 3023;
    public static final int MJ_ROOM_SNAPSHOT = 3024;
    public static final int MJ_TIMEOUT_AUTO_PLAY = 3025;
    public static final int MJ_TRUSTEE_SET = 3026;
    public static final int MJ_TRUSTEE_CANCEL = 3027;
    public static final int MJ_CHAT_QUICK = 3028;
    public static final int MJ_EMOJI = 3029;
    public static final int MJ_VOICE = 3030;
    public static final int MJ_RULE_SYNC = 3031;
    public static final int MJ_DORA_SYNC = 3032;
    public static final int MJ_RECONNECT = 3033;
    public static final int MJ_RECONNECT_RESULT = 3034;
    public static final int MJ_TURN_TIMER_SYNC = 3035;
    public static final int MJ_READY_HAND_HINT = 3036;
    public static final int MJ_LAST_DISCARD_SYNC = 3037;
    public static final int MJ_DISCARD_INVALID = 3038;
    public static final int MJ_ACTION_PRIORITY = 3039;
    public static final int MJ_GAME_LOG = 3040;

    public static final int MJ_SEASON_INFO = 3200;
    public static final int MJ_SEASON_REWARD = 3201;
    public static final int MJ_RANK_INFO = 3202;
    public static final int MJ_RANK_MATCH_START = 3203;
    public static final int MJ_RANK_MATCH_RESULT = 3204;
    public static final int MJ_SPECIAL_HAND_NOTIFY = 3205;
    public static final int MJ_GANG_SCORE_SYNC = 3206;
    public static final int MJ_PIAO_FEN_REQUEST = 3207;
    public static final int MJ_PIAO_FEN_RESULT = 3208;
    public static final int MJ_ZHUANG_NOTIFY = 3209;
    public static final int MJ_CONTINUE_BANKER = 3210;
    public static final int MJ_PLAYER_STAT_SYNC = 3211;
    public static final int MJ_MVP_SYNC = 3212;
    public static final int MJ_SKIN_LIST = 3213;
    public static final int MJ_SKIN_SET = 3214;
    public static final int MJ_TILE_BACK_SET = 3215;
    public static final int MJ_TABLE_THEME_SET = 3216;
    public static final int MJ_SHARE_RESULT = 3217;
    public static final int MJ_REWARD_AD_CLAIM = 3218;
    public static final int MJ_REPORT_CHEAT = 3219;
    public static final int MJ_ANTI_CHEAT_SYNC = 3220;
    public static final int MJ_OBSERVER_JOIN = 3221;
    public static final int MJ_OBSERVER_LEAVE = 3222;
    public static final int MJ_OBSERVER_LIST = 3223;
    public static final int MJ_RECORD_UPLOAD = 3224;
    public static final int MJ_REPLAY_UPLOAD = 3225;
    public static final int MJ_REPLAY_READY = 3226;
    public static final int MJ_EVENT_TRIGGER = 3227;
    public static final int MJ_GAME_CONFIG_SYNC = 3228;
    public static final int MJ_AI_DIFFICULTY_SET = 3229;
    public static final int MJ_AI_STATE_SYNC = 3230;

    // ===========================
    // 9000+ Push
    // ===========================
    public static final int PUSH_SERVER_BROADCAST = 9000;
    public static final int PUSH_SYSTEM_NOTICE = 9001;
    public static final int PUSH_MAINTAIN_NOTICE = 9002;
    public static final int PUSH_KICK = 9003;
    public static final int PUSH_FORCE_LOGOUT = 9004;
    public static final int PUSH_CURRENCY_CHANGE = 9005;
    public static final int PUSH_LEVEL_UP = 9006;
    public static final int PUSH_MAIL_NEW = 9007;
    public static final int PUSH_ACTIVITY_UPDATE = 9008;
    public static final int PUSH_TASK_UPDATE = 9009;
    public static final int PUSH_FRIEND_ONLINE = 9010;
    public static final int PUSH_FRIEND_OFFLINE = 9011;
    public static final int PUSH_CHAT_WORLD = 9012;
    public static final int PUSH_CHAT_PRIVATE = 9013;
    public static final int PUSH_CHAT_ROOM = 9014;
    public static final int PUSH_ROOM_INVITE = 9015;
    public static final int PUSH_MATCH_FOUND = 9016;
    public static final int PUSH_PAYMENT_SUCCESS = 9017;
    public static final int PUSH_PAYMENT_FAILED = 9018;
    public static final int PUSH_ACCOUNT_FREEZE = 9019;
    public static final int PUSH_ACCOUNT_UNFREEZE = 9020;
    public static final int PUSH_CONFIG_RELOAD = 9021;
    public static final int PUSH_SERVER_TIME = 9022;
    public static final int PUSH_RED_DOT_SYNC = 9023;
    public static final int PUSH_RESOURCE_UPDATE = 9024;
    public static final int PUSH_CUSTOM_MESSAGE = 9025;
}
```

---

# 3）你必须注意的一个坑（很重要）

你这份 CMD 表里面：

* `PUSH_MATCH_FOUND` 既可以放 `9016`
* 也可以放 `9202`

但不能同时存在两个语义相同的推送号。

## 推荐最终方案：

* `9016` 用于系统推送（全局推送）
* `9202` 用于匹配推送（匹配模块推送）

更推荐统一放到 `9200` 段：

✅ 最终建议：只保留 `9202 PUSH_MATCH_FOUND`

---

如果你下一步需要，我可以继续给你：

* SpringBoot WebSocket 路由框架（cmd->handler 自动扫描）
* Cocos TS NetManager（自动注册 cmd handler）
* RoomSnapshot / GameSnapshot 数据结构标准模板
