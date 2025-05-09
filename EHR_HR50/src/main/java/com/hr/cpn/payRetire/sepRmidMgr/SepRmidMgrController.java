package com.hr.cpn.payRetire.sepRmidMgr;
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
 * 퇴직금중간정산내역관리 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/SepRmidMgr.do", method=RequestMethod.POST )
public class SepRmidMgrController {
	/**
	 * 퇴직금중간정산내역관리 서비스
	 */
	@Inject
	@Named("SepRmidMgrService")
	private SepRmidMgrService sepRmidMgrService;


	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 퇴직금중간정산내역관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepRmidMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepRmidMgr() throws Exception {
		return "cpn/payRetire/sepRmidMgr/sepRmidMgr";
	}

	/**
	 * 퇴직금중간정산내역관리(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepRmidMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepRmidMgrPop() throws Exception {
		return "cpn/payRetire/sepRmidMgr/sepRmidMgrPop";
	}

	/**
	 * 퇴직금중간정산내역관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepRmidMgrList", method = RequestMethod.POST )
	public ModelAndView getSepRmidMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = sepRmidMgrService.getSepRmidMgrList(paramMap);
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
	 * 퇴직금중간정산내역관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepRmidMgr", method = RequestMethod.POST )
	public ModelAndView saveSepRmidMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("RMID_YMD",mp.get("rmidYmd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN769","ENTER_CD,SABUN,RMID_YMD","s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = sepRmidMgrService.saveSepRmidMgr(convertMap);
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