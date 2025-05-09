package com.hr.tim.workApp.extenWorkApp;
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
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/ExtenWorkApp.do", method=RequestMethod.POST )
public class ExtenWorkAppController extends ComController {
	/**
	 * 연장근무추가신청 서비스
	 */
	@Inject
	@Named("ExtenWorkAppService")
	private ExtenWorkAppService extenWorkAppService;

	/**
	 * 연장근무추가신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewExtenWorkApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewExtenWorkApp() throws Exception {
		return "tim/workApp/extenWorkApp/extenWorkApp";
	}


	
	/**
	 * 연장근무추가신청 신청자 정보 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExtenWorkAppUserInfo", method = RequestMethod.POST )
	public ModelAndView getExtenWorkAppUserInfo(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	
	
	/**
	 * 연장근무추가신청 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExtenWorkAppList", method = RequestMethod.POST )
	public ModelAndView getExtenWorkAppList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 연장근무추가신청 임시저장 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteExtenWorkApp", method = RequestMethod.POST )
	public ModelAndView saveExtenWorkApp(
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
			resultCnt = extenWorkAppService.deleteExtenWorkApp(convertMap);
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
