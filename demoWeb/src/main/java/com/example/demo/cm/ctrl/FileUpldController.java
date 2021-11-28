package com.example.demo.cm.ctrl;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import com.example.demo.dmn.excel.FileDto;
import com.example.demo.service.FileService;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class FileUpldController {

    @Autowired
    private FileService fService;

    private String storagePath = "D:/storage/";
    
    @PostMapping(value = "/file_upld")
    public ResponseEntity<ArrayList<FileDto>> upload(
            @RequestPart("file") List<MultipartFile> files
            , Authentication authentication
            ) throws Exception  {
        ArrayList<FileDto> al = new ArrayList<FileDto>();
        final String fileGroup =UUID.randomUUID()+"";
        for(int i=0;i<files.size();i++) {
            MultipartFile t=files.get(i);
            FileDto  tmp=uploadFile(fileGroup,t);
            try {
                
                fService.createFile(tmp,authentication);
            } catch (Exception e) {
                log.error(e.getMessage(),e);
                File f= new File(tmp.getSvrDirPath(),tmp.getSvrFileNm());
                if(f.exists()) {
                    f.delete();
                }
            }
            al.add(tmp);
        }
        
        return ResponseEntity.created(null).body(al);
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

        
     
        final String contentType = mf.getContentType();
        
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
                log.error(ie.getMessage(),ie);
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
            log.error(ie.getMessage(),ie);
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
        fDto.setFileSize(fileSize);
        fDto.setContentType(contentType);
        
        return fDto;
    }
    

}
