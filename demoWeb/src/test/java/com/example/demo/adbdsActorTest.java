package com.example.demo;

import org.junit.jupiter.api.Test;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class adbdsActorTest {

    @Test
    public void testActor(){
     String tmp ="/menu/dvd.php?dvd_idx=766625";
     tmp=tmp.replaceAll("/menu/dvd.php\\?dvd_idx=", "");
     System.out.println(tmp);
    }

   
    
}
