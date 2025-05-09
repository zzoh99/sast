package com.hr.sys.security.outUserReg;

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

import com.hr.common.util.ParamUtils;
import com.hr.common.code.CommonCodeService;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;

/**
 * 외부사용자등록
 * 
 * @author ParkMoohun
 *
 */
@Controller
@RequestMapping(value="/OutUserReg.do", method=RequestMethod.POST )
public class OutUserRegController {

	@Inject
	@Named("OutUserRegService")
	private OutUserRegService outUserRegService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 외부사용자등록  View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOutUserReg", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOutUserReg() throws Exception {
		return "sys/security/outUserReg/outUserReg";
	}
	
	/**
	 * 외부사용자등록-중복체크  View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOutUserRegPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOutUserRegPop() throws Exception {
		return "sys/security/outUserReg/outUserRegPop";
	}

	/**
	 * 외부사용자등록-중복체크 Layer  View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOutUserRegLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOutUserRegLayer() throws Exception {
		return "sys/security/outUserReg/outUserRegLayer";
	}
	
	/**
	 * 외부사용자등록-외부사용자조회팝업  View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOutUserRegPopCommon", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOutUserRegPopCommon() throws Exception {
		return "sys/security/outUserReg/outUserRegPopCommon";
	}

	/**
	 * 외부사용자등록  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOutUserRegList", method = RequestMethod.POST )
	public ModelAndView getOutUserRegList(HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap)throws HrException {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		
		try{
			list = outUserRegService.getOutUserRegList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 외부사용자등록-중복체크  단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOutUserRegPopMap", method = RequestMethod.POST )
	public ModelAndView getOutUserRegPopMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Map<?, ?> map = outUserRegService.getOutUserRegPopMap(paramMap);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map",map);
		
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 외부사용자등록  저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOutUserReg", method = RequestMethod.POST )
	public ModelAndView saveOutUserReg(HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws HrException {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		int	resultCnt = -1;
		String message = "";
		try{
			if( commonCodeService.getDupCnt(convertMap, "TSYS305", "ID", "s") > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = outUserRegService.saveOutUserReg(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}
		
		Map<String, Object> resultMap= new HashMap<String, Object>();
		resultMap.put("Code", 		resultCnt);
		resultMap.put("Message", 	message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		
		Log.DebugEnd();
		return mv;
	}
	
}