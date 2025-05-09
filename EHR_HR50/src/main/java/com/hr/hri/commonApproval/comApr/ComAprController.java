package com.hr.hri.commonApproval.comApr;
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
import com.hr.hri.commonApproval.comApp.ComAppService;

/**
 * 공통승인 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/ComApr.do", method=RequestMethod.POST )
public class ComAprController extends ComController {
	/**
	 * 공통승인 서비스
	 */
	@Inject
	@Named("ComAprService")
	private ComAprService comAprService;
	
	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	@Inject
	@Named("ComAppService")
	private ComAppService comAppService;
	/**
	 * 공통승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=viewComApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewComApr(
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
			mv.setViewName("hri/commonApproval/comApr/comAllApr");
		} else {
			Map<?, ?> map = comAppService.getComAppApplNm(urlParam);
			mv.setViewName("hri/commonApproval/comApr/comApr");
			mv.addObject("applCd", applCd);
			if(map != null) {
				mv.addObject("applTypeCd", map.get("applTypeCd"));
				mv.addObject("applNm", String.valueOf(map.get("applNm")).replace("신청","승인"));
			}
		}
		
		return mv;
	}

	/**
	 * 공통승인 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getComAprList", method = RequestMethod.POST )
	public ModelAndView getComAprList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("seqList", comAprService.getSeqList(paramMap));
		return getDataList(session, request, paramMap);
	}

	/**
	 * 공통승인 TITLE 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getComAprTitleList", method = RequestMethod.POST )
	public ModelAndView getComAprTitleList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 공통승인 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveComApr", method = RequestMethod.POST )
	public ModelAndView saveComApr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}
