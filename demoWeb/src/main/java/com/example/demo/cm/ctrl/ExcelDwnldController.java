package com.example.demo.cm.ctrl;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFSheet;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.example.demo.dmn.excel.FileDto;
import com.example.demo.exception.BizException;
import com.example.demo.service.FileService;
import com.example.demo.service.GoRestService;
import com.example.demo.utils.ExportExcelVOList;
import com.example.demo.utils.PjtUtil;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ExcelDwnldController {
    @Autowired
    private GoRestService goService;

    /*
     * consumes 입력타입 produces 리턴타입
     */
    @RequestMapping(value = "/EXCEL_DWNLD/{br}", method = RequestMethod.POST, consumes = "application/json", produces="text/plain;Charset=UTF-8")
    public void exceldownload(@PathVariable("br") String br, @RequestBody String jsonInString, HttpServletRequest req,
            HttpServletResponse res, Authentication authentication, HttpSession session) throws Exception {
        log.info("jsonInString=>" + jsonInString);
        String jsonOutString = null;
        MsgDebugInfo msg = PjtUtil.makeLSession(br, jsonInString, authentication);
        HashMap<String, Object> result = new HashMap<String, Object>();
        try {
            jsonOutString = goService.callAPI(br, msg.IN_DATA_JSON);
            PjtUtil.saveSesstionDebugMsg(msg, jsonOutString, session);
        } catch (HttpClientErrorException  e) {
            result.put("statusCode", e.getRawStatusCode());
            result.put("body", e.getStatusText());
            e.printStackTrace();
            PjtUtil.saveSesstionDebugMsg(msg, PjtUtil.ObjectToJsonString(result), session);
            throw  e;
        } catch (HttpServerErrorException e) {
            result.put("statusCode", e.getRawStatusCode());
            result.put("body", e.getStatusText());
            e.printStackTrace();
            PjtUtil.saveSesstionDebugMsg(msg, PjtUtil.ObjectToJsonString(result), session);
            throw  e;
        } catch (Exception e) {
            result.put("statusCode", "999");
            result.put("body", "excpetion오류");
            e.printStackTrace();
            PjtUtil.saveSesstionDebugMsg(msg, PjtUtil.ObjectToJsonString(result), session);
            throw  e;
        }
        try {
            
            IN_DS inDS= PjtUtil.JsonStringToObject(jsonInString, IN_DS.class);
            System.out.println(jsonOutString);
            OUT_DS outDS= PjtUtil.JsonStringToObject(jsonOutString, OUT_DS.class);
            /*
             * var param = {
                        brRq : 'IN_DATA',
                        brRs : 'OUT_DATA',
                        IN_DATA : [ {} ]
                    }
             * */
            if(inDS.get("brRs")!=null) {
                String brRs = inDS.get("brRs").toString();
                System.out.println(brRs);
                String[] arrBrRs = brRs.split(",");
                ExportExcelVOList exl = new ExportExcelVOList(req, res);
                for(int i=0;i<arrBrRs.length;i++) {
                    String tmp = arrBrRs[i];
                    System.out.println(tmp);
                    if(!PjtUtil.isEmpty(tmp)) {
                        ArrayList<LinkedHashMap<String,Object>>  al= outDS.get(tmp);
                        HSSFSheet st = exl.setDataToExcelList(al, "sheet" + i);
                        exl.setSheetArray(i, st);
                        for(int colNum = 0; colNum<st.getRow(0).getLastCellNum();colNum++) {
                            st.autoSizeColumn(colNum);
                            st.setColumnWidth(colNum, (st.getColumnWidth(colNum)) + 1000);
                        }
                    }
                }
                //exl.autoSizeColumns();
                exl.actionDownloadExcel();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
