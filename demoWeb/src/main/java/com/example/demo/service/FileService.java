package com.example.demo.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.example.demo.cm.ctrl.MsgDebugInfo;
import com.example.demo.dmn.excel.ExcelDto;
import com.example.demo.dmn.excel.FileDto;
import com.example.demo.exception.BizException;
import com.example.demo.utils.ExcelUtils;
import com.example.demo.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
public class FileService {
    @Autowired
    GoRestService goS;

    
    public ArrayList<FileDto>  getFile(String FILE_ID, Authentication authentication) {
        HashMap<String, ArrayList<HashMap<String, Object>>> outDs = new HashMap<String, ArrayList<HashMap<String, Object>>>();
        try {
            HashMap<String, Object> IN_DS = new HashMap<String, Object>();
            IN_DS.put("brRq", "IN_DATA");
            IN_DS.put("brRs", "OUT_DATA");
            ArrayList<HashMap<String, Object>> in_date = new ArrayList<HashMap<String, Object>>();
            HashMap<String, Object> tmp = new HashMap<String, Object>();
            tmp.put("FILE_ID", FILE_ID);
            in_date.add(tmp);
            IN_DS.put("IN_DATA", in_date);

            String jsonInString = PjtUtil.ObjectToJsonString(IN_DS);
            MsgDebugInfo msg = PjtUtil.makeLSession("BR_CM_FILE_FIND_BY_FILE_ID", jsonInString, authentication);
            String jsonOutString = goS.callAPI("BR_CM_FILE_FIND_BY_FILE_ID", msg.getIN_DATA_JSON());
            outDs = PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        ArrayList<HashMap<String, Object>> tmp = outDs.get("OUT_DATA");
        ArrayList<FileDto> OUT_DATA = new ArrayList<FileDto>();
        for(int i=0;i<tmp.size();i++) {
            HashMap<String, Object> tmp2 = tmp.get(i); 
            FileDto Dto = new FileDto();
            Dto.setFileId(tmp2.get("FILE_ID").toString());
            Dto.setFileGroup(tmp2.get("FILE_GROUP").toString());
            Dto.setOrgFileNm(tmp2.get("ORG_FILE_NM").toString());
            Dto.setSvrDirPath(tmp2.get("SVR_DIR_PATH").toString());
            Dto.setSvrFileNm(tmp2.get("SVR_FILE_NM").toString());
            Dto.setExt(tmp2.get("EXT").toString());
            Long L_FILE_SIZE = Long.parseLong(tmp2.get("FILE_SIZE").toString());
            Dto.setFileSize(L_FILE_SIZE);
            Dto.setContentType(tmp2.get("CONTENT_TYPE").toString());
            Dto.setFileStatusCd(tmp2.get("FILE_STATUS_CD").toString());
            
            
            
            OUT_DATA.add(Dto);
            
        }
        return OUT_DATA;
    }
    

    public HashMap<String, ArrayList<HashMap<String, Object>>> createExcelFile(ArrayList<FileDto> al, Authentication authentication) throws BizException, JsonProcessingException {
        List<HashMap<String, Object>> all_list = new ArrayList<HashMap<String, Object>>();
        for (int i = 0; i < al.size(); i++) {
            FileDto fDto = al.get(i);
            final String svrFileNm = fDto.getSvrFileNm();
            final String storagePath = fDto.getSvrDirPath();
            final String filePath = storagePath + svrFileNm;
            File f = new File(filePath);
            if (f.exists()) {
                List<ExcelDto> list = ExcelUtils.getExcelUpload(fDto.getFileId(), f.getAbsolutePath());
                for (int j = 0; j < list.size(); j++) {
                    ExcelDto tmp = list.get(j);
                    HashMap<String, Object> m = new HashMap<String, Object>();
                    m.put("EXCEL_UPLD_ID", tmp.getExcelUpldId());
                    m.put("EXCEL_SEQ", tmp.getExcelSeq());
                    m.put("GBN", tmp.getGbn());
                    m.put("COL00", tmp.getCol00());
                    m.put("COL01", tmp.getCol01());
                    m.put("COL02", tmp.getCol02());
                    m.put("COL03", tmp.getCol03());
                    m.put("COL04", tmp.getCol04());
                    m.put("COL05", tmp.getCol05());
                    m.put("COL06", tmp.getCol06());
                    m.put("COL07", tmp.getCol07());
                    m.put("COL08", tmp.getCol08());
                    m.put("COL09", tmp.getCol09());
                    m.put("COL10", tmp.getCol10());
                    m.put("COL11", tmp.getCol11());
                    m.put("COL12", tmp.getCol12());
                    m.put("COL13", tmp.getCol13());
                    m.put("COL14", tmp.getCol14());
                    m.put("COL15", tmp.getCol15());
                    m.put("COL16", tmp.getCol16());
                    m.put("COL17", tmp.getCol17());
                    m.put("COL18", tmp.getCol18());
                    m.put("COL19", tmp.getCol19());
                    m.put("COL20", tmp.getCol20());
                    all_list.add(m);
                }
            }
        }

        HashMap<String, ArrayList<HashMap<String, Object>>> outDs = new HashMap<String, ArrayList<HashMap<String, Object>>>();
        HashMap<String, Object> IN_DS = new HashMap<String, Object>();
        IN_DS.put("brRq", "IN_DATA");
        IN_DS.put("brRs", "OUT_DATA");
        IN_DS.put("IN_DATA", all_list);
        String jsonInString = PjtUtil.ObjectToJsonString(IN_DS);
        MsgDebugInfo msg = PjtUtil.makeLSession("BR_CM_EXCEL_UPLD_CREATE", jsonInString, authentication);
        String jsonOutString = goS.callAPI("BR_CM_EXCEL_UPLD_CREATE", msg.getIN_DATA_JSON());
        outDs = PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
        return outDs;
    }

    public void createFile(FileDto  tmp, Authentication authentication
            ) throws JsonProcessingException, BizException {
        ArrayList<HashMap<String,Object>> in_al = new ArrayList<HashMap<String,Object>>();
        HashMap<String,Object> m= new HashMap<String,Object>();
        m.put("FILE_ID",tmp.getFileId());
        m.put("FILE_GROUP",tmp.getFileGroup());
        m.put("ORG_FILE_NM",tmp.getOrgFileNm());
        m.put("EXT",tmp.getExt());
        m.put("SVR_FILE_NM",tmp.getSvrFileNm());
        m.put("SVR_DIR_PATH",tmp.getSvrDirPath());
        m.put("FILE_STATUS_CD",tmp.getFileStatusCd());
        m.put("FILE_SIZE",tmp.getFileSize().toString());
        m.put("CONTENT_TYPE",tmp.getContentType());
        in_al.add(m);

        HashMap<String,Object> IN_DS = new HashMap<String,Object>();
        IN_DS.put("brRq","IN_DATA");
        IN_DS.put("brRs","OUT_DATA");
        IN_DS.put("IN_DATA",in_al);

        String jsonInString=PjtUtil.ObjectToJsonString(IN_DS);
        MsgDebugInfo msg = PjtUtil.makeLSession("BR_CM_FILE_CREATE",jsonInString,authentication);
        
        String jsonOutString = goS.callAPI("BR_CM_FILE_CREATE", msg.getIN_DATA_JSON());
        PjtUtil.JsonStringToObject(jsonOutString, HashMap.class);
        
    }

    public void rmFile(FileDto fDto, Authentication authentication
            ) throws JsonProcessingException, BizException {
        HashMap<String, Object> IN_DS = new HashMap<String, Object>();
        IN_DS.put("brRq", "IN_DATA");
        IN_DS.put("brRs", "OUT_DATA");
        ArrayList<HashMap<String, Object>> in_date = new ArrayList<HashMap<String, Object>>();
        HashMap<String, Object> tmp = new HashMap<String, Object>();
        tmp.put("FILE_ID", fDto.getFileId());
        tmp.put("SVR_DIR_PATH", fDto.getSvrDirPath());
        in_date.add(tmp);
        IN_DS.put("IN_DATA", in_date);

        String jsonInString = PjtUtil.ObjectToJsonString(IN_DS);
        MsgDebugInfo msg = PjtUtil.makeLSession("BR_CM_FILE_RM", jsonInString, authentication);
        String jsonOutString = goS.callAPI("BR_CM_FILE_RM", msg.getIN_DATA_JSON());
    }
}
