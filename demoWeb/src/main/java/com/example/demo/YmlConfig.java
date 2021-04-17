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

    public void setServerfilepath(String serverfilepath) {
        this.serverfilepath = serverfilepath;
    }

    private String apiurl;
    
    public String getApiurl() {
        return apiurl;
    }

    public void setApiurl(String apiurl) {
        this.apiurl = apiurl;
    }

    private Integer timeout;
    
    public Integer getTimeout() {
        return timeout;
    }

    public void setTimeout(Integer timeout) {
        this.timeout = timeout;
    }
}
