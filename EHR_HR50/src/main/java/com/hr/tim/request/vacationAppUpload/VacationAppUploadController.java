package com.hr.tim.request.vacationAppUpload;
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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.language.LanguageUtil;

/**
 * 일괄근태업로드 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/VacationAppUpload.do", method=RequestMethod.POST )
public class VacationAppUploadController {

	/**
	 * 일괄근태업로드 서비스
	 */
	@Inject
	@Named("VacationAppUploadService")
	private VacationAppUploadService vacationAppUploadService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * vacationAppUpload View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewVacationAppUpload", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewVacationAppUpload() throws Exception {
		return "tim/request/vacationAppUpload/vacationAppUpload";
	}
	
	/**
	 * vacationAppUpload 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getVacationAppUploadList", method = RequestMethod.POST )
	public ModelAndView getVacationAppUploadList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = vacationAppUploadService.getVacationAppUploadList(paramMap);
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
	 * vacationAppUpload 다건 조회 2
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getVacationAppUploadListCre", method = RequestMethod.POST )
	public ModelAndView getVacationAppUploadListCre(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = vacationAppUploadService.getVacationAppUploadListCre(paramMap);
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
	 * 근태일괄업로드 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveVacationAppUpload", method = RequestMethod.POST )
	public ModelAndView saveVacationAppUpload(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("GNT_CD",mp.get("gntCd"));
			dupMap.put("APPL_YMD",mp.get("applYmd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복검사
				dupCnt = commonCodeService.getDupCnt("TTIM311", "ENTER_CD,SABUN,GNT_CD,APPL_YMD", "s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message=LanguageUtil.getMessage("msg.alertDataDup", null, "중복되어 저장할 수 없습니다.");
			} else {
				resultCnt = vacationAppUploadService.saveVacationAppUpload(convertMap);
				if(resultCnt > 0){ message=LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
			}
		}catch(Exception e){
			resultCnt = -1; message=LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_TIM_CREW_CREATE", method = RequestMethod.POST )
	public ModelAndView prcP_TIM_CREW_CREATE(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		Map map  = vacationAppUploadService.prcP_TIM_CREW_CREATE(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("sqlcode : "+map.get("sqlcode"));
		Log.Debug("sqlerrm : "+map.get("sqlerrm"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * vacationAppUpload 적용일수 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getVacationAppUploadCloseCnt", method = RequestMethod.POST )
	public ModelAndView getVacationAppUploadCloseCnt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Map<String, Object> map = new HashMap<>();
		String Message = "";
		try {
			map = vacationAppUploadService.getVacationAppUploadCloseCnt(paramMap);
		} catch(Exception e) {
			Message = "조회에 실패 하였습니다. 관리자에게 문의 바랍니다.";
			Log.Error(Message + " => " + e.getLocalizedMessage());
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
}
