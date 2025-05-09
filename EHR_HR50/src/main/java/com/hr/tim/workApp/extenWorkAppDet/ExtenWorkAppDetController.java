package com.hr.tim.workApp.extenWorkAppDet;
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
import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
/**
 * 연장근무추가신청 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping({"/ExtenWorkApp.do","/ExtenWorkAppDet.do"})
public class ExtenWorkAppDetController extends ComController {
	/**
	 * 연장근무추가신청 서비스
	 */
	@Inject
	@Named("ExtenWorkAppDetService")
	private ExtenWorkAppDetService extenWorkAppDetService;

	/**
	 * 연장근무추가신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewExtenWorkAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewExtenWorkAppDet() throws Exception {
		return "tim/workApp/extenWorkAppDet/extenWorkAppDet";
	}
	
	/**
	 * 연장근무추가신청 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExtenWorkAppDet", method = RequestMethod.POST )
	public ModelAndView getExtenWorkAppDet(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	
	
	/**
	 * 연장근무추가신청 연장근무시간 조회 
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExtenWorkAppDetWorkInfo", method = RequestMethod.POST )
	public ModelAndView getExtenWorkAppDetWorkInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 연장근무추가신청 휴일 체크  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExtenWorkAppDetHoliChk", method = RequestMethod.POST )
	public ModelAndView getExtenWorkAppDetHoliChk(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 연장근무추가신청 근무시간 계산 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExtenWorkAppDetTime", method = RequestMethod.POST )
	public ModelAndView getExtenWorkAppDetTime(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> titleList = extenWorkAppDetService.getExtenWorkAppDetTitle(paramMap);

		paramMap.put("titles", titleList);
		
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 연장근무추가신청 연장근무 한도 체크 
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExtenWorkAppDetCheckTime", method = RequestMethod.POST )
	public ModelAndView getExtenWorkAppDetCheckTime(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 연장근무추가신청 기 신청건 체크 
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExtenWorkAppDetDupCnt", method = RequestMethod.POST )
	public ModelAndView getExtenWorkAppDetDupCnt(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	

	/**
	 * 연장근무추가신청 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveExtenWorkAppDet", method = RequestMethod.POST )
	public ModelAndView saveExtenWorkAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = extenWorkAppDetService.saveExtenWorkAppDet(paramMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
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
	
	
}
