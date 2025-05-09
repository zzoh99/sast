package com.hr.hrm.psnalInfo.psnalContactMgr;
import java.util.*;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * psnalContactMgr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/PsnalContactMgr.do", method=RequestMethod.POST )
public class PsnalContactMgrController {
	/**
	 * psnalContactMgr 서비스
	 */
	@Inject
	@Named("PsnalContactMgrService")
	private PsnalContactMgrService psnalContactMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;	


	/**
	 * psnalContactMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalContactMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalContactMgr() throws Exception {
		return "hrm/psnalInfo/psnalContactMgr/psnalContactMgr";
	}

	/**
	 * psnalContactMgr(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalContactMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalContactMgrPop() throws Exception {
		return "hrm/psnalInfo/psnalContactMgr/psnalContactMgrPop";
	}

	/**
	 * psnalContactMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalContactMgrList", method = RequestMethod.POST )
	public ModelAndView getPsnalContactMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));

		if(!paramMap.get("searchMultiContType").toString().isEmpty())
			paramMap.put( "searchMultiContType", ((String) paramMap.get("searchMultiContType")).split(","));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
			if(query != null) {
				Log.Debug("query.get=> "+ query.get("query"));
				paramMap.put("query",query.get("query"));
			}

			list = psnalContactMgrService.getPsnalContactMgrList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * psnalContactMgr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePsnalContactMgr", method = RequestMethod.POST )
	public ModelAndView savePsnalContactMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =psnalContactMgrService.savePsnalContactMgr(convertMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * psnalContactMgr 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalContactMgrMap", method = RequestMethod.POST )
	public ModelAndView getPsnalContactMgrMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = psnalContactMgrService.getPsnalContactMgrMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
	
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
	
		Log.DebugEnd();
		return mv;
	}

	/**
	 * psnalContactMgr 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=PsnalContactMgrPrcP_PROCEDURE", method = RequestMethod.POST )
	public ModelAndView PsnalContactMgrPrcP_PROCEDURE(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnSearchType",session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",session.getAttribute("ssnGrpCd"));

		Map<?, ?> map  = psnalContactMgrService.PsnalContactMgrPrcP_PROCEDURE(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlCode : "+map.get("sqlCode"));
			Log.Debug("sqlErrm : "+map.get("sqlErrm"));
			
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		
		Log.DebugEnd();
		return mv;
	}	
}
