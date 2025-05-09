package com.hr.sys.alteration.saveCmdMgr;
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

/**
 * saveCmdMgr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/SaveCmdMgr.do", method=RequestMethod.POST )
public class SaveCmdMgrController extends ComController {
	/**
	 * saveCmdMgr 서비스
	 */
	@Inject
	@Named("SaveCmdMgrService")
	private SaveCmdMgrService saveCmdMgrService;

	/**
	 * saveCmdMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSaveCmdMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSaveCmdMgr() throws Exception {
		return "sys/alteration/saveCmdMgr/saveCmdMgr";
	}

	/**
	 * saveCmdMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSaveCmdMgrList", method = RequestMethod.POST )
	public ModelAndView getSaveCmdMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}


	/**
	 * saveCmdMgr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSaveCmdMgr", method = RequestMethod.POST )
	public ModelAndView saveSaveCmdMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TSYS302", "CMD", "cmdData", "s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}
}
