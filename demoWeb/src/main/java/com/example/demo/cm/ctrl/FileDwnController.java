package com.example.demo.cm.ctrl;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.PostMapping;
import com.example.demo.dmn.excel.FileDto;
import com.example.demo.service.FileService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class FileDwnController {

    @Autowired
    private FileService fService;
    
    @GetMapping(value = "/file_dwn/{FILE_ID}")
    public  ResponseEntity<Resource> dwn(
            @PathVariable("FILE_ID") String FILE_ID
            , Authentication authentication
            ) throws Exception {
        ArrayList<FileDto>  al= fService.getFile(FILE_ID, authentication);
        if(al.size()>0) {
            FileDto fDto= al.get(0);
            String FILE_PULL_PATH = fDto.getSvrDirPath()+fDto.getSvrFileNm();
            Path path = Paths.get(FILE_PULL_PATH);
            String contentType = Files.probeContentType(path);

            // Fallback to the default content type if type could not be determined
            if(contentType == null) {
                contentType = "application/octet-stream";
            }
            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_TYPE, contentType);
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fDto.getOrgFileNm() + "\"");
            Resource resource = new InputStreamResource(Files.newInputStream(path));
            return new ResponseEntity<>(resource, headers, HttpStatus.OK);
        }
        return null;
        
        
    }
}
