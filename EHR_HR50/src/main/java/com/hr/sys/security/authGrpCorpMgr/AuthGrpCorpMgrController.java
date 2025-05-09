package com.hr.sys.security.authGrpCorpMgr;
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
 * 권한별회사관리 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/AuthGrpCorpMgr.do", method=RequestMethod.POST )
public class AuthGrpCorpMgrController {

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;


	/**
	 * 권한별회사관리 서비스
	 */
	@Inject
	@Named("AuthGrpCorpMgrService")
	private AuthGrpCorpMgrService authGrpCorpMgrService;
	/**
	 * 권한별회사관리 View
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAuthGrpCorpMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAuthGrpCorpMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		return "sys/security/authGrpCorpMgr/authGrpCorpMgr";
	}



	/**
	 * 권한별회사관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAuthGrpCorpMgrList", method = RequestMethod.POST )
	public ModelAndView getAuthGrpCorpMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = authGrpCorpMgrService.getAuthGrpCorpMgrList(paramMap);
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
	 * 권한별회사관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAuthGrpCorpMgr", method = RequestMethod.POST )
	public ModelAndView saveAuthGrpCorpMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",		mp.get("enterCd"));
			dupMap.put("GRP_CD",		mp.get("grpCd"));
			dupMap.put("AUTH_ENTER_CD",	mp.get("authEnterCd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TSYS318","ENTER_CD,GRP_CD,AUTH_ENTER_CD","s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재 합니다.";
			} else {
				resultCnt =authGrpCorpMgrService.saveAuthGrpCorpMgr(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
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
