package com.hr.cpn.personalPay.perElePayAllMgr;
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
 * 메뉴명 Controller 
 * 
 * @author 이름 
 *
 */
@Controller
@RequestMapping(value="/PerElePayAllMgr.do", method=RequestMethod.POST )
public class PerElePayAllMgrController {
	/**
	 * 메뉴명 서비스
	 */
	@Inject
	@Named("PerElePayAllMgrService")
	private PerElePayAllMgrService perElePayAllMgrService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;
	
	/**
	 * 메뉴명 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerElePayAllMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerElePayAllMgr() throws Exception {
		return "cpn/personalPay/perElePayAllMgr/perElePayAllMgr";
	}
	/**
	 * 메뉴명 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerElePayAllMgr2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerElePayAllMgr2() throws Exception {
		return "perElePayAllMgr/perElePayAllMgr";
	}
	/**
	 * 메뉴명 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerElePayAllMgrList", method = RequestMethod.POST )
	public ModelAndView getPerElePayAllMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
			if(query != null) {
				Log.Debug("query.get=> "+ query.get("query"));
				paramMap.put("query",query.get("query"));
				list = perElePayAllMgrService.getPerElePayAllMgrList(paramMap);
			} else {
				Message="조회에 실패하였습니다.";
			}
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
	 * 메뉴명 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerElePayAllMgrMap", method = RequestMethod.POST )
	public ModelAndView getPerElePayAllMgrMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = perElePayAllMgrService.getPerElePayAllMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 메뉴명 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=savePerElePayAllMgr", method = RequestMethod.POST )
	public ModelAndView savePerElePayAllMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		List<Map<String, Object>> insertList = (List<Map<String, Object>>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		
		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("ELEMENT_CD",mp.get("elementCd"));
			dupMap.put("SDATE",mp.get("sdate"));
			dupList.add(dupMap);
		}

		
		String message = "";
		int resultCnt = -1;
		
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN292","ENTER_CD,SABUN,ELEMENT_CD,SDATE","s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt =perElePayAllMgrService.savePerElePayAllMgr(convertMap);
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
	
	/**
	 * 항목별예외처리관리 종료일자 UPDATE
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN292_EDATE_UPDATE", method = RequestMethod.POST )
	public ModelAndView prcP_CPN292_EDATE_UPDATE(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("pSabun","ALL");

		Map<?, ?> map = perElePayAllMgrService.prcP_CPN292_EDATE_UPDATE(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			if (map.get("sqlcode") == null) {
				resultMap.put("Code", "0");
			} else {
				resultMap.put("Code", map.get("sqlcode").toString());
			}
			if (!("0").equals(resultMap.get("Code").toString())) {
				if (map.get("sqlerrm") != null) {
					resultMap.put("Message", map.get("sqlerrm").toString());
				} else {
					resultMap.put("Message", "자료생성 오류입니다.");
				}
			} else {
				resultMap.put("Message", "정상처리 되었습니다.");
			}
		}

		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

}
