package com.hr.sys.log.acessLogSht;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * acessLogSht Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/AcessLogSht.do", method=RequestMethod.POST )
public class AcessLogShtController {
	/**
	 * acessLogSht 서비스
	 */
	@Inject
	@Named("AcessLogShtService")
	private AcessLogShtService acessLogShtService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * acessLogSht View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAcessLogSht", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAcessLogSht() throws Exception {
		return "sys/log/acessLogSht/acessLogSht";
	}

	/**
	 * acessLogSht(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAcessLogShtLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAcessLogShtLayer() throws Exception {
		return "sys/log/acessLogSht/acessLogShtLayer";
	}

	/**
	 * acessLogSht 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAcessLogShtList", method = RequestMethod.POST )
	public ModelAndView getAcessLogShtList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = acessLogShtService.getAcessLogShtList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * acessLogSht 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAcessLogSht", method = RequestMethod.POST )
	public ModelAndView saveAcessLogSht(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =acessLogShtService.saveAcessLogSht(convertMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * acessLogSht 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAcessLogShtMap", method = RequestMethod.POST )
	public ModelAndView getAcessLogShtMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
		String prgNm = "";
		String queryString = "";
		List<String> keys = new ArrayList<String>();
		List<String> values = new ArrayList<String>();
	
		try{
			map = acessLogShtService.getAcessLogShtMap(paramMap);
			
			if(map != null) {
				prgNm = map.get("prgNm").toString();
				queryString = map.get("queryString").toString();
				String parameter = map.get("parameter").toString();
				map = convertJSONstringToMap(parameter);
				
				Set set = map.keySet();
				Iterator iterator = set.iterator();
				
				while(iterator.hasNext()){
				  String key = (String)iterator.next();
				  keys.add(key);
				  values.add(map.get(key).toString());
				}
			}
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
	
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Values", values);
		mv.addObject("Keys", keys);
		mv.addObject("PrgNm", prgNm);
		mv.addObject("QueryString", queryString);
		mv.addObject("Message", Message);
	
		Log.DebugEnd();
		return mv;
	}
	
	public static Map<String,Object> convertJSONstringToMap(String json) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> mapObj = mapper.readValue(json, new TypeReference<Map<String, Object>>() {});
		if(mapObj.containsKey("insertRows")) {
			mapObj.remove("insertRows");
		}
		if(mapObj.containsKey("mergeRows")) {
			mapObj.remove("mergeRows");
		}
		if(mapObj.containsKey("deleteRows")) {
			mapObj.remove("deleteRows");
		}
		if(mapObj.containsKey("updateRows")) {
			mapObj.remove("updateRows");
		}
        return mapObj;
    }

}
