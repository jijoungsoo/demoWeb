package com.example.demo.cm.ctrl;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import lombok.extern.slf4j.Slf4j;
import javax.sql.DataSource;

import com.example.demo.utils.PjtUtil;

import org.springframework.core.io.ResourceLoader;

@Slf4j
@RestController
public class JdbcApiRestController {
    @Autowired
    private DataSource dataSource;

    @Autowired
    private ResourceLoader resourceLoader;

    @Autowired
    PjtUtil pjtU;

    
    @PostMapping(path = "/jdbc/getOutColumns", consumes = "application/json", produces = "application/json")
	public ResponseEntity<Object> getOutColumns(@RequestBody Map<String,Object> params,Authentication authentication, HttpSession session) throws Exception {
        HashMap<String,Object>  result = new HashMap<String,Object>();
        //String sql = "SELECT ID, NAME, EMAIL FROM MEMBER";
        String sql =String.valueOf(params.get("SQL")) + " limit 1";
        System.out.println(sql);
        //
        Connection conn =dataSource.getConnection();
		Statement stmt = conn.createStatement();
        try{
            ResultSet rs = stmt.executeQuery(sql);  //select
            ///stmt.executeUpdate(sql);  //insert,upodate,delete
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnCount = rsmd.getColumnCount(); 
            ArrayList<HashMap<String,Object>> al = new ArrayList<HashMap<String,Object>>();
            
            for(int i=1; i<=columnCount; i++) {
                HashMap<String,Object>  data = new HashMap<String,Object>();
                data.put("c", rsmd.getColumnName(i).toUpperCase());
                al.add(data);
            }
            rs.close();
            result.put("status","ok");
            result.put("data",al);
        } catch (Exception e) {
            log.error(e.getMessage(),e);
            result.put("status","nok");
            result.put("error",e.getMessage());            
        } finally{
            stmt.close();
            conn.close();
        }
		
        
        
		return ResponseEntity.ok(result);
	}

    @PostMapping(path = "/jdbc/runSelect", consumes = "application/json", produces = "application/json")
	public ResponseEntity<Object> runSelect(@RequestBody Map<String,Object> params,Authentication authentication, HttpSession session) throws Exception {
        HashMap<String,Object>  result = new HashMap<String,Object>();
        //String sql = "SELECT ID, NAME, EMAIL FROM MEMBER";
        String sql =String.valueOf(params.get("SQL"));
        System.out.println(sql);
        //
        Connection conn =dataSource.getConnection();
		Statement stmt = conn.createStatement();
        try{
            ArrayList<HashMap<String,String>> al = new ArrayList<HashMap<String,String>>();
            ResultSet rs = stmt.executeQuery(sql);  //select
            ///stmt.executeUpdate(sql);  //insert,upodate,delete
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnCount = rsmd.getColumnCount(); 
            String[] columnNames  = new String[columnCount]; 
              
            for(int i=1; i<=columnCount; i++) {
                columnNames[i-1] = rsmd.getColumnName(i); 
            }
            while(rs.next()) {
                HashMap<String,String>  data = new HashMap<String,String>();
                for (String columnName: columnNames) {
                    data.put(columnName.toUpperCase(),pjtU.str(rs.getObject(columnName)));
                }
                al.add(data);
            }
            rs.close();
            result.put("status","ok");
            result.put("data",al);
        } catch (Exception e){
            log.error(e.getMessage(),e);
            result.put("status","nok");
            result.put("error",e.getMessage());            
        } finally {
            stmt.close();
            conn.close();
        }       
        
		return ResponseEntity.ok(result);
	}

    
    @PostMapping(path = "/jdbc/runSQL", consumes = "application/json", produces = "application/json")
	public ResponseEntity<Object> runSQL(@RequestBody Map<String,Object> params,Authentication authentication, HttpSession session) throws Exception {

        //String sql = "SELECT ID, NAME, EMAIL FROM MEMBER";
        String sql =String.valueOf(params.get("SQL"));
        System.out.println(sql);
        //
        HashMap<String,Object>  result = new HashMap<String,Object>();
        Connection conn =dataSource.getConnection();
        Statement stmt = conn.createStatement();
        try{
            int cnt = stmt.executeUpdate(sql);  //insert,upodate,delete
            result.put("affected_row",cnt);
            result.put("status","ok");
        } catch (Exception e){
            log.error(e.getMessage(),e);
            result.put("error",e.getMessage());
            result.put("status","nok");
        } finally{
            stmt.close();
            conn.close();
        }
        
        
        
		return ResponseEntity.ok(result);
	}

    
}
