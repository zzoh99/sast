package com.hr.ben.gift.giftAppDet;

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
 * 선물신청상세 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping({"/GiftAppDet.do", "/GiftApp.do"}) 
public class GiftAppDetController extends ComController {
	/**
	 * 선물신청상세 서비스
	 */
	@Inject
	@Named("GiftAppDetService")
	private GiftAppDetService occStdService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 선물신청상세 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewGiftAppDet",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewGiftAppDet() throws Exception {
		return "ben/gift/giftAppDet/giftAppDet";
	}
	
   
    
    /**
     * 선물신청상세 ViewLayer
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewGiftAppDetLayer",method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewGiftAppDetLayer() throws Exception {
        return "ben/gift/giftAppDet/giftAppDetLayer";
    }
    
	
	/**
	 * 선물신청상세 신청자 정보 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGiftAppDetUseInfo", method = RequestMethod.POST )
	public ModelAndView getGiftAppDetUseInfo(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	
	/**
	 * 선물신청상세 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveGiftAppDet", method = RequestMethod.POST )
	public ModelAndView saveGiftAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return saveData(session, request, paramMap);
	}

}
