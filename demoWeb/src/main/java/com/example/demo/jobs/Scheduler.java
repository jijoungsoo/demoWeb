package com.example.demo.jobs;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class Scheduler {
   //초(0-59)   분(0-59)　　시간(0-23)　　일(1-31)　　월(1-12)　　요일(0-7) 
   @Scheduled(cron = "0 * 9 * * ?")   //9시에 실행
   public void cronJobSch() {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
      Date now = new Date();
      String strDate = sdf.format(now);
      System.out.println("Java cron job expression:: " + strDate);
   }

   // 1초에 한번 실행된다.
   @Scheduled(fixedDelay = 1000) 
   public void scheduleFixedRateTask() {
      System.out.println("Fixed rate task - " + System.currentTimeMillis() / 1000);
      log.info("Current Thread : {}", Thread.currentThread().getName());
   }
}