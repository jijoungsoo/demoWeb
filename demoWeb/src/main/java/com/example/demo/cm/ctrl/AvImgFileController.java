package com.example.demo.cm.ctrl;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.regex.Matcher;

import com.example.demo.YmlConfig;
import com.example.demo.dmn.excel.FileDto;
import com.example.demo.service.FileService;
import com.example.demo.service.GoRestService;
import com.example.demo.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AvImgFileController {

    @Autowired
    private FileService fService;

    @Autowired
    private YmlConfig yc;
    
    @GetMapping(value = "/ACTOR_IDX_PF_IMG/{IMG_GUBUN}/{ACTOR_IDX}")
    public  ResponseEntity<Resource> ACTOR_IDX_PF_IMG(
            @PathVariable("IMG_GUBUN") String IMG_GUBUN
            ,@PathVariable("ACTOR_IDX") String ACTOR_IDX
            , Authentication authentication
            ) throws Exception {

        HashMap<String, ArrayList<HashMap<String, Object>>> outDs = new HashMap<String, ArrayList<HashMap<String, Object>>>();
        try {
            HashMap<String, Object> IN_DS = new HashMap<String, Object>();
            IN_DS.put("brRq", "IN_DATA");
            IN_DS.put("brRs", "OUT_DATA");
            ArrayList<HashMap<String, Object>> in_date = new ArrayList<HashMap<String, Object>>();
            HashMap<String, Object> tmp = new HashMap<String, Object>();
            tmp.put("ACTOR_IDX", ACTOR_IDX);
            in_date.add(tmp);
            IN_DS.put("IN_DATA", in_date);

            String jsonInString = PjtUtil.ObjectToJsonString(IN_DS);
            MsgDebugInfo msg = PjtUtil.makeLSession("BS_MIG_AV_ACTR_PF_IMG_FIND_BY_ACTOR_IDX", jsonInString, authentication);
            String jsonOutString = GoRestService.callAPI("BS_MIG_AV_ACTR_PF_IMG_FIND_BY_ACTOR_IDX", msg.getIN_DATA_JSON());
            outDs = PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        ArrayList<HashMap<String, Object>> tmp = outDs.get("OUT_DATA");
        ArrayList<FileDto> OUT_DATA = new ArrayList<FileDto>();
        if(tmp.size()==0){
            //없는 이미지 넣자.
            return null;
        }
        HashMap<String, Object> tmp2 = tmp.get(0); 

        String IMG_SRC ="";

        if(IMG_GUBUN.equals("L")){
             IMG_SRC = String.valueOf(tmp2.get("IMG_L"));

        } else if(IMG_GUBUN.equals("LS")){
            IMG_SRC = String.valueOf(tmp2.get("IMG_LS"));
        }

        if(PjtUtil.isEmpty(IMG_SRC)){
            return null;
        }

        String FILE_PULL_PATH = yc.getServerFilePath()+IMG_SRC;
        System.out.println(FILE_PULL_PATH);
        String OsFilePath = FILE_PULL_PATH.replace("/", Matcher.quoteReplacement(File.separator));
        System.out.println(OsFilePath);
        Path path = Paths.get(OsFilePath);
        System.out.println(path.toAbsolutePath());

        
        String contentType = Files.probeContentType(path);

        // Fallback to the default content type if type could not be determined
        if(contentType == null) {
            contentType = "application/octet-stream";
        }
        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.CONTENT_TYPE, contentType);
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + IMG_SRC + "\"");
        Resource resource = new InputStreamResource(Files.newInputStream(path));
        return new ResponseEntity<>(resource, headers, HttpStatus.OK);
    }

    
    @GetMapping(value = "/ACTOR_IDX_GLRY/{IMG_GUBUN}/{IMG_SEQ}")
    public  ResponseEntity<Resource> ACTOR_IDX_GLRY(
            @PathVariable("IMG_GUBUN") String IMG_GUBUN
            ,@PathVariable("IMG_SEQ") String IMG_SEQ
            , Authentication authentication
            ) throws Exception {

        HashMap<String, ArrayList<HashMap<String, Object>>> outDs = new HashMap<String, ArrayList<HashMap<String, Object>>>();
        try {
            HashMap<String, Object> IN_DS = new HashMap<String, Object>();
            IN_DS.put("brRq", "IN_DATA");
            IN_DS.put("brRs", "OUT_DATA");
            ArrayList<HashMap<String, Object>> in_date = new ArrayList<HashMap<String, Object>>();
            HashMap<String, Object> tmp = new HashMap<String, Object>();
            tmp.put("IMG_SEQ", IMG_SEQ);
            in_date.add(tmp);
            IN_DS.put("IN_DATA", in_date);

            String jsonInString = PjtUtil.ObjectToJsonString(IN_DS);
            MsgDebugInfo msg = PjtUtil.makeLSession("BS_MIG_AV_ACTR_IMG_FIND_BY_IMG_SEQ", jsonInString, authentication);
            String jsonOutString = GoRestService.callAPI("BS_MIG_AV_ACTR_IMG_FIND_BY_IMG_SEQ", msg.getIN_DATA_JSON());
            outDs = PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        ArrayList<HashMap<String, Object>> tmp = outDs.get("OUT_DATA");
        ArrayList<FileDto> OUT_DATA = new ArrayList<FileDto>();
        if(tmp.size()==0){
            //없는 이미지 넣자.
            return null;
        }
        HashMap<String, Object> tmp2 = tmp.get(0); 

        String IMG_SRC ="";

        if(IMG_GUBUN.equals("L")){
             IMG_SRC = String.valueOf(tmp2.get("IMG_L"));

        } else if(IMG_GUBUN.equals("LS")){
            IMG_SRC = String.valueOf(tmp2.get("IMG_LS"));
        }

        if(PjtUtil.isEmpty(IMG_SRC)){
            return null;
        }

        String FILE_PULL_PATH = yc.getServerFilePath()+IMG_SRC;
        System.out.println(FILE_PULL_PATH);
        String OsFilePath = FILE_PULL_PATH.replace("/", Matcher.quoteReplacement(File.separator));
        System.out.println(OsFilePath);
        Path path = Paths.get(OsFilePath);
        System.out.println(path.toAbsolutePath());

        
        String contentType = Files.probeContentType(path);

        // Fallback to the default content type if type could not be determined
        if(contentType == null) {
            contentType = "application/octet-stream";
        }
        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.CONTENT_TYPE, contentType);
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + IMG_SRC + "\"");
        Resource resource = new InputStreamResource(Files.newInputStream(path));
        return new ResponseEntity<>(resource, headers, HttpStatus.OK);
    }

    
    @GetMapping(value = "/DVD_IDX_IMG/{IMG_GUBUN}/{DVD_IDX}")
    public  ResponseEntity<Resource> DVD_IDX_IMG(
            @PathVariable("IMG_GUBUN") String IMG_GUBUN
            ,@PathVariable("DVD_IDX") String DVD_IDX
            , Authentication authentication
            ) throws Exception {

        HashMap<String, ArrayList<HashMap<String, Object>>> outDs = new HashMap<String, ArrayList<HashMap<String, Object>>>();
        try {
            HashMap<String, Object> IN_DS = new HashMap<String, Object>();
            IN_DS.put("brRq", "IN_DATA");
            IN_DS.put("brRs", "OUT_DATA");
            ArrayList<HashMap<String, Object>> in_date = new ArrayList<HashMap<String, Object>>();
            HashMap<String, Object> tmp = new HashMap<String, Object>();
            tmp.put("DVD_IDX", DVD_IDX);
            in_date.add(tmp);
            IN_DS.put("IN_DATA", in_date);

            String jsonInString = PjtUtil.ObjectToJsonString(IN_DS);
            MsgDebugInfo msg = PjtUtil.makeLSession("BS_MIG_AV_MV_IMG_FIND_BY_DVD_IDX", jsonInString, authentication);
            String jsonOutString = GoRestService.callAPI("BS_MIG_AV_MV_IMG_FIND_BY_DVD_IDX", msg.getIN_DATA_JSON());
            outDs = PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        ArrayList<HashMap<String, Object>> tmp = outDs.get("OUT_DATA");
        ArrayList<FileDto> OUT_DATA = new ArrayList<FileDto>();
        if(tmp.size()==0){
            //없는 이미지 넣자.
            return null;
        }
        HashMap<String, Object> tmp2 = tmp.get(0); 

        String IMG_SRC ="";

        if(IMG_GUBUN.equals("L")){
            if(tmp2.get("IMG_LA")!=null) {
                IMG_SRC = String.valueOf(tmp2.get("IMG_LA"));
            }
             

        } else if(IMG_GUBUN.equals("LS")){
            
            if(tmp2.get("IMG_LAS")!=null) {
                IMG_SRC = String.valueOf(tmp2.get("IMG_LAS"));
            }
        }

        if(PjtUtil.isEmpty(IMG_SRC)){
            return null;
        }

        String FILE_PULL_PATH = yc.getServerFilePath()+IMG_SRC;
        System.out.println(FILE_PULL_PATH);
        String OsFilePath = FILE_PULL_PATH.replace("/", Matcher.quoteReplacement(File.separator));
        System.out.println(OsFilePath);
        Path path = Paths.get(OsFilePath);
        System.out.println(path.toAbsolutePath());

        
        String contentType = Files.probeContentType(path);

        // Fallback to the default content type if type could not be determined
        if(contentType == null) {
            contentType = "application/octet-stream";
        }
        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.CONTENT_TYPE, contentType);
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + IMG_SRC + "\"");
        Resource resource = new InputStreamResource(Files.newInputStream(path));
        return new ResponseEntity<>(resource, headers, HttpStatus.OK);
    }
}
