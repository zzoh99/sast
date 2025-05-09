package com.hr.hrm.other.emergencyContact;
import java.io.Serializable;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * emergencyContact Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/EmergencyContact.do", method=RequestMethod.POST )
public class EmergencyContactController {
	/**
	 * emergencyContact 서비스
	 */
	@Inject
	@Named("EmergencyContactService")
	private EmergencyContactService emergencyContactService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * emergencyContact View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmergencyContact", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmergencyContact() throws Exception {
		return "hrm/other/emergencyContact/emergencyContact";
	}

	/**
	 * emergencyContact View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmergencyContact2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmergencyContact2() throws Exception {
		return "hrm/other/emergencyContact/emergencyContact2";
	}
	
	/**
	 * emergencyContact(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmergencyContactPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmergencyContactPop() throws Exception {
		return "hrm/other/emergencyContact/emergencyContactPop";
	}

	/**
	 * emergencyContact 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmergencyContactList", method = RequestMethod.POST )
	public ModelAndView getEmergencyContactList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();
		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			// 연락처 Title 다건 조회
			titleList = emergencyContactService.getEmergencyContacTitletList(paramMap);

			for(int i = 0 ; i < titleList.size() ; i++) {
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);
				
				mapElement.put("code"   , map.get("code").toString());
				mapElement.put("codeNm"	, map.get("codeNm").toString());
				
				titles.add(mapElement);
				paramMap.put("titles", titles);
			}

			list = emergencyContactService.getEmergencyContactList(paramMap);
		} catch(Exception e) {
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
	 * emergencyContact 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEmergencyContact", method = RequestMethod.POST )
	public ModelAndView saveEmergencyContact(
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
			resultCnt =emergencyContactService.saveEmergencyContact(convertMap);
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
	 * emergencyContact 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmergencyContactMap", method = RequestMethod.POST )
	public ModelAndView getEmergencyContactMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = emergencyContactService.getEmergencyContactMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
	
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
	
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * emergencyContact Title 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmergencyContacTitletList", method = RequestMethod.POST )
	public ModelAndView getEmergencyContacTitletList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = emergencyContactService.getEmergencyContacTitletList(paramMap);
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
}
