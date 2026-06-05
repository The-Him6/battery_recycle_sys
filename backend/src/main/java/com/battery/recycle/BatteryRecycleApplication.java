package com.battery.recycle;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 智能化废电池回收系统启动类
 */
@SpringBootApplication
@MapperScan("com.battery.recycle.mapper")
public class BatteryRecycleApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(BatteryRecycleApplication.class, args);
        System.out.println("========================================");
        System.out.println("智能化废电池回收系统启动成功！");
        System.out.println("访问地址：http://localhost:8081/api");
        System.out.println("========================================");
    }
}

