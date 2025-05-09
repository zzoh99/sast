package com.hr.tim.code.holidayOccurStd.occurExcStd;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 하계휴가차감기준 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/OccurExcStd.do", method=RequestMethod.POST )
public class OccurExcStdController extends ComController {

	/**
	 * 하계휴가차감기준 서비스
	 */
	@Inject
	@Named("OccurExcStdService")
	private OccurExcStdService occurExcStdService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 하계휴가차감기준 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOccurExcStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOccurExcStd() throws Exception {
		return "tim/code/holidayOccurStd/occurExcStd/occurExcStd";
	}

	/**
	 * 휴가 발생조건 - 하계휴가 차감일수 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOccurExcStdList", method = RequestMethod.POST )
	public ModelAndView getOccurExcStdList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	
	/**
	 * 휴가 발생조건 - 하계휴가 차감일수 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOccurExcStd", method = RequestMethod.POST )
	public ModelAndView saveOccurExcStd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TTIM030", "ENTER_CD,GNT_CD,WORK_TYPE,JIKGUB_CD", "ssnEnterCd,gntCd,workType,jikgubCd", "s,s,s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}
}
