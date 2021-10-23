package com.example.demo.cm.ctrl;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.example.demo.exception.BizException;
import com.example.demo.service.GoRestService;
import com.example.demo.utils.PjtUtil;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import liquibase.CatalogAndSchema;
import liquibase.Liquibase;
import liquibase.changelog.DatabaseChangeLog;
import liquibase.database.Database;
import liquibase.database.DatabaseFactory;
import liquibase.database.jvm.JdbcConnection;
import liquibase.diff.output.DiffOutputControl;
import liquibase.diff.output.changelog.DiffToChangeLog;
import liquibase.integration.spring.SpringLiquibase;
import liquibase.resource.ClassLoaderResourceAccessor;
import liquibase.structure.DatabaseObject;

import lombok.extern.slf4j.Slf4j;


import javax.sql.DataSource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import liquibase.integration.spring.SpringLiquibase;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.util.Assert;

@Slf4j
@RestController
public class LiquibaseApiRestController {
    public final static String CHANGE_LOG_FILE ="classpath:db/liquibase/db.changelog-master.xml";
    public final static String CHANGE_LOG_DIR ="D:\\git\\demoWeb\\demoWeb\\src\\main\\resources\\db\\liquibase";

    @Autowired
	PjtUtil pjtU;

    @Autowired
    private DataSource dataSource;

    @Autowired
    private ResourceLoader resourceLoader;

    
    @PostMapping(path = "/liquibase_rest/generateChangeLog", consumes = "application/json", produces = "application/json")
	public ResponseEntity<Object> generateChangeLog(Authentication authentication, HttpSession session) throws Exception {

        //이것도 동작한다. 
        //짱이다.
        //mybatis를 연결해서 
        //delete from databasechangelog를 달자
                
        // Locate change log file
        Database database = DatabaseFactory.getInstance().findCorrectDatabaseImplementation(new JdbcConnection(dataSource.getConnection()));
        DatabaseChangeLog  d = new DatabaseChangeLog();
        Liquibase liquibase2 = new Liquibase(d, new ClassLoaderResourceAccessor(getClass()
        .getClassLoader()), database);
        //liquibase.generateChangeLog(catalogAndSchema, changeLogWriter, outputStream, changeLogSerializer, snapshotTypes);

        //http://useof.org/java-open-source/liquibase.diff.output.changelog.DiffToChangeLog/2
        //https://stackoverflow.com/questions/44862889/how-to-use-liquibase-to-generate-a-changelog-from-diffs-between-a-database-and-p
        //https://www.programcreek.com/java-api-examples/?api=liquibase.diff.output.DiffOutputControl


        Class<? extends DatabaseObject>[] snapshotTypes = new Class[]{
            liquibase.structure.core.Table.class ,
            liquibase.structure.core.View.class ,
            liquibase.structure.core.Column.class ,
            liquibase.structure.core.Index.class ,
            liquibase.structure.core.ForeignKey.class ,
            liquibase.structure.core.PrimaryKey.class ,
            liquibase.structure.core.UniqueConstraint.class ,

        };
 
        //https://www.programcreek.com/java-api-examples/?api=liquibase.diff.output.DiffOutputControl
        
        DiffToChangeLog changeLog = new DiffToChangeLog(new DiffOutputControl(false, false, false, null));

        final java.nio.charset.Charset charset = StandardCharsets.UTF_8;
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PrintStream out = new PrintStream(baos,true, charset);
        liquibase2.generateChangeLog(database.getDefaultSchema(), changeLog, out, snapshotTypes);
        String data =new String(baos.toByteArray(),charset);
        out.close();
        baos.close();
        //System.out.println(data);

        Document doc  = getXmlDocString(data);
        makeChangelogFile(doc);
		HashMap<String, Object> result = new HashMap<String, Object>();
        result.put("statusCode", "999");

		return ResponseEntity.ok(result);
	}

	@PostMapping(path = "/liquibase_rest/update", consumes = "application/json", produces = "application/json")
	public ResponseEntity<Object> update(Authentication authentication, HttpSession session) throws Exception {

                
        // Locate change log file
        Resource resource = resourceLoader.getResource(CHANGE_LOG_FILE);
        Assert.state(resource.exists(), "Unable to find file: " + CHANGE_LOG_FILE);
        Database database = DatabaseFactory.getInstance().findCorrectDatabaseImplementation(new JdbcConnection(dataSource.getConnection()));
        Liquibase liquibase = new Liquibase(CHANGE_LOG_FILE, new ClassLoaderResourceAccessor(getClass()
        .getClassLoader()), database);
        liquibase.update("update");

        /// 된다.
        /// xml을 고치고 spring boot가  다시 재 시작 되어야 하지만 된다.
        //  


		HashMap<String, Object> result = new HashMap<String, Object>();
        result.put("statusCode", "999");

		return ResponseEntity.ok(result);
	}

    @PostMapping(path = "/liquibase_rest/changeLogSync", consumes = "application/json", produces = "application/json")
	public ResponseEntity<Object> changeLogSync(Authentication authentication, HttpSession session) throws Exception {

        //이것도 동작한다. 
        //짱이다.
        //mybatis를 연결해서 
        //delete from databasechangelog를 달자
                
        // Locate change log file
        Resource resource = resourceLoader.getResource(CHANGE_LOG_FILE);
        Assert.state(resource.exists(), "Unable to find file: " + CHANGE_LOG_FILE);
        Database database = DatabaseFactory.getInstance().findCorrectDatabaseImplementation(new JdbcConnection(dataSource.getConnection()));
        Liquibase liquibase = new Liquibase(CHANGE_LOG_FILE, new ClassLoaderResourceAccessor(getClass()
        .getClassLoader()), database);
        liquibase.changeLogSync("contexts");

		HashMap<String, Object> result = new HashMap<String, Object>();
        result.put("statusCode", "999");

		return ResponseEntity.ok(result);
	}

    @PostMapping(path = "/liquibase_rest/rollback", consumes = "application/json", produces = "application/json")
	public ResponseEntity<Object> rollback(@RequestBody Map<String,Object> params , Authentication authentication, HttpSession session) throws Exception {
        System.out.println("/liquibase_rest/rollback");
        System.out.println(params);

        //{date_executed=2021-10-23 11:57:48.562565}

        Date dateToRollBackTo = new Date();
        System.out.println(dateToRollBackTo);
        if(params.get("date_executed")!=null) {
            String date_executed=params.get("date_executed").toString();
            System.out.println(date_executed);
            SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); //밀리세컨까지 해주고 싶었는데 시분초가 이상하게 변환되어서 포기
            dateToRollBackTo = transFormat.parse(date_executed);
            System.out.println(dateToRollBackTo);
        } 
        System.out.println(dateToRollBackTo);
        
        // Locate change log file
        Resource resource = resourceLoader.getResource(CHANGE_LOG_FILE);
        Assert.state(resource.exists(), "Unable to find file: " + CHANGE_LOG_FILE);
        Database database = DatabaseFactory.getInstance().findCorrectDatabaseImplementation(new JdbcConnection(dataSource.getConnection()));
        Liquibase liquibase = new Liquibase(CHANGE_LOG_FILE, new ClassLoaderResourceAccessor(getClass()
        .getClassLoader()), database);
        
        liquibase.rollback(dateToRollBackTo, "");
        //liquibase.rollback(changesToRollback, contexts);

        ///
        /// xml을 고치고 spring boot가  다시 재 시작 되어야 하지만 된다.
        //  


		HashMap<String, Object> result = new HashMap<String, Object>();
        result.put("statusCode", "999");

		return ResponseEntity.ok(result);
	}

    private void makeChangelogFile(Document doc) throws Exception{
        Element  el = doc.getDocumentElement();
        
        System.out.println(el.getTextContent().length());

        LinkedHashSet<String> set = new LinkedHashSet<String>();
        
        ArrayList<Element> alTblFile = new ArrayList<Element>();
        ArrayList<Element> alEtc = new ArrayList<Element>();

        ArrayList<Node> removeAl = new ArrayList<Node>();
        NodeList nList = el.getElementsByTagName("createTable");
        for (int temp = 0; temp < nList.getLength(); temp++) {
            Node nNode = nList.item(temp);
            System.out.println("\nCurrent Element :" + nNode.getNodeName());
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                Element tbl = (Element) nNode;
                if(tbl!=null){
                    String tblName =tbl.getAttribute("tableName");

                    Element p =(Element) tbl.getParentNode();

                    alTblFile.add(tbl);
                    //String dsrc ="D:\\liquibase-4.5.0\\db\\liquibase\\tbl-"+tblName+".xml";
                    //makeTblFile( (Element)tbl.getParentNode(), dsrc,tblName);

                    set.add("tbl-"+tblName+".xml");
                    
                    ///지우기 위한것들을 저장
                    removeAl.add(nNode);
                    
                }  
            } 
        }
        nList = el.getElementsByTagName("createIndex");
        for (int temp = 0; temp < nList.getLength(); temp++) {
            Node nNode = nList.item(temp);
            System.out.println("\nCurrent Element :" + nNode.getNodeName());
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                Element tbl = (Element) nNode;
                if(tbl!=null){
                    String tblName =tbl.getAttribute("tableName");

                    alEtc.add(tbl);

                    //String dsrc ="D:\\liquibase-4.5.0\\db\\liquibase\\tbl-"+tblName+".xml";
                    //makeEtcFile( (Element)tbl.getParentNode(), dsrc);
                    set.add("tbl-"+tblName+".xml");

                    ///지우기 위한것들을 저장
                    removeAl.add(nNode);
                    
                }  
            } 
        }

        nList = el.getElementsByTagName("addUniqueConstraint");
        for (int i = 0; i < nList.getLength(); i++) {
            Node nNode = nList.item(i);
            System.out.println("\nCurrent Element :" + nNode.getNodeName());
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                Element tbl = (Element) nNode;
                if(tbl!=null){
                    String tblName =tbl.getAttribute("tableName");

                    alEtc.add(tbl);
                    //String dsrc ="D:\\liquibase-4.5.0\\db\\liquibase\\tbl-"+tblName+".xml";
                    //makeEtcFile( (Element)tbl.getParentNode(), dsrc);
                    set.add("tbl-"+tblName+".xml");

                    ///지우기 위한것들을 저장
                    removeAl.add(nNode);
                    
                }  
            } 
        }

        /* 참조 키 제약조건 이것도 키를 좀 의미있게 번호를 매겨보자  */
        nList = el.getElementsByTagName("addForeignKeyConstraint");
        for (int i = 0; i < nList.getLength(); i++) {
            Node nNode = nList.item(i);
            System.out.println("\nCurrent Element :" + nNode.getNodeName());
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                Element foreignkey = (Element) nNode;
                if(foreignkey!=null){
                    String baseTableName =foreignkey.getAttribute("baseTableName");
                    Element parent_el =(Element) foreignkey.getParentNode();

                    parent_el.setAttribute("id", baseTableName+"-"+(i+1));
                    parent_el.setAttribute("author", "auto (g)");
                }  
            } 
        }
        


        for(int i=0;i<removeAl.size();i++){
            el.removeChild(removeAl.get(i).getParentNode());
        }
  
        List<String> al = new ArrayList<>(set);

        for(int i=0;i<al.size(); i++){
            Element inc = doc.createElement("include");
            //inc.setAttribute("file","classpath:db/liquibase/"+ al.get(i));
            inc.setAttribute("file","db\\liquibase\\"+ al.get(i));
            inc.setAttribute("relativeToChangelogFile", "false");
            el.insertBefore(inc, el.getElementsByTagName("changeSet").item(0));
        }
        /*폴더에 파일 삭제 */
        File dir = new File(CHANGE_LOG_DIR);
        if(dir.isDirectory()==true){
            FileUtils.cleanDirectory(dir);
        }
        /* tbl 파일들 만들기  */
        for(int i=0;i<alTblFile.size();i++){
            makeTblFile(alTblFile.get(i));
        }

        for(int i=0;i<alEtc.size();i++){
            makeEtcFile(alEtc.get(i));
        }


        TransformerFactory transFactory = TransformerFactory.newInstance();
        Transformer transformer = transFactory.newTransformer();
        transformer.setOutputProperty(OutputKeys.VERSION, "1.1");
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");	
        transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
        DOMSource source = new DOMSource(el);

        StreamResult result = new StreamResult(new File(CHANGE_LOG_DIR+"\\db.changelog-master.xml"));

        transformer.transform(source, result);
        makeTrimmedXML(CHANGE_LOG_DIR+"\\db.changelog-master.xml");
        clearWhiteSpace(CHANGE_LOG_DIR+"\\db.changelog-master.xml");
    }

    public Document  getXmlDocString(String f) throws javax.xml.parsers.ParserConfigurationException, SAXException, IOException{
         // 1. 빌더 팩토리 생성.
         DocumentBuilderFactory builderFactory = javax.xml.parsers.DocumentBuilderFactory.newInstance();
         builderFactory.setIgnoringElementContentWhitespace(true);
         // 2. 빌더 팩토리로부터 빌더 생성
         javax.xml.parsers.DocumentBuilder builder = builderFactory.newDocumentBuilder();
         
         // 3. 빌더를 통해 XML 문서를 파싱해서 Document 객체로 가져온다.
         
         //http://daplus.net/java-java-net-malformedurlexception-%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C-%EC%97%86%EC%9D%8C/
         Document document = builder.parse(new InputSource(new StringReader(f)));
        
         // 문서 구조 안정화 ?
         document.getDocumentElement().normalize();
         System.out.println("Root Element :" + document.getDocumentElement().getNodeName());
         
         // XML 데이터 중 <person> 태그의 내용을 가져온다.

         return  document;
    }

    
    public void clearWhiteSpace(String d) throws ParserConfigurationException, SAXException, IOException, TransformerException{
        Document doc  = getXmlDocFile(d);
        TransformerFactory transFactory = TransformerFactory.newInstance();
        Transformer transformer = transFactory.newTransformer();
        transformer.setOutputProperty(OutputKeys.VERSION, "1.1");
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");	
        transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
        DOMSource source = new DOMSource(doc);
        StreamResult result = new StreamResult(new File(d));
        transformer.transform(source, result);

    }

    
    public void makeTrimmedXML(String rawXMLFilename) throws Exception
    {
        BufferedReader in = new BufferedReader(new FileReader(rawXMLFilename));
        String str="";
        String trimmedXML = "";
        while ((str = in.readLine()) != null)
        {
            String str1 = str;
            if (str1.length()>0){
                str1 = str1.trim();
                if(str1.length()>0){
                    if(str1.charAt(str1.length()-1) == '>')
                    {
                        trimmedXML = trimmedXML + str.trim();
                    }
                    else
                    {
                        trimmedXML = trimmedXML + str;
                    }
                }
                
            }
        }
        in.close();

        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(rawXMLFilename));
            writer.write(trimmedXML);
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        
    }

    
    public void makeTblFile(Element tbl) throws Exception{
        //String dsrc ="D:\\liquibase-4.5.0\\db\\liquibase\\tbl-"+tblName+".xml";
                    //makeTblFile( (Element)tbl.getParentNode(), dsrc,tblName);
        Element el = (Element)tbl.getParentNode();
        String tblName = tbl.getAttribute("tableName");
        String fileName = "tbl-"+tblName+".xml";

        DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
   
    
        javax.xml.parsers.DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
        // 루트 엘리먼트
        Document doc = docBuilder.newDocument();
        Element rootElement = doc.createElement("databaseChangeLog");
        rootElement.setAttribute("xmlns", "http://www.liquibase.org/xml/ns/dbchangelog");
        rootElement.setAttribute("xmlns:ext", "http://www.liquibase.org/xml/ns/dbchangelog-ext");
        rootElement.setAttribute("xmlns:pro", "http://www.liquibase.org/xml/ns/pro");
        rootElement.setAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
        rootElement.setAttribute("xsi:schemaLocation", "http://www.liquibase.org/xml/ns/dbchangelog-ext http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-ext.xsd http://www.liquibase.org/xml/ns/pro http://www.liquibase.org/xml/ns/pro/liquibase-pro-4.1.xsd http://www.liquibase.org/xml/ns/dbchangelog http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.1.xsd");
        doc.appendChild(rootElement);

        Node firstDocImportedNode = doc.importNode(el, true);

        Element firstEl = (Element)firstDocImportedNode;
        firstEl.setAttribute("author","auto (g)");
        firstEl.setAttribute("id", tblName+"-1");

        rootElement.appendChild(firstEl);

        /* db에서 가져오는거니까. 테이블은 항상존재한다. */
        /* 다시 반영되려고 할 때  preConditions가 항상 있어야 할 것 같다.
           cmd창에서 liquibase changelog-sync를 실행했는데 
           
        
        */


       	// XML 파일로 쓰기
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        //transformerFactory.setAttribute("indent-number", 4);
        Transformer transformer = transformerFactory.newTransformer();


        transformer.setOutputProperty(OutputKeys.VERSION, "1.1");
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");	
        transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
        DOMSource source = new DOMSource(doc);
        StreamResult result = new StreamResult(new FileOutputStream(new File(CHANGE_LOG_DIR+"\\"+fileName)));

        // 파일로 쓰지 않고 콘솔에 찍어보고 싶을 경우 다음을 사용 (디버깅용)
        // StreamResult result = new StreamResult(System.out);

        transformer.transform(source, result);
        transformer=null;

        makeTrimmedXML(CHANGE_LOG_DIR+"\\"+fileName);
        clearWhiteSpace(CHANGE_LOG_DIR+"\\"+fileName);

        System.out.println("File saved!");
    }

    public void makeEtcFile(Element tbl) throws Exception{
        //String dsrc ="D:\\liquibase-4.5.0\\db\\liquibase\\tbl-"+tblName+".xml";
        //makeEtcFile( (Element)tbl.getParentNode(), dsrc);
        Element el = (Element)tbl.getParentNode();
        String tblName = tbl.getAttribute("tableName");
        String fileName = "tbl-"+tblName+".xml";

        Document  root = getXmlDocFile(CHANGE_LOG_DIR+"\\"+fileName);

        Node firstDocImportedNode = root.importNode(el, true);

        Element firstEl = (Element)firstDocImportedNode;
        firstEl.setAttribute("author","auto (g)");
        //firstEl.setAttribute("id", tblName+"-001");


        NodeList nList = root.getElementsByTagName("changeSet");
        int cnt=0;
        String name ="";
        for(int i=0;i<nList.getLength();i++){
            Node nNode = nList.item(i);
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                Element tmp =(Element) nNode;
                String id = tmp.getAttribute("id");
                //System.out.println(id);
                String [] arr_cnt =id.split("-");
                int i_tmp = Integer.parseInt(arr_cnt[1]);
                name=arr_cnt[0];
                if(cnt<=i_tmp){
                    cnt=i_tmp;
                }
            }
        }
        name =name+"-"+(++cnt);
        //System.out.println(name);
        firstEl.setAttribute("id", name);

        Node tmp =root.getElementsByTagName("changeSet").item(0);//테이블이 있으니까 무조건 1개는 있다.
        //tmp.getParentNode().appendChild(firstDocImportedNode);



        tmp.getParentNode().insertBefore(firstEl, tmp);

       	// XML 파일로 쓰기
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        //transformerFactory.setAttribute("indent-number", 4);
        Transformer transformer = transformerFactory.newTransformer();

        transformer.setOutputProperty(OutputKeys.VERSION, "1.1");
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");	
        transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
        DOMSource source = new DOMSource((Document)root);
        StreamResult result = new StreamResult(new FileOutputStream(new File(CHANGE_LOG_DIR+"\\"+fileName)));

        // 파일로 쓰지 않고 콘솔에 찍어보고 싶을 경우 다음을 사용 (디버깅용)
        // StreamResult result = new StreamResult(System.out);

        transformer.transform(source, result);
        transformer=null;

        makeTrimmedXML(CHANGE_LOG_DIR+"\\"+fileName);
        clearWhiteSpace(CHANGE_LOG_DIR+"\\"+fileName);
        System.out.println("File saved!");
    }

    public Document  getXmlDocFile(String f) throws ParserConfigurationException, SAXException, IOException{
        File fd = new File(f);
        System.out.println(fd.isFile());
         // 1. 빌더 팩토리 생성.
         DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
         builderFactory.setIgnoringElementContentWhitespace(true);
         // 2. 빌더 팩토리로부터 빌더 생성
         DocumentBuilder builder = builderFactory.newDocumentBuilder();
         
         // 3. 빌더를 통해 XML 문서를 파싱해서 Document 객체로 가져온다.
         Document document = builder.parse(fd);
        
         // 문서 구조 안정화 ?
         document.getDocumentElement().normalize();
         System.out.println("Root Element :" + document.getDocumentElement().getNodeName());
         
         // XML 데이터 중 <person> 태그의 내용을 가져온다.

         return  document;
    }


}
