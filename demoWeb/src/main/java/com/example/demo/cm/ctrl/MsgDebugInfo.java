package com.example.demo.cm.ctrl;

import java.io.Serializable;

public class MsgDebugInfo  implements Serializable  {
    String UUID="";
    int SEQ=0;
	String LOG_UUID="";
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
    public String getLOG_UUID() {
        return LOG_UUID;
    }
    public void SetLOG_UUID(String LOG_UUID) {
         this.LOG_UUID=LOG_UUID;
    }
}
