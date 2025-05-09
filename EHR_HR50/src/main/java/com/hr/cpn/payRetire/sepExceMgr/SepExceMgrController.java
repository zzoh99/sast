package com.hr.cpn.payRetire.sepExceMgr;
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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 퇴직금예외관리 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/SepExceMgr.do", method=RequestMethod.POST )
public class SepExceMgrController {

	/**
	 * 퇴직금예외관리 서비스
	 */
	@Inject
	@Named("SepExceMgrService")
	private SepExceMgrService sepExceMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 퇴직금예외관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepExceMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepExceMgr() throws Exception {
		return "cpn/payRetire/sepExceMgr/sepExceMgr";
	}

	/**
	 * 퇴직금예외관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepExceMgrList", method = RequestMethod.POST )
	public ModelAndView getSepExceMgrList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepExceMgrService.getSepExceMgrList(paramMap);
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
	 * 퇴직금예외관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepExceMgr", method = RequestMethod.POST )
	public ModelAndView saveSepExceMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("PAY_ACTION_CD",mp.get("payActionCd"));
			dupMap.put("ELEMENT_CD",mp.get("elementCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN749","ENTER_CD,PAY_ACTION_CD,ELEMENT_CD,SABUN","s,s,s,s",dupList);
			}
			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = sepExceMgrService.saveSepExceMgr(convertMap);
				if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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