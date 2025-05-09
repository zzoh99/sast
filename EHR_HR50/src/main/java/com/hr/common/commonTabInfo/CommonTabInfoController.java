package com.hr.common.commonTabInfo;
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
import com.hr.common.security.SecurityMgrService;

/**
 * 공통탭 정보 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/CommonTabInfo.do", method=RequestMethod.POST )
public class CommonTabInfoController {

	/**
	 * 공통탭 정보 서비스
	 */
	@Inject
	@Named("CommonTabInfoService")
	private CommonTabInfoService commonTabInfoService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	/**
	 * 공통탭 정보 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCommonTabInfo", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCommonTabInfo() throws Exception {
		return "common/include/commonTabInfo";
	}

	/**
	 * 공통탭 정보 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCommonTabInfoList", method = RequestMethod.POST )
	public ModelAndView getCommonTabInfoList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEncodedKey", 	session.getAttribute("ssnEncodedKey"));


		Map<String, Object> urlParam = new HashMap<String, Object>();
		String surl =paramMap.get("surl").toString();
		String skey = session.getAttribute("ssnEncodedKey").toString();

		String leUrl = (String)session.getAttribute("logReferer");
		Log.Debug("----> surl : "+surl);
		Log.Debug("----> skey : "+skey);
		Log.Debug("----> leUrl : "+leUrl);

		List<?> list  = new ArrayList<Object>();
		String Message = "";

		//평가화면에서 호출 시 예외 처리 jylee
		if( "".equals(surl) && leUrl != null && leUrl.indexOf("cmd=viewApp1st2ndPopPsnalBasic") > -1){

			try{
				list = commonTabInfoService.getCommonTabInfoList_PAP(paramMap);
			}catch(Exception e){
				Message="조회에 실패하였습니다.";
			}

		//조직원조회 인사팝업 호출 시 예외 처리 jylee
		}else if( "".equals(surl) && leUrl != null && leUrl.indexOf("PsnalPopup.do") > -1 ){

			try{
				paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));
				list = commonTabInfoService.getCommonTabInfoList_POP(paramMap);
			}catch(Exception e){
				Message="조회에 실패하였습니다.";
			}

		}else{
			urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );
			paramMap.put("mainMenuCd",	urlParam.get("mainMenuCd"));
			//paramMap.put("priorMenuCd",	urlParam.get("priorMenuCd"));
			paramMap.put("menuCd",		urlParam.get("menuCd"));
			paramMap.put("grpCd",		urlParam.get("grpCd"));

			try{
				list = commonTabInfoService.getCommonTabInfoList(paramMap);
			}catch(Exception e){
				Message="조회에 실패하였습니다.";
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
