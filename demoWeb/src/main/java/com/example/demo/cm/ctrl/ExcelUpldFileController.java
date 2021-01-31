package com.example.demo.cm.ctrl;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

import com.example.demo.dmn.excel.ExcelDto;
import com.example.demo.dmn.excel.FileDto;
import com.example.demo.exception.BizException;
import com.example.demo.service.GoRestService;
import com.example.demo.utils.ExcelUtils;
import com.example.demo.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ExcelUpldFileController {

    @Autowired
    private GoRestService goService;

    private String storagePath = "D:/storage/";
    
    @PostMapping(value = "/excel_upld")
    public ResponseEntity<Map<String, Object>> upload(
            @RequestPart("file") List<MultipartFile> files
            , Authentication authentication
            ) throws Exception {
        ArrayList<FileDto> al = new ArrayList<FileDto>();
        final String fileGroup =UUID.randomUUID()+"";
        for(int i=0;i<files.size();i++) {
            MultipartFile t=files.get(i);
            FileDto  tmp=uploadFile(fileGroup,t);
            al.add(tmp);
        }
        createFile(al,authentication);
        
        ArrayList<HashMap<String, Object>> OUT_DATA = createExcelFile(al,authentication);
        
        Map<String, Object> tmp = new HashMap<String, Object>();
        tmp.put("OUT_DATA", OUT_DATA);
        return ResponseEntity.created(null).body(tmp);
    }
    
    
    
    
    public FileDto uploadFile(String fileGroup,MultipartFile mf) throws Exception  {
        FileDto fDto = new FileDto();
        Date nowDate = new Date(); 
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String strNowDate = simpleDateFormat.format(nowDate);
        ///final String fileNm = mf.getOriginalFilename();
        ///파일명을 YYYYMMDD_
        String orgFileNm =mf.getOriginalFilename();
        String extension = FilenameUtils.getExtension(orgFileNm); // 3

        if (!extension.equals("xlsx") && !extension.equals("xls")) {
          throw new IOException("엑셀파일만 업로드 해주세요.");
        }
     

        
        final String fileId = strNowDate+"_"+UUID.randomUUID();
        final String fileNm = fileId+"."+extension;
        final long fileSize = mf.getSize();
        final String filePath = storagePath + fileNm;
        
        File f = new File(filePath);
        if(f.exists()) {
            throw new Exception("파일이 중복되었습니다.");
            //return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
        // 주어진 경로에 존재하지 않는 모든 디렉토리 생성
        if(f.getParentFile().mkdirs()) {
            try {
                // 물리파일 생성
                f.createNewFile();
            }
            catch(IOException ie) {
                // 파일 생성 중 오류
                ie.printStackTrace();
                throw new Exception("파일이 생성중 에러가 발생하였습니다.");
                //return ResponseEntity.status(HttpStatus.CONFLICT).build();
            }           
        }
        try {
            // 업로드 임시파일 -> 물리파일 덮어쓰기
            mf.transferTo(f);
        }
        catch(IOException ie) {
            // 덮어쓰기 중 오류
            ie.printStackTrace();
            throw new Exception("파일이 복사중 에러가 발생하였습니다.");
            //return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
        
        fDto.setFileId(fileId);
        fDto.setFileGroup(fileGroup);
        fDto.setOrgFileNm(orgFileNm);
        fDto.setExt(extension);
        fDto.setSvrFileNm(fileNm);
        fDto.setSvrDirPath(storagePath);
        fDto.setFileStatusCd("T");
        
        return fDto;
    }
    

    private void createFile(ArrayList<FileDto> al, Authentication authentication
            ) {
        
        ArrayList<HashMap<String,Object>> in_al = new ArrayList<HashMap<String,Object>>();
        for(int i=0;i<al.size();i++) {
            FileDto tmp = al.get(i);
            HashMap<String,Object> m= new HashMap<String,Object>();
            m.put("FILE_ID",tmp.getFileId());
            m.put("FILE_GROUP",tmp.getFileGroup());
            m.put("ORG_FILE_NM",tmp.getOrgFileNm());
            m.put("EXT",tmp.getExt());
            m.put("SVR_FILE_NM",tmp.getSvrFileNm());
            m.put("SVR_DIR_PATH",tmp.getSvrDirPath());
            m.put("FILE_STATUS_CD",tmp.getFileStatusCd());
        }
        
        
        HashMap<String,ArrayList<HashMap<String,Object>>> outDs = new HashMap<String,ArrayList<HashMap<String,Object>>>();
        try {
            HashMap<String,Object> IN_DS = new HashMap<String,Object>();
            IN_DS.put("brRq","IN_DATA");
            IN_DS.put("brRs","OUT_DATA");
            IN_DS.put("IN_DATA",al);

            String jsonInString=PjtUtil.ObjectToJsonString(IN_DS);
            MsgDebugInfo msg = PjtUtil.makeLSession("createFile",jsonInString,authentication);
            
            String jsonOutString = goService.callAPI("createFile", msg.IN_DATA_JSON);
            outDs=PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
        } catch (BizException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
    public ArrayList<HashMap<String, Object>> createExcelFile(ArrayList<FileDto> al, Authentication authentication
            )  {
        ArrayList<HashMap<String, Object>> OUT_DATA =  new ArrayList<HashMap<String, Object>>();
        for(int i=0;i<al.size();i++) {
            FileDto fDto = al.get(i); 
            final String svrFileNm = fDto.getSvrFileNm();
            final String storagePath = fDto.getSvrDirPath();
            final String filePath = storagePath + svrFileNm;
            File f = new File(filePath);
            List<ExcelDto> all_list = new ArrayList<ExcelDto>(); 
            if(f.exists()) {
                List<ExcelDto> list=ExcelUtils.getExcelUpload(fDto.getFileId(),f.getAbsolutePath());
                all_list.addAll(list);
            }

            HashMap<String,ArrayList<HashMap<String,Object>>> outDs = new HashMap<String,ArrayList<HashMap<String,Object>>>();
            HashMap<String,Object> IN_DS = new HashMap<String,Object>();
            IN_DS.put("brRq","IN_DATA");
            IN_DS.put("brRs","OUT_DATA");
            IN_DS.put("IN_DATA",all_list);
            try {
            String jsonInString=PjtUtil.ObjectToJsonString(IN_DS);
            MsgDebugInfo msg = PjtUtil.makeLSession("createExcelUpld",jsonInString,authentication);
            String jsonOutString = goService.callAPI("createExcelUpld", msg.IN_DATA_JSON);
            
                outDs=PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
            } catch (JsonMappingException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } catch (JsonProcessingException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } catch (BizException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            OUT_DATA=outDs.get("OUT_DATA");
                
        }
        return OUT_DATA;
    }
}
