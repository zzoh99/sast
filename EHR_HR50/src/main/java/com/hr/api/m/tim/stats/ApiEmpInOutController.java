package com.hr.api.m.tim.stats;

import com.hr.common.logger.Log;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(value="/api/v5/tim/stats")
public class ApiEmpInOutController {
	/**
	 * 개인근무스케줄관리 서비스
	 */
	@Inject
	@Named("ApiEmpInOutService")
	private ApiEmpInOutService apiEmpInOutService;

	/**
	 * 조직원근태현황 일수 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return 
	 * @throws Exception
	 */
	@RequestMapping(value = "/getEmpInOutHeaderList")
	public Map<String, Object> getEmpInOutHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestBody Map<String, Object> paramMap ) throws Exception {
		Log.Debug(paramMap.toString());
        Map<String, Object> result = new HashMap<>();
        String Message = "";

        try {
            Log.Debug("getEmpInOutHeaderList =====");
            Log.Debug(":"+paramMap.toString());
            Log.Debug(":"+session.toString());

            paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

            List<?> list = apiEmpInOutService.getEmpInOutHeaderList(paramMap);
            if(list != null) {
                result.put("list", list);
            }else{
                result.put("list","");
            }
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
            Log.Debug(e.getMessage());
            result.put("Message", Message);
        }

        return result;
	}
	
	/**
	 * 조직원근태현황 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return 
	 * @throws Exception
	 */
	@RequestMapping(value = "/getEmpInOutList")
	public Map<String, Object> getEmpInOutList(
			HttpSession session,  HttpServletRequest request,
			@RequestBody Map<String, Object> paramMap ) throws Exception {
		Log.Debug(paramMap.toString());
        Map<String, Object> result = new HashMap<>();
        String Message = "";

        try {
            Log.Debug("getEmpInOutList =====");
            Log.Debug(":"+paramMap.toString());
            Log.Debug(":"+session.toString());

            paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
            //ssnLocaleCd

            List<?> list = apiEmpInOutService.getEmpInOutList(paramMap);
            if(list != null) {
                result.put("list", list);
            }else{
                result.put("list","");
            }
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
            Log.Debug(e.getMessage());
            result.put("Message", Message);
        }

        return result;
	}
}
