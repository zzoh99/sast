package com.hr.ben.gift.giftApp;

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
 * 선물신청 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/GiftApp.do", method=RequestMethod.POST )
public class GiftAppController extends ComController {
	/**
	 * 선물신청 서비스
	 */
	@Inject
	@Named("GiftAppService")
	private GiftAppService occStdService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 선물신청 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewGiftApp",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewGiftApp() throws Exception {
		return "ben/gift/giftApp/giftApp";
	}
	
	/**
	 * 선물신청 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGiftAppList", method = RequestMethod.POST )
	public ModelAndView getGiftAppList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
}
