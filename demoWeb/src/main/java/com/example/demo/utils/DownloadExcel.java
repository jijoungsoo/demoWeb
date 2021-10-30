package com.example.demo.utils;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
//https://haenny.tistory.com/103
public class DownloadExcel {
    private static final Logger LOGGER = LoggerFactory.getLogger(DownloadExcel.class);
    private HttpServletResponse response;
    private HSSFWorkbook wb;
    
    public DownloadExcel(String filename, HttpServletRequest request, HttpServletResponse response, HSSFWorkbook wb) { 
        this.response = response; 
        this.wb = wb; 
        try { 
            PjtUtil pjtU = new PjtUtil();
            String browser = pjtU.getBrowser(request); 
            // 브라우저 확인하는 메서드 
            String encodedFilename = null; 
            if (browser.equals("MSIE")) { 
                encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll( "\\+", "%20"); 
            } else if (browser.equals("Firefox")) { 
                encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\""; 
            } else if (browser.equals("Opera")) { 
                encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\""; 
            } else if (browser.equals("Chrome")) { 
                StringBuffer sb = new StringBuffer(); 
                for (int i = 0;i < filename.length();i++) { 
                    char c = filename.charAt(i); 
                    if (c > '~') { 
                        sb.append(URLEncoder.encode("" + c, "UTF-8")); 
                    } else { 
                        sb.append(c); 
                    } 
                } 
                encodedFilename = sb.toString(); 
            } else { 
                throw new IOException("Not supported browser"); 
            } 
            
            if (browser.indexOf("MSIE 5.5") > -1) {
                response.setHeader("Content-Disposition", "filename=" + encodedFilename + ";");
            } else {
                response.setContentType("application/vnd.ms-excel");
                response.setHeader("Content-Disposition", "attachment; filename=" + encodedFilename + ";");
            }
        } catch (IOException e) { 
            LOGGER.error("[Excel Download Error]"); 
        } 
    }
   

    public void writeExcel() {
        ServletOutputStream sos = null;
        try {
            sos = response.getOutputStream();
            sos.flush();
            wb.write(sos);
            wb.close();
            sos.flush();
        } catch (IOException e) {
            LOGGER.error("[Excel Download Error]");
        } finally {
            if (sos != null) {
                try {
                    sos.close();
                } catch (IOException e) {
                    LOGGER.error("[Excel Download Error]");
                }
            }
            if (wb != null) {
                try {
                    wb.close();
                } catch (IOException e) {
                    LOGGER.error("[Excel Download Error]");
                }
            }
        }
    }

    public CellStyle headStyle() {
        HSSFFont font = wb.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.WHITE.index);
        CellStyle style = wb.createCellStyle();
        style.setFont(font);
        style.setWrapText(true);
        style.setFillForegroundColor(IndexedColors.ROYAL_BLUE.index);
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        return style;
    }

    public CellStyle bodyStyle() {
        HSSFFont font = wb.createFont();
        CellStyle style = wb.createCellStyle();
        style.setFont(font);
        style.setWrapText(true);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        return style;
    }
}