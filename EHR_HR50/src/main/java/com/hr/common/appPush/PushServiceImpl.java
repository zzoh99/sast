package com.hr.common.appPush;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.hr.AsyncService;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class PushServiceImpl {
	
	@Autowired
	private AsyncService asyncService;


	
	@Value("${mApi.mobile.apiKey}")
	private String apiKey;

	@Value("${mApi.mobile.secret}")
	private String secret;

	@Value("${mApi.pushTongUrl}")
	private String url;

	/**
	 * 푸시 API 호출 
	 * @param empEnterCd 
	 * @param category - "BENE" 와 같은 푸시 카테고리
	 * @param targetEmp : ["ISU_ST@15003" ,"ISU_ST@17016"]
	 * @param title : "푸시 타이틀"
	 * @throws Exception
	 */
	public void sendPushMessage(String category, List<String> targetEmp, String title) throws Exception{
		if(targetEmp.size() > 0){
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("apiKey", apiKey);
			paramMap.put("secret", secret);
			paramMap.put("from", category);
			paramMap.put("type", "INFO");
			paramMap.put("title", title);
			paramMap.put("issuer", "system");
			paramMap.put("content", "");
			paramMap.put("key", "");
			paramMap.put("target", targetEmp);
			
			Log.Info(url);
			Log.Info("pushAsync-out Start");
			asyncService.push(url, paramMap);
			Log.Info("pushAsync-out End");
		}
	}
}
