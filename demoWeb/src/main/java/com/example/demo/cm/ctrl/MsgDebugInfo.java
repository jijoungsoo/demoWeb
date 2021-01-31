package com.example.demo.cm.ctrl;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;

import com.example.demo.utils.PjtUtil;
import com.example.demo.exception.BizException;
import com.example.demo.service.GoRestService;
import com.example.demo.user.domain.UserInfo;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;

import lombok.extern.slf4j.Slf4j;

public class MsgDebugInfo  implements Serializable  {
    String UUID="";
    int SEQ=0;
	String Br="";
	String IN_DATA_JSON="";
	String OUT_DATA_JSON="";
    public String getUUID() {
        return UUID;
    }
    public void setUUID(String uUID) {
        UUID = uUID;
    }
    public int getSEQ() {
        return SEQ;
    }
    public void setSEQ(int sEQ) {
        SEQ = sEQ;
    }
    public String getBr() {
        return Br;
    }
    public void setBr(String br) {
        Br = br;
    }
    public String getIN_DATA_JSON() {
        return IN_DATA_JSON;
    }
    public void setIN_DATA_JSON(String iN_DATA_JSON) {
        IN_DATA_JSON = iN_DATA_JSON;
    }
    public String getOUT_DATA_JSON() {
        return OUT_DATA_JSON;
    }
    public void setOUT_DATA_JSON(String oUT_DATA_JSON) {
        OUT_DATA_JSON = oUT_DATA_JSON;
    }
	  
}
