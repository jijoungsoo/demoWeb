package com.example.demo.cm.ctrl;

import java.util.ArrayList;
import java.util.LinkedHashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.example.demo.utils.ExportExcelVOList;
import com.example.demo.utils.PjtUtil;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class GridDwnldController {
    @Autowired
	PjtUtil pjtU;

    @RequestMapping(value = "/GRID_DWNLD/{fileName}", method = RequestMethod.POST, consumes = "application/json", produces="text/plain;Charset=UTF-8")
    public void exceldownload(@PathVariable("fileName") String fileName, @RequestBody String jsonInString, HttpServletRequest req,
            HttpServletResponse res, Authentication authentication, HttpSession session) throws Exception {
        log.info("GRID_DWNLD==fileName=>" + fileName);
        try {
            
            IN_DS inDS= pjtU.JsonStringToObject(jsonInString, IN_DS.class);
            ExportExcelVOList exl = new ExportExcelVOList(req, res,fileName);
            ArrayList<LinkedHashMap<String,Object>>  al= (ArrayList<LinkedHashMap<String,Object>>) inDS.get("IN_DATA");
            HSSFSheet st = exl.setDataToExcelList(al, "sheet0");
            exl.setSheetArray(0, st);
            for(int colNum = 0; colNum<st.getRow(0).getLastCellNum();colNum++) {
                st.autoSizeColumn(colNum);
                st.setColumnWidth(colNum, (st.getColumnWidth(colNum)) + 1000);
            }
            exl.actionDownloadExcel();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
