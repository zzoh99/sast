package com.hr.common.util.api;

import com.hr.common.logger.Log;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ApiUtil {
	private static final String apiKey = "81d765ad552348b9973d7e761c649b68";
	private static final String secret = "1234";
	private static final String URL = "https://api.pearbranch.com/public/util/sms";
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Map sendSms(Map<String, Object> param) throws Exception{
		Map resultMap = new HashMap();
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		
		param.put("apiKey", apiKey);
		param.put("secret", secret);
		
		RestTemplate restTemplate = new RestTemplate();
		HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(param,headers);
		
		String resultCd = "";
		String resultMsg = "";
		try {
			Log.Debug("메일 정보: "+param.toString());
			restTemplate.exchange(URL, HttpMethod.POST,requestEntity,Void.class);
			resultCd = "S"; 
			resultMsg = "정상적으로 발송 되었습니다.";
		} catch (HttpClientErrorException e) {
			JSONObject resJson = (JSONObject)new JSONParser().parse(e.getResponseBodyAsString());
			List<Map<String,String>> validExceptions = (List<Map<String,String>>)resJson.get("validExceptions");
			List<String> codeArr = new ArrayList<>();   
			List<String> messageArr = new ArrayList<>();   
			for(Map<String,String> map : validExceptions){
				codeArr.add(map.get("code"));
				messageArr.add(map.get("message"));
			}
			resultCd = "F";
			resultMsg = messageArr.toString();
		}finally {
			resultMap.put("code",resultCd);
			resultMap.put("message",resultMsg);
		}
		
		return resultMap;
	}
}
