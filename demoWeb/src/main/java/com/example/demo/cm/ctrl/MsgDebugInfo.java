package com.example.demo.cm.ctrl;

import java.io.Serializable;

public class MsgDebugInfo  implements Serializable  {
    String UUID="";
    int SEQ=0;
	String Br="";
	String IN_DATA_JSON="";
	String OUT_DATA_JSON="";
    public String getUUID() {
        return UUID;
    }
    public void setUUID(String uUID) {
        UUID = uUID;
    }
    public int getSEQ() {
        return SEQ;
    }
    public void setSEQ(int sEQ) {
        SEQ = sEQ;
    }
    public String getBr() {
        return Br;
    }
    public void setBr(String br) {
        Br = br;
    }
    public String getIN_DATA_JSON() {
        return IN_DATA_JSON;
    }
    public void setIN_DATA_JSON(String iN_DATA_JSON) {
        IN_DATA_JSON = iN_DATA_JSON;
    }
    public String getOUT_DATA_JSON() {
        return OUT_DATA_JSON;
    }
    public void setOUT_DATA_JSON(String oUT_DATA_JSON) {
        OUT_DATA_JSON = oUT_DATA_JSON;
    }
	  
}
