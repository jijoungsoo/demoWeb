package com.example.demo.utils;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;

public class ExportExcelVOList {
    private HttpServletRequest req;
    private HttpServletResponse res;
    protected HSSFSheet[] sheetArray;
    protected HSSFWorkbook wb;
    protected DownloadExcel downloadExcel;
    protected String colN[];
    protected CellStyle headStyle;
    protected CellStyle bodyStyle;

    public ExportExcelVOList(HttpServletRequest request, HttpServletResponse response) {
        this.req = request;
        this.res = response;
        this.sheetArray = new HSSFSheet[1];
        this.wb = new HSSFWorkbook();
        /*
        if (!PjtUtil.isEmpty(colN)) {
            this.colN = colN.split(",");
        }
        */
        this.setExcelFormat();
    }

    /* 필수 exl.setListData 로 가져온 HSSFSheet를 넘겨줘야함 */ 
    public void setSheetArray(int index, HSSFSheet st) {
        sheetArray[index] = st;
    }

    /* 필수 모든 세팅이 완료된 후 엑셀 다운로드 받는 메소드 */ 
    public void actionDownloadExcel() {
        downloadExcel.writeExcel();
    }

    /* 파라메터로 넘어온 엑셀명 혹은 다운받은 일시를 파일명으로 엑셀파일 생성 */ 
    private void setExcelFormat() {
        long time = System.currentTimeMillis();
        SimpleDateFormat day = new SimpleDateFormat("yyyyMMddhhmmss");
        String excelnm = day.format(time);
        this.downloadExcel = new DownloadExcel(excelnm + ".xls", req, res, wb);
        this.headStyle = downloadExcel.headStyle();
        this.bodyStyle = downloadExcel.bodyStyle();
    }

    /* 컬럼 스타일 세팅 및 컬럼제목 입력 */
    private void setColumnStyle(HSSFSheet st
            , HSSFRow title
            , int width
            , int stIdx
            , LinkedHashMap<String, Object> data) {
        int edIdx = 0;
        Set<String> set = data.keySet();
        Iterator<String> iter= set.iterator();
        while(iter.hasNext()) {
            String key = iter.next();
            Object value = data.get(key);
            int tmp_idx=stIdx + edIdx;
            if(value!=null) {
                title.createCell(tmp_idx).setCellValue(value.toString());    
            } else {
                title.createCell(tmp_idx);
            }
            title.getCell(tmp_idx).setCellStyle(headStyle);
            edIdx++;
        }
    }

    /* VO data를 파라메터로 생성할 각 시트에 세팅 */
    public HSSFSheet setDataToExcelList(ArrayList<LinkedHashMap<String,Object>>  data, String sheetName) {
        HSSFSheet st = null;
        try {
            st = wb.createSheet(sheetName);
            HSSFRow titleRow = st.createRow(0);
            titleRow.setHeight((short) 400);
            if(data.size()>1) {
                setColumnStyle(st, titleRow, 6000, 0,data.get(0));    
            }
            
// colN을 이용한 컬럼명 처리 
            for (int i = 1; i < data.size(); i++) {
                HSSFRow row = st.createRow(st.getLastRowNum() + 1);
                row = setRowData(row, data.get(i), 0,st);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return st;
    }

    /* VO data를 파라메터로 해당 데이터 셀에 입력 */
    private HSSFRow setRowData(HSSFRow row, LinkedHashMap<String,Object> data, int stIdx
            , HSSFSheet st
            )
            throws IllegalArgumentException, IllegalAccessException {
        int edIdx = 0;
        
        Set<String> set = data.keySet();
        Iterator<String> iter= set.iterator();
        while(iter.hasNext()) {
            String key = iter.next();
            Object value = data.get(key);
            int tmp_idx=stIdx + edIdx;
            if(value!=null) {
                row.createCell(tmp_idx).setCellValue(value.toString());    
            } else {
                row.createCell(tmp_idx);
            }
            //너비자동조절
            //st.autoSizeColumn(tmp_idx);
            //st.setColumnWidth(tmp_idx, (st.getColumnWidth(tmp_idx)) + 512);
            edIdx++;
        }
        for (int i = 0; i < edIdx; i++) {
            row.getCell(stIdx + i).setCellStyle(bodyStyle);
        }
        return row;
    }
    
    public void autoSizeColumns() {
        int numberOfSheets = wb.getNumberOfSheets();
        for (int i = 0; i < numberOfSheets; i++) {
            HSSFSheet sheet = wb.getSheetAt(i);
            if (sheet.getPhysicalNumberOfRows() > 0) {
                HSSFRow row = sheet.getRow(sheet.getFirstRowNum());
                Iterator<Cell> cellIterator = row.cellIterator();
                while (cellIterator.hasNext()) {
                    Cell cell = cellIterator.next();
                    int columnIndex = cell.getColumnIndex();
                    sheet.autoSizeColumn(columnIndex);
                }
            }
        }
    }
}
