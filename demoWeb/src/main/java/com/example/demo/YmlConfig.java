package com.example.demo;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

//출처: https://jeong-pro.tistory.com/159 [기본기를 쌓는 정아마추어 코딩블로그]
@Component
@ConfigurationProperties(prefix="env")
public class YmlConfig {
    
    private String serverfilepath;
    
    public String getServerfilepath() {
        return serverfilepath;
    }
}
