package com.hr.hrm.promotion.promTargetLstTy;
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

/**
 * 승진대상자명단 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/PromTargetLstTy.do", method=RequestMethod.POST )
public class PromTargetLstTyController {
	/**
	 * 승진대상자명단 서비스
	 */
	@Inject
	@Named("PromTargetLstTyService")
	private PromTargetLstTyService promTargetLstTyService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * PromTargetLst View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPromTargetLstTy", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPromTargetLstTy() throws Exception {
		return "hrm/promotion/promTargetLstTy/promTargetLstTy";
	}	

	/**
	 * 승진급대상자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPromTargetLstTyList", method = RequestMethod.POST )
	public ModelAndView getPromTargetLstTyList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try {
			list = promTargetLstTyService.getPromTargetLstTyList(paramMap);
		} catch(Exception e) {
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
	 * 승진급대상자 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePromTargetLstTy", method = RequestMethod.POST )
	public ModelAndView savePromTargetLstTy(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try {
			resultCnt =promTargetLstTyService.savePromTargetLstTy(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		} catch(Exception e) {
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

	/**
	 * 승진대상자명단(대상자생성) 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prchrmPrmCreate", method = RequestMethod.POST )
	public ModelAndView prchrmPrmCreate(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",	session.getAttribute("ssnSabun"));
		paramMap.put("baseYmd",		paramMap.get("baseYmd"));
		paramMap.put("tarJikgubCd",	paramMap.get("tarJikgubCd"));

		Map map  = promTargetLstTyService.prchrmPrmCreate(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
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
	 * 가발령처리 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcHrmPrmpostCreate", method = RequestMethod.POST )
	public ModelAndView prcHrmPrmpostCreate(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",	session.getAttribute("ssnSabun"));
		paramMap.put("baseYmd",		paramMap.get("baseYmd"));
		paramMap.put("ordYmd",	paramMap.get("ordYmd"));

		Map map  = promTargetLstTyService.prcHrmPrmpostCreate(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
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
}
