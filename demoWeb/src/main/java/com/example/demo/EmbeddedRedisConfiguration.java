package com.example.demo;

import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import redis.embedded.RedisServer;
/*https://derveljunit.tistory.com/310*/
/*https://cnpnote.tistory.com/entry/SPRING-Embedded-Redis%EA%B0%80-%EC%8B%A4%EC%A0%9C-Redis-%EC%84%9C%EB%B2%84%EC%97%90-%EC%97%B0%EA%B2%B0%ED%95%98%EB%A0%A4%EA%B3%A0-%EC%8B%9C%EB%8F%84%ED%95%98%EC%97%AC-%EC%98%88%EC%99%B8%EA%B0%80-%EB%B0%9C%EC%83%9D%ED%95%A9%EB%8B%88%EB%8B%A4*/
@Slf4j //lombok
@Profile("local") // profile이 local일때만 활성화
@Configuration
public class EmbeddedRedisConfiguration {

	@Value("${spring.redis.port}")
	private int redisPort;
   @Bean
    public RedisServerBean redisServer() {
        return new RedisServerBean();
    }

    class RedisServerBean implements InitializingBean, DisposableBean {
        private RedisServer redisServer;

        @Override
		public void afterPropertiesSet() throws Exception {
            redisServer = new RedisServer(redisPort);
            redisServer.start();
        }

        @Override
		public void destroy() throws Exception {
            if (redisServer != null) {
                redisServer.stop();
            }
        }
    }
}