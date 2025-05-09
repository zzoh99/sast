package com.hr.sys.pwrSrch.pwrSrchMgr;

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
import com.hr.common.util.ParamUtils;
import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;


/**
 * 조건검색관리(Admin)
 *
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/PwrSrchMgr.do", method=RequestMethod.POST )
public class PwrSrchMgrController {

	@Inject
	@Named("PwrSrchMgrService")
	private PwrSrchMgrService pwrSrchMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	/**
	 * 조건검색관리(Admin) 화면
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPwrSrchMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewPwrSrchMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();


		//////////
		Map<String, Object> urlParam = new HashMap<String, Object>();
		String surl =paramMap.get("murl").toString();
		String skey = session.getAttribute("ssnEncodedKey").toString();

		String subGrpCd = null;
		String subGrpNm = null;
		urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );

		//////////

		ModelAndView mv = new ModelAndView();

		mv.setViewName("sys/pwrSrch/pwrSrchMgr/pwrSrchMgr");
		mv.addObject("result", urlParam);
		return mv;

		//return "sys/pwrSrch/pwrSrchMgr/pwrSrchMgr";
	}


	/**
	 * 조건검색 조회
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchMgrList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchMgrList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List<?> resultList = pwrSrchMgrService.getPwrSrchMgrList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", resultList);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 조건검색 저장
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePwrSrchMgr", method = RequestMethod.POST )
	public ModelAndView savePwrSrchMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();

		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", ssnEnterCd);
		int result =-1;

		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		int cnt = 0;
		if(insertList.size()>0){
    		for(Map<String,Object> mp : insertList) { Map<String,Object> dupMap = new HashMap<String,Object>();
    			dupMap.put("ENTER_CD"	,ssnEnterCd);
    			dupMap.put("SEARCH_SEQ"	,mp.get("searchSeq"));
    			dupList.add(dupMap);
    		}
    		try{ cnt = commonCodeService.getDupCnt("THRI201", "ENTER_CD,SEARCH_SEQ", "s,i",dupList);
	    		if(cnt > 0 ) cnt = -1; message="중복된 값이 존재합니다.";
    		}catch(Exception e){ cnt = -1; message="중복 체크에 실패하였습니다."; }
		}
		if(cnt == 0){
			try{ cnt = pwrSrchMgrService.savePwrSrchMgr(convertMap);
				if (cnt > 0) { message="저장되었습니다."; }  else { message="저장된 내용이 없습니다."; }
			}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		}
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 조건검색 BIZ 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchMgrBizPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchMgrBizPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("PwrSrchMgrController.pwrSrchMgrBizPopup");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sys/pwrSrch/pwrSrchMgr/pwrSrchMgrBizPopup");
		return mv;
	}

	/**
	 * 조건검색 ADMIN 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchMgrAdminPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchMgrAdminPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("PwrSrchMgrController.pwrSrchMgrAdminPopup");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sys/pwrSrch/pwrSrchMgr/pwrSrchMgrAdminPopup");
		return mv;
	}

	/**
	 * 조건검색  SuiTableMatch 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchMgrSuiTableMatchPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchMgrSuitableMatchPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("PwrSrchMgrController.pwrSrchMgrSuitableMatchPopup");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sys/pwrSrch/pwrSrchMgr/pwrSrchMgrSuitableMatchPopup");
		return mv;
	}
}
