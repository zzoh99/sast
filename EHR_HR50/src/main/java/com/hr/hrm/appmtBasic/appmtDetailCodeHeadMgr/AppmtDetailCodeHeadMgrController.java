package com.hr.hrm.appmtBasic.appmtDetailCodeHeadMgr;
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
 * 발령형태코드관리 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/AppmtDetailCodeHeadMgr.do", method=RequestMethod.POST )
public class AppmtDetailCodeHeadMgrController {

	/**
	 * 발령형태코드관리 서비스
	 */
	@Inject
	@Named("AppmtDetailCodeHeadMgrService")
	private AppmtDetailCodeHeadMgrService appmtDetailCodeHeadMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 발령형태코드관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppmtDetailCodeHeadMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppmtDetailCodeHeadMgr() throws Exception {
		return "hrm/appmtBasic/appmtDetailCodeHeadMgr/appmtDetailCodeHeadMgr";
	}

	/**
	 * 발령코드 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppmtDetailCodeHeadMgrList", method = RequestMethod.POST )
	public ModelAndView getAppmtDetailCodeHeadMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appmtDetailCodeHeadMgrService.getAppmtDetailCodeHeadMgrList(paramMap);
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
	 * 발령세부코드 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppmtDetailCodeHeadMgrList2", method = RequestMethod.POST )
	public ModelAndView getAppmtDetailCodeHeadMgrList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appmtDetailCodeHeadMgrService.getAppmtDetailCodeHeadMgrList2(paramMap);
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
	 * 발령코드 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppmtDetailCodeHeadMgr", method = RequestMethod.POST )
	public ModelAndView saveAppmtDetailCodeHeadMgr(
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
			dupMap.put("ORD_TYPE_CD",mp.get("ordTypeCd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복검사
				dupCnt = commonCodeService.getDupCnt("TSYS011", "ENTER_CD,ORD_TYPE_CD", "s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복되어 저장할 수 없습니다.";
			} else {
				resultCnt =appmtDetailCodeHeadMgrService.saveAppmtDetailCodeHeadMgr(convertMap);

    		    if(resultCnt > 0){
    				message="저장 되었습니다.";
    				/*
    				convertMap.put("gubun","MAIN");

    				Map map  ;
    				map = appmtDetailCodeHeadMgrService.callP_SYS_ORD_CODE_COPY(convertMap);

    				Log.Debug("obj : "+map);
    				Log.Debug("sqlcode : "+map.get("sqlcode"));
    				Log.Debug("sqlerrm : "+map.get("sqlerrm"));

    				if (map.get("sqlCode") != null || map.get("sqlErrm") != null) {
    					message = "전사복사시 오류 발생";
    				}
    				*/

    			}else{
    				message="저장된 내용이 없습니다.";
    			}

			}
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하 였습니다.";
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
	 * 발령세부코드 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppmtDetailCodeHeadMgr2", method = RequestMethod.POST )
	public ModelAndView saveAppmtDetailCodeHeadMgr2(
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
			dupMap.put("ORD_TYPE_CD",mp.get("ordTypeCd"));
			dupMap.put("ORD_DETAIL_CD",mp.get("ordDetailCd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복검사
				dupCnt = commonCodeService.getDupCnt("TSYS013", "ENTER_CD,ORD_TYPE_CD,ORD_DETAIL_CD", "s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복되어 저장할 수 없습니다.";
			} else {
				resultCnt =appmtDetailCodeHeadMgrService.saveAppmtDetailCodeHeadMgr2(convertMap);

    		    if(resultCnt > 0){
    				message="저장 되었습니다.";

    				/*
    				convertMap.put("gubun","DETAIL");

    				Map map  ;
    				map = appmtDetailCodeHeadMgrService.callP_SYS_ORD_CODE_COPY(convertMap);

    				Log.Debug("obj : "+map);
    				Log.Debug("sqlcode : "+map.get("sqlcode"));
    				Log.Debug("sqlerrm : "+map.get("sqlerrm"));

    				if (map.get("sqlCode") != null || map.get("sqlErrm") != null) {
    					message = "전사복사시 오류 발생";
    				}
    				*/

    			}else{
    				message="저장된 내용이 없습니다.";
    			}

			}
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하 였습니다.";
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
