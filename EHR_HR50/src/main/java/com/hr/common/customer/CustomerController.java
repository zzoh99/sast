package com.hr.common.customer;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.hrm.empRcmd.aiEmpRcmd.AiEmpRcmdService;
import org.json.simple.JSONObject;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.HashMap;
import java.util.Map;

/**
 * AI인재추천 Controller
 *
 * @author 이름
 *
 */
@RestController
@RequestMapping(value="/customer", method= RequestMethod.POST )
public class CustomerController extends ComController {

	/**
	 * AI인재추천 서비스
	 */
	@Inject
	@Named("AiEmpRcmdService")
	private AiEmpRcmdService aiEmpRcmdService;

	/**
	 * AI인재추천 프롬프트 Response API
	 * @throws Exception
	 */
	@RequestMapping(value = "/hrm/empRcmd/prompt")
	public Map<String, Object> resPrompt(@RequestBody JSONObject paramJson) throws Exception {
		Log.DebugStart();

		Log.Debug("resPrompt =====");
		Log.Debug(paramJson.toString());

		String Message = "";
		String Code = "";
		try{
			aiEmpRcmdService.responsePrompt(paramJson);
			Code = "SUCCESS";
			Message = "성공";
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Code = "FAIL";
			Message="호출에 실패 하였습니다.";
		}

		Map<String, Object> result = new HashMap<>();
		result.put("DATA", Code);
		result.put("Message", Message);

		Log.DebugEnd();
		return result;
	}

}
