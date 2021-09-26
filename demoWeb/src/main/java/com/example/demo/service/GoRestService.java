package com.example.demo.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

import com.example.demo.YmlConfig;
import com.example.demo.exception.BizException;
import com.example.demo.utils.PjtUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class GoRestService {
    @Autowired
    YmlConfig ymlC;

    @Autowired
    PjtUtil pjtU;

    public String callApiLog(String api_uuid) throws ResourceAccessException, BizException {
        log.info("api_uuid=>" + api_uuid);
        String jsonOutString = null;
        HashMap<String, Object> result = new HashMap<String, Object>();
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        RestTemplate restTemplate = new RestTemplate(factory);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<?> entity = new HttpEntity<>(headers);
        log.info("ymlC.getApiurllog() =>" + ymlC.getApiurllog());
        String url = ymlC.getApiurllog() + api_uuid;
        UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);

        try {
            ResponseEntity<String> resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.POST,
                    entity, String.class);
            result.put("statusCode", resultMap.getStatusCodeValue()); // http status code를 확인
            result.put("header", resultMap.getHeaders()); // 헤더 정보 확인
            result.put("body", resultMap.getBody()); // 실제 데이터 정보 확인

            jsonOutString = resultMap.getBody();
            return jsonOutString;
        } catch (ResourceAccessException e) {
            e.printStackTrace();
            throw new ResourceAccessException("제한시간이 100초가 초과되었습니다.");
            // 이렇게 에러를 던지는게 아니라 결과셋을 보내야한다.
        }
    }

    public String callAPI(String br, String jsonInString) throws ResourceAccessException, BizException {
        return callApiBizActor(br, jsonInString);
    }

    public String callApiRest(String br, String jsonInString) throws ResourceAccessException {
        log.info("br=>" + br);
        log.info("jsonInString=>" + jsonInString);
        String jsonOutString = null;
        HashMap<String, Object> result = new HashMap<String, Object>();
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        // factory.setConnectTimeout(100000); // 타임아웃 설정 5초
        // factory.setReadTimeout(100000);// 타임아웃 설정 5초
        RestTemplate restTemplate = new RestTemplate(factory);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<?> entity = new HttpEntity<>(jsonInString, headers);
        log.info("ymlC.getApiurl() =>" + ymlC.getApiurl());
        String url = ymlC.getApiurl() + br;
        UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);

        try {
            ResponseEntity<String> resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.POST,
                    entity, String.class);
            result.put("statusCode", resultMap.getStatusCodeValue()); // http status code를 확인
            result.put("header", resultMap.getHeaders()); // 헤더 정보 확인
            result.put("body", resultMap.getBody()); // 실제 데이터 정보 확인

            jsonOutString = resultMap.getBody();
            return jsonOutString;
        } catch (ResourceAccessException e) {
            e.printStackTrace();
            throw new ResourceAccessException("제한시간이 100초가 초과되었습니다.");
            // 이렇게 에러를 던지는게 아니라 결과셋을 보내야한다.
        }
    }

    public String callApiBizActor(String br, String jsonInString) throws ResourceAccessException, BizException {

        /*
         * 하드전문 ex)) 요청 예시 { "actID" : "BRBookMasterSearch", "inDTName":"SearchInfo",
         * "outDTName":"BookInfo", "refDS" : { "SearchInfo": [
         * {"CLASSCD":"AA","BOOKNM":"J2EE10", "KEYWORD" : "J2EE"} ] } }
         * 
         * // 응답 코드
         * 
         * 성공적인 결과 반환일 경우 http_status 200 json-data_status "SUCCESS"
         * json-data_description "Service was called successfully." json-data_result O
         * BR에서 Error Step 출력 http_status 200 json-data_status "BIZEXCEPTION"
         * json-data_description ex) "Book copy information exists." json-data_result X
         * BizActor 서비스 수행 중에 오류가 발생한 경우 http_status 200 json-data_status "FAILED"
         * json-data_description ex) "Service (BR_BookMasterSearch) Not Exist"
         * "Error : Final Return Data Failed!" "This service (DABookMasterSearch) need
         * Input Parameter Value(s)" json-data_result X 잘못된 request 일 경우 http_status 400
         * json-data_status "400" json-data_description "Bad Request." json-data_result
         * X POST 가 아닌 http method 일 경우 http_status 403 json-data_status "403"
         * json-data_description "Only POST method is authorized." json-data_result X
         * /bizarest, /bizarest/* 외의 호출일 경우 http_status 404 json-data_status "404"
         * json-data_description "Api url is invalid." json-data_result X 서블릿의 이외 에러가
         * 발생할 경우 http_status 500 json-data_status "500" json-data_description
         * "Internal server error." json-data_result X
         * 
         * 
         * 응답 ex {"description":"Failed to call service. Check input parameter: actID",
         * "message":"Service (BR_CM_LOGIN_LOAD_USER_BY_USER_NAME) Not Exist",
         * "status":"FAILED" } ---------------------- 여기서 요청 형식--------
         * 
         * { brRq : 'IN_DATA,UPDT_DATA' ,brRs : '' ,IN_DATA : data.createdRows
         * ,UPDT_DATA : data.updatedRows }
         * 
         * br명은 넘어온 파라미터로 actID 로 만들어줘야한다.
         * 
         * brRq==>inDTName 변환 brRs==>outDTName 변환
         */
        log.info("br=>" + br);
        log.info("jsonInString=>" + jsonInString);

        HashMap<String, Object> input_msg = new HashMap<String, Object>();
        input_msg.put("actID", br);
        try {
            HashMap<String, Object> input_tmp = pjtU.JsonStringToObject(jsonInString, HashMap.class);

            String brRq = input_tmp.get("brRq").toString();
            String brRs = input_tmp.get("brRs").toString();

            input_msg.put("inDTName", brRq);
            input_msg.put("outDTName", brRs);

            if (input_tmp.get("API_UUID") != null) {
                String _id = input_tmp.get("API_UUID").toString();
                input_msg.put("_id", _id);
            }

            HashMap<String, Object> refDS = new HashMap<String, Object>();
            String[] arr_brRq = brRq.split(",");
            for (int i = 0; i < arr_brRq.length; i++) {
                String tmp = arr_brRq[i];
                /*
                 * 보내는 파라미터는 무조건 string이어야한다. 받는 곳에서도 무조건 string으로 받을 거다 왜 그러냐면 만약 number로 보낸다면
                 * bizactor가 string 타입이라면 500 서버에러가 발생한다.
                 */
                ArrayList<HashMap<String, Object>> arr_input_param = (ArrayList<HashMap<String, Object>>) input_tmp
                        .get(tmp);

                ArrayList<HashMap<String, Object>> arr_input_param_tmp = new ArrayList<HashMap<String, Object>>();
                if (arr_input_param != null) {
                    for (int j = 0; j < arr_input_param.size(); j++) {

                        HashMap<String, Object> input_param_tmp = new HashMap<String, Object>();
                        HashMap<String, Object> input_param = arr_input_param.get(j);
                        for (Map.Entry<String, Object> entry : input_param.entrySet()) {
                            String tmpKey = entry.getKey();
                            String tmpValue = Objects.toString(entry.getValue(), "");

                            if (!pjtU.isEmpty(tmpValue)) {
                                // System.out.println("tmpKey=>"+tmpKey);
                                // System.out.println("tmpValue=>"+tmpValue);
                                // System.out.println("is not Empty");

                                input_param_tmp.put(tmpKey, tmpValue);
                            } else {
                                // System.out.println("tmpKey=>"+tmpKey);
                                // System.out.println("tmpValue=>"+tmpValue);
                                // System.out.println("is Empty");
                            }

                        }
                        arr_input_param_tmp.add(input_param_tmp);
                    }
                }

                refDS.put(tmp, arr_input_param_tmp);
            }
            input_msg.put("refDS", refDS);

        } catch (JsonProcessingException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        try {
            jsonInString = pjtU.ObjectToJsonString(input_msg);
        } catch (JsonProcessingException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }

        String jsonOutString = null;
        HashMap<String, Object> result = new HashMap<String, Object>();
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        // factory.setConnectTimeout(100000); // 타임아웃 설정 5초
        // factory.setReadTimeout(100000);// 타임아웃 설정 5초
        RestTemplate restTemplate = new RestTemplate(factory);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        log.info("jsonInString last =>" + jsonInString);
        HttpEntity<?> entity = new HttpEntity<>(jsonInString, headers);
        log.info("ymlC.getApiurlbizactor() =>" + ymlC.getApiurlbizactor());
        String url = ymlC.getApiurlbizactor();
        UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);

        ResponseEntity<String> resultMap = null;
        try {
            resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.POST, entity, String.class);
        } catch (ResourceAccessException e) {
            e.printStackTrace();
            throw new ResourceAccessException("제한시간이 100초가 초과되었습니다.");
            // 이렇게 에러를 던지는게 아니라 결과셋을 보내야한다.
        }

        int statusCode = resultMap.getStatusCodeValue();
        String body = resultMap.getBody();
        log.info("statusCode=>" + statusCode);
        log.info("header=>" + resultMap.getHeaders());
        log.info("body=>" + body);

        HashMap<String, Object> out_msg = null;
        try {
            out_msg = pjtU.JsonStringToObject(body, HashMap.class);
        } catch (JsonMappingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        if (statusCode == 200 && out_msg.get("status").toString().equals("SUCCESS")) {
            // 이경우만 성공 result가 존재함.

            // jsonOutString=out_msg.get("result").toString();
            // json 형태가 아니여서 문제가 됨
            try {
                jsonOutString = pjtU.ObjectToJsonString(out_msg.get("result"));
            } catch (JsonProcessingException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

            /*
             * 
             * /*
             * 
             * body=> {"result": { "OUT_DATA":[ { "USER_NO":"0","USER_NM":null,"AUTH":
             * "ROLE_ADMIN,ROLE_ADULT,ROLE_ADMIN,ROLE_ADULT","USER_ID":"jijs","EMAIL":
             * "admin@ji.co.kr","USER_PWD":
             * "$2a$10$bZugwrD3UkZ5dqdmJW4NCOLGG4gse.uyXYmPxneTsO5P4rRodSY22" }
             * 
             * ] }, "description":"Service was called successfully.", "status":"SUCCESS" }
             * com.fasterxml.jackson.core.JsonParseException: Unexpected character ('O'
             * (code 79)): was expecting double-quote to start field name
             * 
             */
        } else {
            // 나머진 다 에러
            // throw new BizException(out_msg.get("message").toString());
            throw new BizException(out_msg.get("message").toString());
        }
        return jsonOutString;

    }

    public String callApiBizActorMap(String br, Map<String, Object> inDs) throws ResourceAccessException, BizException {
        log.info("br=>" + br);

        HashMap<String, Object> input_msg = new HashMap<String, Object>();
        input_msg.put("actID", br);
        String brRq = inDs.get("brRq").toString();
        String brRs = inDs.get("brRs").toString();

        input_msg.put("inDTName", brRq);
        input_msg.put("outDTName", brRs);

        if (inDs.get("API_UUID") != null) {
            String _id = inDs.get("API_UUID").toString();
            input_msg.put("_id", _id);
        }

        HashMap<String, Object> refDS = new HashMap<String, Object>();
        String[] arr_brRq = brRq.split(",");
        for (int i = 0; i < arr_brRq.length; i++) {
            String tmp = arr_brRq[i];
            /*
             * 보내는 파라미터는 무조건 string이어야한다. 받는 곳에서도 무조건 string으로 받을 거다 왜 그러냐면 만약 number로 보낸다면
             * bizactor가 string 타입이라면 500 서버에러가 발생한다.
             */
            ArrayList<HashMap<String, Object>> arr_input_param = (ArrayList<HashMap<String, Object>>) inDs.get(tmp);

            ArrayList<HashMap<String, Object>> arr_input_param_tmp = new ArrayList<HashMap<String, Object>>();
            if (arr_input_param != null) {
                for (int j = 0; j < arr_input_param.size(); j++) {

                    HashMap<String, Object> input_param_tmp = new HashMap<String, Object>();
                    HashMap<String, Object> input_param = arr_input_param.get(j);
                    for (Map.Entry<String, Object> entry : input_param.entrySet()) {
                        String tmpKey = entry.getKey();
                        String tmpValue = Objects.toString(entry.getValue(), "");

                        if (!pjtU.isEmpty(tmpValue)) {
                            // System.out.println("tmpKey=>"+tmpKey);
                            // System.out.println("tmpValue=>"+tmpValue);
                            // System.out.println("is not Empty");

                            input_param_tmp.put(tmpKey, tmpValue);
                        } else {
                            // System.out.println("tmpKey=>"+tmpKey);
                            // System.out.println("tmpValue=>"+tmpValue);
                            // System.out.println("is Empty");
                        }

                    }
                    arr_input_param_tmp.add(input_param_tmp);
                }
            }

            refDS.put(tmp, arr_input_param_tmp);
        }
        input_msg.put("refDS", refDS);

        String jsonInString = "";
        try {
            jsonInString = pjtU.ObjectToJsonString(input_msg);
        } catch (JsonProcessingException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }

        String jsonOutString = null;
        HashMap<String, Object> result = new HashMap<String, Object>();
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        // factory.setConnectTimeout(100000); // 타임아웃 설정 5초
        // factory.setReadTimeout(100000);// 타임아웃 설정 5초
        RestTemplate restTemplate = new RestTemplate(factory);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        // log.info("jsonInString last =>" + jsonInString);
        HttpEntity<?> entity = new HttpEntity<>(jsonInString, headers);
        log.info("ymlC.getApiurlbizactor() =>" + ymlC.getApiurlbizactor());
        String url = ymlC.getApiurlbizactor();
        UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(url);

        ResponseEntity<String> resultMap = null;
        try {
            resultMap = restTemplate.exchange(uriBuilder.build().toString(), HttpMethod.POST, entity, String.class);
        } catch (ResourceAccessException e) {
            e.printStackTrace();
            throw new ResourceAccessException("제한시간이 100초가 초과되었습니다.");
            // 이렇게 에러를 던지는게 아니라 결과셋을 보내야한다.
        }

        int statusCode = resultMap.getStatusCodeValue();
        String body = resultMap.getBody();
        // log.info("statusCode=>" + statusCode);
        // log.info("header=>" + resultMap.getHeaders());
        // log.info("body=>" + body);

        HashMap<String, Object> out_msg = null;
        try {
            out_msg = pjtU.JsonStringToObject(body, HashMap.class);
        } catch (JsonMappingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        if (statusCode == 200 && out_msg.get("status").toString().equals("SUCCESS")) {
            try {
                jsonOutString = pjtU.ObjectToJsonString(out_msg.get("result"));
            } catch (JsonProcessingException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        } else {
            // 나머진 다 에러
            // throw new BizException(out_msg.get("message").toString());
            throw new BizException(out_msg.get("message").toString());
        }
        return jsonOutString;

    }
}
