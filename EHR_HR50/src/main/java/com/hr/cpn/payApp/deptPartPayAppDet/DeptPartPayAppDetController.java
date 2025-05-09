package com.hr.cpn.payApp.deptPartPayAppDet;
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
import com.hr.common.language.Language;

/**
 * 기타지급신청 세부내역 Controller
 *
 * @author YSH
 *
 */
@Controller
@RequestMapping(value="/DeptPartPayAppDet.do", method=RequestMethod.POST )
public class DeptPartPayAppDetController {

	/**
	 * 기타지급신청 세부내역 서비스
	 */
	@Inject
	@Named("DeptPartPayAppDetService")
	private DeptPartPayAppDetService deptPartPayAppDetService;

	/**
	 * 다국어처리 서비스
	 */
	@Inject
	@Named("Language")
	private	Language language;

	/**
	 * 근태신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewDeptPartPayAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewVacationAppDet() throws Exception {
		return "cpn/payApp/deptPartPayAppDet/deptPartPayAppDet";
	}


	/**
	 * 근태신청 세부내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getDeptPartPayAppDetList", method = RequestMethod.POST )
	public ModelAndView getDeptPartPayAppDetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = deptPartPayAppDetService.getDeptPartPayAppDetList(paramMap);

		}catch(Exception e){
			Message= language.getMessage("msg.alertSearchFail");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근태신청 세부내역 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveDeptPartPayAppDet", method = RequestMethod.POST )
	public ModelAndView saveDeptPartPayAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		if ( convertMap == null) {
			convertMap = new HashMap<String, Object>();
		}

		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("searchApplSeq",paramMap.get("searchApplSeq"));
		convertMap.put("searchApplSabun",paramMap.get("searchApplSabun"));
		convertMap.put("payYm",paramMap.get("payYm"));
		convertMap.put("benefitBizCd",paramMap.get("benefitBizCd"));
		convertMap.put("totMon",paramMap.get("totMon"));
		convertMap.put("bigo",paramMap.get("bigo"));

		String message = "";
		int resultCnt = -1;
		try{

			resultCnt = deptPartPayAppDetService.saveDeptPartPayAppDet(convertMap);
			if(resultCnt > 0){ message= language.getMessage("msg.alertSaveOk",  null,"자료가 저장되었습니다.."); } else{ message= language.getMessage("msg.alertNoSaveData",  null, "저장할 자료가 없습니다."); }

		}catch(Exception e){
			resultCnt = -1; message= language.getMessage("msg.alertSaveFail",  null, "저장 중 오류가 발생하였습니다.");
			e.getStackTrace();
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code",resultCnt);
		resultMap.put("Message",message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
}
