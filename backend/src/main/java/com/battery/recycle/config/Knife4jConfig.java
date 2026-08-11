package com.battery.recycle.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * knife4j 接口文档配置类（集成 Swagger/OpenAPI 3）
 */
@Configuration
public class Knife4jConfig {

    private static final String SECURITY_SCHEME_NAME = "Authorization";

    /**
     * 自定义 OpenAPI 基本信息与全局 JWT 安全配置
     */
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("智能化废电池回收系统 API 文档")
                        .description("废电池回收与积分兑换平台后端接口文档，支持在线接口测试。\n\n"
                                + "接口大多需要登录，请在右上角【文档管理-调试管理】配置全局参数后调用：\n"
                                + "请求头名称 Authorization，请求值 Bearer 登录返回的 token。")
                        .version("1.0.0")
                        .contact(new Contact().name("battery-recycle-system")))
                .addSecurityItem(new SecurityRequirement().addList(SECURITY_SCHEME_NAME))
                .components(new Components().addSecuritySchemes(SECURITY_SCHEME_NAME,
                        new SecurityScheme()
                                .name(SECURITY_SCHEME_NAME)
                                .type(SecurityScheme.Type.HTTP)
                                .scheme("bearer")
                                .bearerFormat("JWT")));
    }
}
