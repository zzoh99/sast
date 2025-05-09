package com.hr.cpn.payRetire.sepPenTypeMgr;
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

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 퇴직연금유형관리 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/SepPenTypeMgr.do", method=RequestMethod.POST )
public class SepPenTypeMgrController {

	/**
	 * 퇴직연금유형관리 서비스
	 */
	@Inject
	@Named("SepPenTypeMgrService")
	private SepPenTypeMgrService sepPenTypeMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;	

	
	/**
	 * 퇴직연금유형관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepPenTypeMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepPenTypeMgr() throws Exception {
		return "cpn/payRetire/sepPenTypeMgr/sepPenTypeMgr";
	}

	/**
	 * 퇴직연금유형관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepPenTypeMgrList", method = RequestMethod.POST )
	public ModelAndView getSepPenTypeMgrList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
			Log.Debug("query.get=> "+ query.get("query"));
			paramMap.put("query",query.get("query"));

			list = sepPenTypeMgrService.getSepPenTypeMgrList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 퇴직연금유형관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=saveSepPenTypeMgr", method = RequestMethod.POST )
	public ModelAndView saveSepPenTypeMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map<String, Object>> insertList = (List<Map<String, Object>>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("SDATE",mp.get("sdate"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN710","ENTER_CD,SABUN,SDATE","s,s,s",dupList);
			}
			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = sepPenTypeMgrService.saveSepPenTypeMgr(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
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
}