package com.example.demo.cm.ctrl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import com.example.demo.dmn.excel.FileDto;
import com.example.demo.exception.BizException;
import com.example.demo.service.FileService;
import com.example.demo.user.domain.UserInfo;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonRootName;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiOperation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.Data;

@Tag(name = "CM_FILE", description = "파일")
@RestController
public class FileDeleteController {
    
    @JsonRootName("IN_DS")
    @ApiModel(value="IN_DS-FileDeleteController")
    @Data
    static class IN_DS {
        @JsonProperty("brRq")
        @Schema(name = "brRq", example = "IN_DATA,LSESSION", description = "입력 데이터명")
        String brRq;

        @JsonProperty("brRs")
        @Schema(name = "brRs", example = "OUT_DATA", description = "출력 데이터명")
        String brRs;
        
        @JsonProperty("IN_DATA")
        @Schema(name="IN_DATA-FileDeleteController", description = "입력 데이터")
        ArrayList<IN_DATA_ROW> IN_DATA = new ArrayList<IN_DATA_ROW>();
                
        @JsonProperty("LSESSION")
        LSESSION_ROW LSESSION;
    }

    @JsonRootName("OUT_DS")
    @ApiModel(value="OUT_DS-FileDeleteController")
    @Data
    static class OUT_DS {
        @JsonProperty("OUT_DATA")
        @Schema(name = "OUT_DATA", title="OUT_DATA-FileDeleteController", description = "출력 데이터")
        ArrayList<String> OUT_DATA = new ArrayList<String>();
    }

    @ApiModel(value="IN_DATA_ROW-FileDeleteController")
    @Data
    static class IN_DATA_ROW {
        @JsonProperty("FILE_ID")
        @Schema(name = "FILE_ID", example = "1", description = "파일ID")
        String FILE_ID = null;
        
        @JsonProperty("FILE_STATUS_CD")
        @Schema(name = "FILE_STATUS_CD", example = "(T-임시,M-매핑,D-삭제", description = "파일상태")
        String FILE_STATUS_CD = null;
    }

    @Autowired
    private FileService fService;
    
    private String storageRmPath = "D:/storage/rm/";
        
    @ApiResponses(value = { @ApiResponse(responseCode = "200", description = "successful operation", content = {
            @Content(mediaType = "application/json", schema = @Schema(implementation = OUT_DS.class)) }) 
    })
    @ApiOperation(tags={"CM_FILE"},value = "파일을 삭제한다.", notes = "")
    @PostMapping(path= "/file_del", consumes = "application/json", produces = "application/json")
    public OUT_DS run(@RequestBody IN_DS inDS
            , Authentication authentication
            ) throws BizException, IOException  {
        UserInfo userInfo = (UserInfo) authentication.getPrincipal();
        if(userInfo==null) {
            throw new BizException("세션값이 넘어오지 않았습니다1.");
        }
        Long LSESSION_USER_NO=userInfo.getUserNo();
      
        if (inDS.IN_DATA.size() == 0 ) {
            throw new BizException("입력파라미터가 잘못되었습니다.");
        }
        for(int i=0;i<inDS.IN_DATA.size();i++) {
            String FILE_ID          = inDS.IN_DATA.get(i).getFILE_ID();
            String FILE_STATUS_CD   = inDS.IN_DATA.get(i).getFILE_STATUS_CD();
            if(!FILE_STATUS_CD.equals("D")) {
                ArrayList<FileDto>  al= fService.getFile(FILE_ID, authentication);
                if(al.size()>0) {
                    FileDto fDto= al.get(0);
                    if(!fDto.getFileStatusCd().equals("D")) {
                        String FILE_PULL_PATH = fDto.getSvrDirPath()+fDto.getSvrFileNm();
                        File f = new File(FILE_PULL_PATH);
                        if(f.exists()) {
                            File fileToMove = new File(storageRmPath,fDto.getSvrFileNm());
                            org.apache.commons.io.FileUtils.moveFile(f, fileToMove);
                            fDto.setSvrDirPath(storageRmPath);
                            try {
                                fService.rmFile(fDto, authentication);
                            } catch (Exception e) {
                                org.apache.commons.io.FileUtils.moveFile(fileToMove,f);
                                e.printStackTrace();
                            }    
                        }
                    }
                }
            }
        }
        OUT_DS outDs = new OUT_DS();
        return outDs;
    }
}
