package com.hr.ben.golf.golfMgr;

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
 * 골프예약관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/GolfMgr.do", method=RequestMethod.POST )
public class GolfMgrController extends ComController {
	/**
	 * 골프예약관리 서비스
	 */
	@Inject
	@Named("GolfMgrService")
	private GolfMgrService goflMgrService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 골프예약관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewGolfMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewGolfMgr() throws Exception {
		return "ben/golf/golfMgr/golfMgr";
	}
	
	/**
	 * 골프예약관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGolfMgrList", method = RequestMethod.POST )
	public ModelAndView getGolfMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 골프예약관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveGolfMgr", method = RequestMethod.POST )
	public ModelAndView saveGolfMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TBEN470", "ENTER_CD,OCC_CD,FAM_CD,OCC_SDATE", "ssnEnterCd,goflCd,famCd,goflSdate", "s,s,s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}

}
