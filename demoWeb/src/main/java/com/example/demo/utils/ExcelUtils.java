package com.example.demo.utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import javax.validation.ValidatorFactory;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.formula.eval.ErrorEval;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.example.demo.dmn.excel.ExcelDto;
import com.github.drapostolos.typeparser.TypeParser;
import com.github.drapostolos.typeparser.TypeParserException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class ExcelUtils {
public static List<ExcelDto> getExcelUpload(String fileId,String excelFile){
        log.info("@@@@@@@@@@@@@@@getExcelUpload START@@@@@@@@@@@@@@@ "+excelFile);
        List<ExcelDto> list = new ArrayList<ExcelDto>();
        try {
            Workbook wbs = ExcelUtils.getWorkbook(excelFile);
            Sheet sheet = (Sheet) wbs.getSheetAt(0);
            //excel file 두번쨰줄부터 시작
            ///final int rowCount = sheet.getPhysicalNumberOfRows();  이거가 아니고 getLastRownum을 사용해야한다.
            //https://m.blog.naver.com/PostView.nhn?blogId=json2811&logNo=90107369361&proxyReferer=https:%2F%2Fwww.google.com%2F
            log.info("sheet.getFirstRowNum() : "+sheet.getFirstRowNum());
            log.info("sheet.getLastRowNum() : "+sheet.getLastRowNum());
            for (int i = sheet.getFirstRowNum() ; i <= sheet.getLastRowNum(); i++) {
                log.info("@@@@@@@@map @@@@@@@@@@@@@@@@ i : "+i);
                Row row = sheet.getRow(i);
                if(isPass(row)==false) {
                    ExcelDto m= new ExcelDto();
                    LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
                    m.setExcelUpldId(fileId);
                    if(i==0) {
                        m.setGbn("H");
                    } else {
                        m.setGbn("D");
                    }
                    m.setExcelSeq(i);
                    m.setCol00(ExcelUtils.getValue(row.getCell(0)));
                    m.setCol01(ExcelUtils.getValue(row.getCell(1)));
                    m.setCol02(ExcelUtils.getValue(row.getCell(2)));
                    m.setCol03(ExcelUtils.getValue(row.getCell(3)));
                    m.setCol04(ExcelUtils.getValue(row.getCell(4)));
                    m.setCol05(ExcelUtils.getValue(row.getCell(5)));
                    m.setCol06(ExcelUtils.getValue(row.getCell(6)));
                    m.setCol07(ExcelUtils.getValue(row.getCell(7)));
                    m.setCol08(ExcelUtils.getValue(row.getCell(8)));
                    m.setCol09(ExcelUtils.getValue(row.getCell(9)));
                    m.setCol10(ExcelUtils.getValue(row.getCell(10)));
                    m.setCol11(ExcelUtils.getValue(row.getCell(11)));
                    m.setCol12(ExcelUtils.getValue(row.getCell(12)));
                    m.setCol13(ExcelUtils.getValue(row.getCell(13)));
                    m.setCol14(ExcelUtils.getValue(row.getCell(14)));
                    m.setCol15(ExcelUtils.getValue(row.getCell(15)));
                    m.setCol16(ExcelUtils.getValue(row.getCell(16)));
                    m.setCol17(ExcelUtils.getValue(row.getCell(17)));
                    m.setCol18(ExcelUtils.getValue(row.getCell(18)));
                    m.setCol19(ExcelUtils.getValue(row.getCell(19)));
                    m.setCol20(ExcelUtils.getValue(row.getCell(20)));
                    list.add(m);
                }
            }
        }catch(Exception e){
            log.error("error : "+e.getMessage());
            log.error("error : "+e);
        }
        log.info("@@@@@@@@@@@@@@@getExcelUpload END@@@@@@@@@@@@@@@");
        return list;
    }
    public static Workbook getWorkbook(String filePath) {
        FileInputStream fis = null;
        try {
            fis = new FileInputStream(filePath);
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e.getMessage(), e);
        }
        Workbook wb = null;
        if (filePath.toUpperCase().endsWith(".XLS")) {
            try {
                wb = new HSSFWorkbook(fis);
            } catch (IOException e) {
                throw new RuntimeException(e.getMessage(), e);
            }
        } else if (filePath.toUpperCase().endsWith(".XLSX")) {
            try {
                wb = new XSSFWorkbook(fis);
            } catch (IOException e) {
                throw new RuntimeException(e.getMessage(), e);
            }
        }
        return wb;
    }

    public static String getValue(Cell cell) {
        String value = null;
        
        if(cell==null) {
            return null;
        }
        // 셀 내용의 유형 판별
        switch (cell.getCellType()) {
        case STRING: // getRichStringCellValue() 메소드를 사용하여 컨텐츠를 읽음
            value = cell.getRichStringCellValue().getString();
            break;
        case NUMERIC: // 날짜 또는 숫자를 포함 할 수 있으며 아래와 같이 읽음
            if (DateUtil.isCellDateFormatted(cell))
                value = cell.getLocalDateTimeCellValue().toString();
            else
                value = String.valueOf(cell.getNumericCellValue());
            if (value.endsWith(".0"))
                value = value.substring(0, value.length() - 2);
            break;
        case BOOLEAN:
            value = String.valueOf(cell.getBooleanCellValue());
            break;
        case FORMULA:
            value = String.valueOf(cell.getCellFormula());
            break;
        case ERROR:
            value = ErrorEval.getText(cell.getErrorCellValue());
            break;
        case BLANK:
        case _NONE:
        default:
            value = "";
        }
        return value.trim();
    }
    
    private static boolean isPass(Row row) {
        int i =0;
        boolean isPass = true;
        while (i < row.getPhysicalNumberOfCells()) {
            if(StringUtils.isNotEmpty(ExcelUtils.getValue(row.getCell(i++))))
                isPass = false;
                break;
        }
        return isPass;
    }
}
