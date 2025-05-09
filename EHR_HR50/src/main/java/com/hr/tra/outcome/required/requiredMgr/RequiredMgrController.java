package com.hr.tra.outcome.required.requiredMgr;
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
import com.hr.common.com.ComController;
import com.hr.common.exception.HrException;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 필수교육과정 대상자관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/RequiredMgr.do", method=RequestMethod.POST )
public class RequiredMgrController extends ComController {
	/**
	 * 필수교육과정 대상자관리 서비스
	 */
	@Inject
	@Named("RequiredMgrService")
	private RequiredMgrService requiredMgrService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 필수교육과정 대상자관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRequiredMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRequiredMgr() throws Exception {
		return "tra/outcome/required/requiredMgr/requiredMgr";
	}

	/**
	 * 필수교육과정 대상자관리 -교육과정선택 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRequiredMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRequiredMgrLayer() throws Exception {
		return "tra/outcome/required/requiredMgr/requiredMgrLayer";
	}
	
	
	/**
	 * 필수교육과정 대상자관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRequiredMgrList", method = RequestMethod.POST )
	public ModelAndView getRequiredMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	

	/**
	 * 필수교육과정 대상자관리 - 교육과정 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRequiredMgrPopList", method = RequestMethod.POST )
	public ModelAndView getRequiredMgrPopList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 필수교육과정 대상자관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRequiredMgr", method = RequestMethod.POST )
	public ModelAndView saveRequiredMgr(
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
			dupMap.put("YEAR",mp.get("searchYear"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("EDU_SEQ",mp.get("eduSeq"));
			dupMap.put("EDU_YM",mp.get("eduYm"));

			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;
			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TTRA161","ENTER_CD,YEAR,SABUN,EDU_SEQ,EDU_YM","s,s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = requiredMgrService.saveRequiredMgr(convertMap);
				if(resultCnt > 0){
					message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
				} else{
					message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
				}
			}

		}catch(HrException he){
			resultCnt = -1; message= he.getMessage();
		}catch(Exception e){
			resultCnt = -1;
			message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.") +"\n("+e.getMessage()+")";
			
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
	 * 필수교육과정 - 대상자생성 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcRequiredMgr", method = RequestMethod.POST )
	public ModelAndView prcRequiredMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map  ;
		map = requiredMgrService.prcRequiredMgr(paramMap);

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

		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄
		// comment 종료
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 필수교육과정 - 입과
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRequiredMgrApp", method = RequestMethod.POST )
	public ModelAndView saveRequiredMgrApp(
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
			resultCnt = requiredMgrService.saveRequiredMgrApp(convertMap);
			if(resultCnt > 0){ message="처리 되었습니다."; } else{ message="처리된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="처리 중 오류가 발생했습니다.";
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
