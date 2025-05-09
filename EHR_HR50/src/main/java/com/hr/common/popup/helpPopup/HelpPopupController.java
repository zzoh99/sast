package com.hr.common.popup.helpPopup;

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
 * 도움말 공통 팝업
 * @author JSG
 */
@Controller
@RequestMapping(value="/HelpPopup.do", method=RequestMethod.POST )
public class HelpPopupController {

	@Inject
	@Named("HelpPopupService")
	private HelpPopupService helpPopupService;


	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	/**
	 * 도움말 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHelpPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHelpPopup() throws Exception {
		return "common/popup/helpPopup";
	}

	/**
	 * 도움말 다운로드 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHelpPopupDown", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHelpPopupDown() throws Exception {
		return "common/popup/helpPopupDown";
	}

	/**
	 * 개인신상 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHelpPopupMap", method = RequestMethod.POST )
	public ModelAndView getHelpPopupMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd",    session.getAttribute("ssnGrpCd"));


		Map<String, Object> urlParam = new HashMap<String, Object>();
		String surl =paramMap.get("surl").toString();
		String skey = session.getAttribute("ssnEncodedKey").toString();

		String subGrpCd = null;
		String subGrpNm = null;
		urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );

		paramMap.put("searchMainMenuCd",	urlParam.get("mainMenuCd"));
		paramMap.put("searchPriorMenuCd",	urlParam.get("priorMenuCd"));
		paramMap.put("searchMenuCd",		urlParam.get("menuCd"));
		paramMap.put("searchMenuSeq",		urlParam.get("menuSeq"));


		Log.Debug("■■■■■ urlParam=" + urlParam);
		Log.Debug("■■■■■ paramMap=" + paramMap);

		Map<?, ?> map = helpPopupService.getHelpPopupMap(paramMap);
		List<?> relateMenuList = null;
		
		if(map != null && !map.isEmpty()){
			session.setAttribute("ssnMenuId",map.get("ssnMenuId"));
			// 연관메뉴 목록 조회
			relateMenuList = helpPopupService.getHelpPopupRelateMenuList(paramMap);
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		mv.addObject("relateMenuList", relateMenuList);
		Log.DebugEnd();
		return mv;
	}
}