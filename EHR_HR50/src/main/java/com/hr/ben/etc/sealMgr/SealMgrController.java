package com.hr.ben.etc.sealMgr;

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * 인장현황관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/SealMgr.do", method=RequestMethod.POST ) 
public class SealMgrController extends ComController {
	/**
	 * 인장현황관리 서비스
	 */
	@Inject
	@Named("SealMgrService")
	private SealMgrService sealMgrService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 인장현황관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSealMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSealMgr() throws Exception {
		return "ben/etc/sealMgr/sealMgr";
	}
	
	/**
	 * 인장현황관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSealMgrList", method = RequestMethod.POST )
	public ModelAndView getSealMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 인장현황관리  조직도  조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSealMgrOrgList", method = RequestMethod.POST )
	public ModelAndView getSealMgrOrgList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	

	/**
	 * 인장현황관리 담당자  조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSealMgrMngList", method = RequestMethod.POST )
	public ModelAndView getSealMgrMngList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 인장현황관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSealMgr", method = RequestMethod.POST )
	public ModelAndView saveSealMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		//String[] dupList= {"TBEN650", "ENTER_CD,JIKGUB_CD,SDATE", "ssnEnterCd,jikgubCd,sdate", "s,s,s"};
		//paramMap.put("dupList", dupList);
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		return saveData(session, request, paramMap);
	}

	/**
	 * 인장현황관리 담당자 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSealMgrMng", method = RequestMethod.POST )
	public ModelAndView saveSealMgrMng(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		String message = "";
		int resultCnt = -1;
		try{

			 //테이블명, 컬럼명,  파라메터키, 데이터 타입
			String[] dupList= {"TBEN743", "ENTER_CD,ORG_CD,SEQ,GUBUN,SDATE", "ssnEnterCd,orgCd,seq,gubun,sdate", "s,s,s,s,s"};
			convertMap.put("dupList", dupList);

			resultCnt = sealMgrService.saveSealMgrMng(convertMap);
			if(resultCnt > 0){ message="처리 되었습니다."; } else{ message="처리된 내용이 없습니다."; }

		}catch(HrException he){
			resultCnt = -1; message= he.getMessage();
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
