package com.hr.ben.golf.golfApp;

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
 * 골프예약신청 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/GolfApp.do", method=RequestMethod.POST )
public class GolfAppController extends ComController {
	/**
	 * 골프예약신청 서비스
	 */
	@Inject
	@Named("GolfAppService")
	private GolfAppService goflAppService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 골프예약신청 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewGolfApp",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewGolfApp() throws Exception {
		return "ben/golf/golfApp/golfApp";
	}
	   
	
	/**
     * 골프예약신청 View Layer
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewGolfAppLayer",method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewGolfAppLayer() throws Exception {
        return "ben/golf/golfApp/golfAppLayer";
    }
    
	/**
	 * 골프예약신청 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGolfAppList", method = RequestMethod.POST )
	public ModelAndView getGolfAppList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 골프예약신청 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGolfAppMap", method = RequestMethod.POST )
	public ModelAndView getGolfAppMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 골프예약신청 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGolfAppUserMap", method = RequestMethod.POST )
	public ModelAndView getGolfAppUserMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 골프예약신청 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGolfAppUserDupCheck", method = RequestMethod.POST )
	public ModelAndView getGolfAppUserDupCheck(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 골프예약신청 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveGolfApp", method = RequestMethod.POST )
	public ModelAndView saveGolfApp(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TBEN511", "ENTER_CD,APPL_SEQ,GOLF_CD", "ssnEnterCd,applSeq,goflCd", "s,s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}

}
