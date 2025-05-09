package com.hr.common.security;

import com.hr.common.logger.Log;
import com.hr.common.util.SessionUtil;
import com.hr.common.util.StringUtil;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 *  보안체크
 *
 * @author ParkMoohun
 *
 */
@Controller
public class SecurityMgrController {


	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	@RequestMapping(value="/SecurityToken.do", method=RequestMethod.POST )
	public ModelAndView securityToken(
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		/*
		 * 	1차평가 화면 URL에 파라미터가 붙어 있는데.. Controller 에서 받았을 때 파라미터가 분리 됨.
		    prgCd=/App1st2nd.do?cmd=viewApp1st2nd&earchAppSeqCd=1
			paramMap : {prgCd=/App1st2nd.do?cmd=viewApp1st2nd, searchAppSeqCd=1}
			파라미터가 분리됨.
		  
		 */
		// 분리된 파라미터 붙여주기

		Log.Debug("★★★securityToken --> paramMap : " + paramMap );

		String prgCd = (String)paramMap.get("prgCd");
		for( String key : paramMap.keySet() ){
        	if( !key.equals("prgCd") ){
        		if( prgCd.indexOf("?") > -1 ){
        			prgCd += "&"+key+"="+paramMap.get(key);
        		}else{
        			prgCd += "?"+key+"="+paramMap.get(key);
        		}
        	}
        }

		Log.Debug("★★★securityToken --> paramMap : " + paramMap );
		Log.Debug("★★★securityToken --> prgCd : " + prgCd );
		
		paramMap.put("prgCd", prgCd);
		
		//Log.Debug("★★★securityToken --> paramMap : " + paramMap );
		
		Map<?, ?> map = securityMgrService.getToken(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 메뉴 접근 권한이 없음으로 인한 로그아웃 처리  -- Interceptor 에서 처리
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/SecurityError.do", method=RequestMethod.POST )
	public ModelAndView SecurityError(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();

		String code = (String) paramMap.get("code");
		String msg = "Error";
		
				
		HttpSession session = request.getSession(false);
		String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
		String errorUrl = (String)session.getAttribute("errorUrl");
		String ssnGrpCd = (String)session.getAttribute("ssnGrpCd");
		String ssnSabun = (String)session.getAttribute("ssnSabun");
		
		/**  관리자가 사용자변경으로 로그인 했을 때
		 **/
		String ssnAdminSabun = (String)session.getAttribute("ssnAdminSabun");
		String msg0 = "";
		if( ssnAdminSabun != null && ssnSabun != null && !ssnSabun.equals(ssnAdminSabun)){
			msg0 = "[A:"+ssnAdminSabun+"], ";
		}
		
		 //* 993 : 파라미터 변조
		 //* 995 : URL 직접 접근
		 if( code.equals("993")){
			msg = "파라미터 변조 => " + session.getAttribute("errorMsg");
		}else if( code.equals("995")){
			msg = "URL 직접 접근";
		}
		
		paramMap.put("ssnEnterCd",	ssnEnterCd);
		paramMap.put("job",			"view");
		paramMap.put("ip",			StringUtil.getClientIP(request));
		paramMap.put("refererUrl",	"");
		paramMap.put("requestUrl",	errorUrl);
		paramMap.put("controller",	"");
		paramMap.put("queryId",		code);
		paramMap.put("menuId",		"");
		paramMap.put("ssnGrpCd",	ssnGrpCd);
		paramMap.put("memo",		msg0+msg);
		paramMap.put("ssnSabun",	ssnSabun);
		
		Log.Debug("OBSERVER PARAM: {}", JSONObject.toJSONString(paramMap));

		securityMgrService.PrcCall_P_COM_SET_OBSERVER(paramMap);

		session.invalidate();
		Log.DebugEnd();
		
		return new ModelAndView("redirect:/Info.do?code="+code);
		
	}
	/**
	 * URL 정보  가져오기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */

	@RequestMapping(value="/getDecryptUrl.do", method=RequestMethod.POST )
	public ModelAndView getDecryptUrl(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Log.Debug("paramMap>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+ paramMap.toString());
		String url = (String) paramMap.get("surl");
		String key = (String) session.getAttribute("ssnEncodedKey");

		Log.Debug("url=================================================>"+ url);
		Log.Debug("key=================================================>"+ key);
		Map<?, ?> rtn = securityMgrService.getDecryptUrl(url,key) ;


		// logRequestBaseUrl 값 추가
		if (rtn != null && !"".equals(rtn.get("url"))) {
			SessionUtil.setRequestAttribute("logRequestBaseUrl", rtn.get("url"));
		} else {
			SessionUtil.setRequestAttribute("logRequestBaseUrl", "");
		}

		Log.Debug("||-----------------------------------------||");
		Log.Debug("subGrpCd"+ rtn.get("subGrpCd"));
		Log.Debug("mainMenuCd"+ rtn.get("mainMenuCd"));
		Log.Debug("||-----------------------------------------||");

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", rtn);
		Log.DebugEnd();
		return mv;
	}
	
}
