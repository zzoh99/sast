package com.hr.hri.commonApproval.comApp;
import java.util.HashMap;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.ParamUtils;
import com.hr.hri.commonApproval.comApr.ComAprService;
/**
 * 공통신청 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/ComApp.do", method=RequestMethod.POST ) 
public class ComAppController extends ComController {
	/**
	 * 공통신청 서비스
	 */
	@Inject
	@Named("ComAppService")
	private ComAppService comAppService;
	@Inject
	@Named("ComAprService")
	private ComAprService comAprService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;
	

	/**
	 * 공통신청 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=viewComApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewComApp(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {

		Log.DebugStart();
		
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> urlParam = new HashMap<String, Object>();
		String surl = paramMap.get("surl") != null ? paramMap.get("surl").toString():"";
		String skey = session.getAttribute("ssnEncodedKey").toString();

		urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );

		String applCd = String.valueOf(urlParam.get("applCd"));
		if( urlParam.get("applCd") == null || "".equals(applCd)){
			mv.setViewName("hri/commonApproval/comApp/comAllApp");
		}else{

			Map<?, ?> map = comAppService.getComAppApplNm(urlParam);
			
			mv.setViewName("hri/commonApproval/comApp/comApp");
			mv.addObject("applCd", applCd);

			if(map != null) {
				mv.addObject("applTypeCd", map.get("applTypeCd"));
				mv.addObject("applNm", map.get("applNm"));
			}
		}
		
		return mv;
	}
	
	
	/**
	 * 공통신청 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getComAppList", method = RequestMethod.POST )
	public ModelAndView getComAppList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 공통신청 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getComAppTreeList", method = RequestMethod.POST )
	public ModelAndView getComAppTreeList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 공통신청 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteComApp", method = RequestMethod.POST )
	public ModelAndView deleteComApp(
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
			resultCnt =comAppService.deleteComApp(convertMap);
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
