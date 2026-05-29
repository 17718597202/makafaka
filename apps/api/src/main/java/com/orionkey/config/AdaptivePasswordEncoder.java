package com.orionkey.config;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * 自适应密码编码器
 * 优先采用标准的 BCrypt 加密匹配进行校验。
 * 如果数据库存储的密码不是 BCrypt 哈希结构（如明文数据或开发模式下的 legacy 密码），
 * 且系统开启了 allowPlainFallback 降级配置，则支持平滑回退进行明文比对。
 */
public class AdaptivePasswordEncoder implements PasswordEncoder {

    private final BCryptPasswordEncoder bcrypt = new BCryptPasswordEncoder();
    private final boolean allowPlainFallback;

    public AdaptivePasswordEncoder(boolean allowPlainFallback) {
        this.allowPlainFallback = allowPlainFallback;
    }

    @Override
    public String encode(CharSequence rawPassword) {
        // 始终对新密码或更新的密码执行高安全级别的 BCrypt 哈希处理
        return bcrypt.encode(rawPassword);
    }

    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        if (rawPassword == null || encodedPassword == null) {
            return false;
        }

        // 1. 如果存储的密文具备 BCrypt 特征（以 $2a$, $2b$ 或 $2y$ 开头），优先使用 BCrypt 校验
        if (isBcryptHash(encodedPassword)) {
            try {
                return bcrypt.matches(rawPassword, encodedPassword);
            } catch (Exception e) {
                // BCrypt 格式校验异常，降级到后续逻辑
            }
        }

        // 2. 如果非 BCrypt 特征，或者上面校验不通过且允许明文回退，则执行明文比对
        if (allowPlainFallback) {
            return rawPassword.toString().equals(encodedPassword);
        }

        return false;
    }

    /**
     * 判断字符串是否符合 BCrypt 哈希格式
     */
    private boolean isBcryptHash(String val) {
        return val != null && (val.startsWith("$2a$") || val.startsWith("$2b$") || val.startsWith("$2y$"));
    }
}
