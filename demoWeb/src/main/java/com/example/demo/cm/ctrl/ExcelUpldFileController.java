package com.example.demo.cm.ctrl;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import com.example.demo.dmn.excel.FileDto;
import com.example.demo.service.FileService;
import com.example.demo.utils.PjtUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ExcelUpldFileController {
    /*
     * consumes 입력타입 
     * produces 리턴타입
     */
    @Autowired
    private FileService fService;
    

    @PostMapping(path= "/EXCEL_CREATE_DATA", consumes=MediaType.APPLICATION_FORM_URLENCODED_VALUE,  produces = "application/json")
    public ResponseEntity<Object> excelCreateData(
             @RequestParam("FILE_ID") String FILE_ID, 
             Authentication authentication,
             HttpSession session 
            )
            throws Exception {
        if(PjtUtil.isEmpty(FILE_ID)==false) {
            try {
                ArrayList<FileDto> OUT_DATA=fService.getFile(FILE_ID,  authentication);
                HashMap<String, ArrayList<HashMap<String, Object>>> OUT_DS= fService.createExcelFile(OUT_DATA, authentication);
                return ResponseEntity.created(null).body(OUT_DS);
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(e.getMessage());
            }
            
            
            
        }
        return ResponseEntity.created(null).body(null);
    }

}
