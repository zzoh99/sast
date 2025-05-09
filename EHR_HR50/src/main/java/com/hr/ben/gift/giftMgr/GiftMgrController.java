package com.hr.ben.gift.giftMgr;

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
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
 * 선물신청관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/GiftMgr.do", method=RequestMethod.POST )
public class GiftMgrController extends ComController {
	/**
	 * 선물신청관리 서비스
	 */
	@Inject
	@Named("GiftMgrService")
	private GiftMgrService occStdService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 선물신청관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewGiftMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewGiftMgr() throws Exception {
		return "ben/gift/giftMgr/giftMgr";
	}
	
	/**
	 * 선물신청관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGiftMgrList", method = RequestMethod.POST )
	public ModelAndView getGiftMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 선물신청관리 신청건수 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGiftMgrTotalList", method = RequestMethod.POST )
	public ModelAndView getGiftMgrTotalList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	
	/**
	 * 선물신청관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveGiftMgr", method = RequestMethod.POST )
	public ModelAndView saveGiftMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return saveData(session, request, paramMap);
	}

	
}
