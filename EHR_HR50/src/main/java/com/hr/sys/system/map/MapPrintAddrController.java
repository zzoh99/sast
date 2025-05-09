package com.hr.sys.system.map;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 주소지지도검색 Controller
 *
 */
@Controller
@RequestMapping(value="/MapPrintAddr.do", method=RequestMethod.POST )
public class MapPrintAddrController {


	@Inject
	@Named("MapPrintAddrService")
	private MapPrintAddrService mapPrintAddrService;

	/**
	 * viewMapPrintAddr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMapPrintAddr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMapPrintAddr() throws Exception {
		return "sys/system/map/mapPrintAddr";
	}
	
	/**
	 * viewMapPrintAddrLayer View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMapPrintAddrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMapPrintAddrLayer() throws Exception {
		return "sys/system/map/mapPrintAddrLayer";
	}
	
	/**
	 * getMapPrintAddr2 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMapPrintAddr2", method = RequestMethod.POST )
	public ModelAndView getMapPrintAddr2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mapPrintAddrService.getMapPrintAddr2(paramMap);
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
	  * 변경사항을 저장한다.
	  *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMapPrintAddr", method = RequestMethod.POST )
	public ModelAndView saveMapPrintAddr(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));

		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0;
		try{

			cnt = mapPrintAddrService.saveMapPrintAddr(convertMap);

			if (cnt > 0) {
				message="저장되었습니다.";
			}  else {
				message="저장된 내용이 없습니다.";
			}
		}catch(Exception e){
			cnt=-1;
			message="저장 실패하였습니다.";
		}

		resultMap.put("Code", 		cnt);
		resultMap.put("Message", 	message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=saveMapAddrByRecord", method = RequestMethod.POST )
	public ModelAndView saveMapAddrByRecord(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));

		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0;
		try{

			cnt = mapPrintAddrService.saveMapAddrByRecord( paramMap );

			if (cnt > 0) {
				message="저장되었습니다.";
			}  else if( cnt == -1){
				message="동일한 명칭의 주소록이 존재합니다.";
			} else {
				message="저장된 내용이 없습니다.";
			}
		}catch(Exception e){
			cnt=-1;
			message="저장 실패하였습니다.";
		}

		resultMap.put("Code", 		cnt);
		resultMap.put("Message", 	message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}


	@RequestMapping(params="cmd=deleteMapPrintCombo", method = RequestMethod.POST )
	public ModelAndView deleteMapPrintCombo(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));

		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0;
		try{

			cnt = mapPrintAddrService.deleteMapPrintCombo( paramMap );

			if (cnt > 0) {
				message="저장되었습니다.";
			}  else {
				message="저장된 내용이 없습니다.";
			}
		}catch(Exception e){
			cnt=-1;
			message="저장 실패하였습니다.";
		}

		resultMap.put("Code", 		cnt);
		resultMap.put("Message", 	message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}



}