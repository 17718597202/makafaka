-- ============================================================
-- MakaFaka 自动发卡平台定制虚拟数据种子
-- ============================================================

-- ────────────────────────────────────────
-- 1. 重构站点基础属性为 MakaFaka
-- ────────────────────────────────────────
UPDATE site_configs SET config_value = 'MakaFaka' WHERE config_key = 'site_name';
UPDATE site_configs SET config_value = '全球优质账号与VPN卡密极速交付' WHERE config_key = 'site_slogan';
UPDATE site_configs SET config_value = 'MakaFaka 提供全天候 24 小时高可用自动发卡服务，包括 VPN 订阅流量卡、Facebook 社交账户、ChatGPT Plus 独立账号等。' WHERE config_key = 'site_description';
UPDATE site_configs SET config_value = '由 MakaFaka 自动发卡平台提供服务' WHERE config_key = 'footer_text';

-- ────────────────────────────────────────
-- 2. 清理历史测试产品及卡密
-- ────────────────────────────────────────
DELETE FROM card_keys;
DELETE FROM product_specs;
DELETE FROM products;
DELETE FROM product_categories;

-- ────────────────────────────────────────
-- 3. 创建全新产品分类
-- ────────────────────────────────────────
-- 分类1：VPN 网络加速
INSERT INTO product_categories (id, name, sort_order, is_deleted, created_at, updated_at)
VALUES ('a0000000-0000-0000-0000-000000000001'::uuid, 'VPN 网络加速', 1, 0, NOW(), NOW());

-- 分类2：社交网络账户
INSERT INTO product_categories (id, name, sort_order, is_deleted, created_at, updated_at)
VALUES ('a0000000-0000-0000-0000-000000000002'::uuid, '社交网络账户', 2, 0, NOW(), NOW());

-- 分类3：AI 人工智能服务
INSERT INTO product_categories (id, name, sort_order, is_deleted, created_at, updated_at)
VALUES ('a0000000-0000-0000-0000-000000000003'::uuid, 'AI 人工智能服务', 3, 0, NOW(), NOW());

-- ────────────────────────────────────────
-- 4. 创建定制虚拟商品
-- ────────────────────────────────────────

-- ================== 分类1: VPN 网络加速 ==================
-- 商品1：MakaFaka VPN 极速季卡流量包 (150GB/月)
INSERT INTO products (id, title, description, cover_url, base_price, category_id, low_stock_threshold, wholesale_enabled, is_enabled, sort_order, is_deleted, created_at, updated_at)
VALUES (
  'b0000000-0000-0000-0000-000000000001'::uuid,
  'MakaFaka VPN 极速季卡流量包 (150GB/月)',
  'MakaFaka 专线网络加速器。支持 Clash, Shadowrocket, V2ray 全客户端。提供 3 个月高速专线，支持 4K 极速无卡顿。支持多设备同时在线。',
  '/api/uploads/vpn_cover.png',
  45.00,
  'a0000000-0000-0000-0000-000000000001'::uuid,
  5, false, true, 1, 0, NOW(), NOW()
);

-- 商品2：MakaFaka VPN 全球专线无限流量年卡
INSERT INTO products (id, title, description, cover_url, base_price, category_id, low_stock_threshold, wholesale_enabled, is_enabled, sort_order, is_deleted, created_at, updated_at)
VALUES (
  'b0000000-0000-0000-0000-000000000002'::uuid,
  'MakaFaka VPN 全球专线无限流量年卡',
  '终极加速尊享年卡，无限流量，独立 IPLC 国际专线，超低延迟，全天稳定不掉线，海外办公、游戏狂飙首选。',
  '/api/uploads/vpn_cover.png',
  148.00,
  'a0000000-0000-0000-0000-000000000001'::uuid,
  3, true, true, 2, 0, NOW(), NOW()
);

-- 商品3：Shadowrocket 独享小火箭苹果ID账号
INSERT INTO products (id, title, description, cover_url, base_price, category_id, low_stock_threshold, wholesale_enabled, is_enabled, sort_order, is_deleted, created_at, updated_at)
VALUES (
  'b0000000-0000-0000-0000-000000000003'::uuid,
  'Shadowrocket 独享小火箭苹果 ID 账号',
  '美国 App Store 独享已购 Shadowrocket (小火箭) 苹果账号，可直接登录 App Store 下载小火箭。密保齐全，支持修改密码、绑定个人密保。',
  '/api/uploads/vpn_cover.png',
  15.00,
  'a0000000-0000-0000-0000-000000000001'::uuid,
  5, false, true, 3, 0, NOW(), NOW()
);

-- ================== 分类2: 社交网络账户 ==================
-- 商品4：Facebook 2FA 双重身份验证耐用防封号
INSERT INTO products (id, title, description, cover_url, base_price, category_id, low_stock_threshold, wholesale_enabled, is_enabled, sort_order, is_deleted, created_at, updated_at)
VALUES (
  'b0000000-0000-0000-0000-000000000004'::uuid,
  'Facebook 2FA 双重身份验证耐用防封号',
  '已激活 2FA 令牌的优质海外 Facebook 个人账号。通过 IP 纯净住宅环境养号，抗封性强，发帖、投放广告及引流首选。发货格式包含：账号、密码、2FA 私钥、备用验证码。',
  '/api/uploads/facebook_cover.png',
  28.00,
  'a0000000-0000-0000-0000-000000000002'::uuid,
  5, true, true, 1, 0, NOW(), NOW()
);

-- 商品5：Facebook 企业广告账户 (BM250 权限)
INSERT INTO products (id, title, description, cover_url, base_price, category_id, low_stock_threshold, wholesale_enabled, is_enabled, sort_order, is_deleted, created_at, updated_at)
VALUES (
  'b0000000-0000-0000-0000-000000000005'::uuid,
  'Facebook 企业广告账户 (BM250 权限)',
  'Facebook Business Manager 优质账户，每日限额 $250 美元，可创建多个子广告户，已经过双重认证，稳定性高，带邀请直升通道链接。',
  '/api/uploads/facebook_cover.png',
  120.00,
  'a0000000-0000-0000-0000-000000000002'::uuid,
  3, false, true, 2, 0, NOW(), NOW()
);

-- ================== 分类3: AI 人工智能服务 ==================
-- 商品6：ChatGPT 3.5 独享独立成品账号 (已验邮箱)
INSERT INTO products (id, title, description, cover_url, base_price, category_id, low_stock_threshold, wholesale_enabled, is_enabled, sort_order, is_deleted, created_at, updated_at)
VALUES (
  'b0000000-0000-0000-0000-000000000006'::uuid,
  'ChatGPT 3.5 独享独立成品账号 (已验邮箱)',
  'OpenAI 独立注册账号，包含独立注册邮箱、密码，可任意修改，纯手工注册，安全耐用，支持 API 绑定。',
  '/api/uploads/chatgpt_cover.png',
  9.90,
  'a0000000-0000-0000-0000-000000000003'::uuid,
  5, false, true, 1, 0, NOW(), NOW()
);

-- 商品7：ChatGPT Plus (GPT-4) 官方正规订阅成品号
INSERT INTO products (id, title, description, cover_url, base_price, category_id, low_stock_threshold, wholesale_enabled, is_enabled, sort_order, is_deleted, created_at, updated_at)
VALUES (
  'b0000000-0000-0000-0000-000000000007'::uuid,
  'ChatGPT Plus (GPT-4) 官方正规订阅成品号',
  '官方正规礼品卡订阅的 ChatGPT Plus 尊享账号。已解锁 GPT-4、GPTS 插件商店、DALL-E 3 作图等全部高级特权，独享一人一号。',
  '/api/uploads/chatgpt_cover.png',
  175.00,
  'a0000000-0000-0000-0000-000000000003'::uuid,
  3, false, true, 2, 0, NOW(), NOW()
);

-- 商品8：OpenAI API Key 官方独享预充值点卡 ($120)
INSERT INTO products (id, title, description, cover_url, base_price, category_id, low_stock_threshold, wholesale_enabled, is_enabled, sort_order, is_deleted, created_at, updated_at)
VALUES (
  'b0000000-0000-0000-0000-000000000008'::uuid,
  'OpenAI API Key 官方独享预充值点卡 ($120)',
  '官方正版 API 接口秘钥，包含预充值 $120 美金余额，无限制并发额度，支持集成到个人聊天客户端或代码编辑器中。',
  '/api/uploads/chatgpt_cover.png',
  85.00,
  'a0000000-0000-0000-0000-000000000003'::uuid,
  5, true, true, 3, 0, NOW(), NOW()
);


-- ────────────────────────────────────────
-- 5. 插入高质量极速虚拟发货卡密 (AVAILABLE 状态)
-- ────────────────────────────────────────

-- 商品1：MakaFaka VPN 季卡
INSERT INTO card_keys (id, product_id, content, status, created_at, updated_at) VALUES
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000001'::uuid, 'MakaFaka-VPN-150G-季卡激活码: MFK-VPN-3M-Q8U7Y6T5R4E3W2Q1', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000001'::uuid, 'MakaFaka-VPN-150G-季卡订阅链接: https://sub.makafaka.com/link/vpn-sub-key-b8f9a0c2d4e6', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000001'::uuid, 'MakaFaka-VPN-150G-季卡订阅链接: https://sub.makafaka.com/link/vpn-sub-key-f6e4d3c2b1a0', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000001'::uuid, 'MakaFaka-VPN-150G-季卡订阅链接: https://sub.makafaka.com/link/vpn-sub-key-1a2b3c4d5e6f', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000001'::uuid, 'MakaFaka-VPN-150G-季卡订阅链接: https://sub.makafaka.com/link/vpn-sub-key-7a8b9c0d1e2f', 'AVAILABLE', NOW(), NOW());

-- 商品2：MakaFaka VPN 年卡
INSERT INTO card_keys (id, product_id, content, status, created_at, updated_at) VALUES
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000002'::uuid, 'MakaFaka-VPN-尊享年卡: https://sub.makafaka.com/link/year-unlimited-77f8d9a2', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000002'::uuid, 'MakaFaka-VPN-尊享年卡: https://sub.makafaka.com/link/year-unlimited-88a9b2c3', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000002'::uuid, 'MakaFaka-VPN-尊享年卡: https://sub.makafaka.com/link/year-unlimited-99c0d1e2', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000002'::uuid, 'MakaFaka-VPN-尊享年卡: https://sub.makafaka.com/link/year-unlimited-00e1f2a3', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000002'::uuid, 'MakaFaka-VPN-尊享年卡: https://sub.makafaka.com/link/year-unlimited-11f2a3b4', 'AVAILABLE', NOW(), NOW());

-- 商品3：小火箭苹果ID账号
INSERT INTO card_keys (id, product_id, content, status, created_at, updated_at) VALUES
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000003'::uuid, '【独享苹果ID】账号: mfk_store_us1@makafaka.com ---- 密码: MFKpassword123# ---- 密保答案: 纽约/红富士/加勒比海盗', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000003'::uuid, '【独享苹果ID】账号: mfk_store_us2@makafaka.com ---- 密码: MFKpassword456# ---- 密保答案: 纽约/红富士/加勒比海盗', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000003'::uuid, '【独享苹果ID】账号: mfk_store_us3@makafaka.com ---- 密码: MFKpassword789# ---- 密保答案: 纽约/红富士/加勒比海盗', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000003'::uuid, '【独享苹果ID】账号: mfk_store_us4@makafaka.com ---- 密码: MFKpassword012# ---- 密保答案: 纽约/红富士/加勒比海盗', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000003'::uuid, '【独享苹果ID】账号: mfk_store_us5@makafaka.com ---- 密码: MFKpassword345# ---- 密保答案: 纽约/红富士/加勒比海盗', 'AVAILABLE', NOW(), NOW());

-- 商品4：Facebook 2FA 耐用号
INSERT INTO card_keys (id, product_id, content, status, created_at, updated_at) VALUES
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000004'::uuid, '【FB耐用号】账号: 100087463524123 ---- 密码: FB_MFK_pass_99 ---- 2FA密钥: 7UTY6R5E4W3Q2A1B ---- 备用码: 99881122 33445566', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000004'::uuid, '【FB耐用号】账号: 100087463524124 ---- 密码: FB_MFK_pass_88 ---- 2FA密钥: 8UIO7Y6T5R4E3W2Q ---- 备用码: 88771122 33445566', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000004'::uuid, '【FB耐用号】账号: 100087463524125 ---- 密码: FB_MFK_pass_77 ---- 2FA密钥: 9PKO8I7U6Y5T4R3E ---- 备用码: 77661122 33445566', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000004'::uuid, '【FB耐用号】账号: 100087463524126 ---- 密码: FB_MFK_pass_66 ---- 2FA密钥: 0PLM9K8J7H6G5F4D ---- 备用码: 66551122 33445566', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000004'::uuid, '【FB耐用号】账号: 100087463524127 ---- 密码: FB_MFK_pass_55 ---- 2FA密钥: QWERTYUIOPASDFGH ---- 备用码: 55441122 33445566', 'AVAILABLE', NOW(), NOW());

-- 商品5：Facebook BM250 广告账号
INSERT INTO card_keys (id, product_id, content, status, created_at, updated_at) VALUES
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000005'::uuid, '【FB-BM250】邀请链接: https://fb.me/joinbm/inv-88887777aaaa1111 ---- BM_ID: 88887777123', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000005'::uuid, '【FB-BM250】邀请链接: https://fb.me/joinbm/inv-88887777bbbb2222 ---- BM_ID: 88887777456', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000005'::uuid, '【FB-BM250】邀请链接: https://fb.me/joinbm/inv-88887777cccc3333 ---- BM_ID: 88887777789', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000005'::uuid, '【FB-BM250】邀请链接: https://fb.me/joinbm/inv-88887777dddd4444 ---- BM_ID: 88887777012', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000005'::uuid, '【FB-BM250】邀请链接: https://fb.me/joinbm/inv-88887777eeee5555 ---- BM_ID: 88887777345', 'AVAILABLE', NOW(), NOW());

-- 商品6：ChatGPT 3.5 独享独立成品账号
INSERT INTO card_keys (id, product_id, content, status, created_at, updated_at) VALUES
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000006'::uuid, '【OpenAI账号】邮箱: mfk_gpt3_1@outlook.com ---- 密码: MFK_gpt_pwd_1 ---- API_KEY: sk-proj-112233445566', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000006'::uuid, '【OpenAI账号】邮箱: mfk_gpt3_2@outlook.com ---- 密码: MFK_gpt_pwd_2 ---- API_KEY: sk-proj-223344556677', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000006'::uuid, '【OpenAI账号】邮箱: mfk_gpt3_3@outlook.com ---- 密码: MFK_gpt_pwd_3 ---- API_KEY: sk-proj-334455667788', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000006'::uuid, '【OpenAI账号】邮箱: mfk_gpt3_4@outlook.com ---- 密码: MFK_gpt_pwd_4 ---- API_KEY: sk-proj-445566778899', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000006'::uuid, '【OpenAI账号】邮箱: mfk_gpt3_5@outlook.com ---- 密码: MFK_gpt_pwd_5 ---- API_KEY: sk-proj-556677889900', 'AVAILABLE', NOW(), NOW());

-- 商品7：ChatGPT Plus (GPT-4) 独享独立成品号
INSERT INTO card_keys (id, product_id, content, status, created_at, updated_at) VALUES
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000007'::uuid, '【Plus独享账号】邮箱: mfk_gptplus_1@proton.me ---- 密码: PlusMFKpwd1# ---- 有效期至: 2026-06-30', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000007'::uuid, '【Plus独享账号】邮箱: mfk_gptplus_2@proton.me ---- 密码: PlusMFKpwd2# ---- 有效期至: 2026-06-30', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000007'::uuid, '【Plus独享账号】邮箱: mfk_gptplus_3@proton.me ---- 密码: PlusMFKpwd3# ---- 有效期至: 2026-06-30', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000007'::uuid, '【Plus独享账号】邮箱: mfk_gptplus_4@proton.me ---- 密码: PlusMFKpwd4# ---- 有效期至: 2026-06-30', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000007'::uuid, '【Plus独享账号】邮箱: mfk_gptplus_5@proton.me ---- 密码: PlusMFKpwd5# ---- 有效期至: 2026-06-30', 'AVAILABLE', NOW(), NOW());

-- 商品8：OpenAI API Key 官方独享预充值点卡
INSERT INTO card_keys (id, product_id, content, status, created_at, updated_at) VALUES
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000008'::uuid, '【OpenAI API Key】sk-proj-MFK-API-KEY-VALUE-AAAAA-BBBBB-CCCCC-DDDDD-EEEE', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000008'::uuid, '【OpenAI API Key】sk-proj-MFK-API-KEY-VALUE-FFFFF-GGGGG-HHHHH-IIIII-JJJJ', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000008'::uuid, '【OpenAI API Key】sk-proj-MFK-API-KEY-VALUE-KKKKK-LLLLL-MMMMM-NNNNN-OOOO', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000008'::uuid, '【OpenAI API Key】sk-proj-MFK-API-KEY-VALUE-PPPPP-QQQQQ-RRRRR-SSSSS-TTTT', 'AVAILABLE', NOW(), NOW()),
(gen_random_uuid(), 'b0000000-0000-0000-0000-000000000008'::uuid, '【OpenAI API Key】sk-proj-MFK-API-KEY-VALUE-UUUUU-VVVVV-WWWWW-XXXXX-YYYY', 'AVAILABLE', NOW(), NOW());

commit;
