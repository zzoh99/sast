package com.hr.cpn.payRetire.sepEleLinkCalcMgr;
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
 * 퇴직항목링크(계산식) Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/SepEleLinkCalcMgr.do", method=RequestMethod.POST )
public class SepEleLinkCalcMgrController {

	/**
	 * 퇴직항목링크(계산식) 서비스
	 */
	@Inject
	@Named("SepEleLinkCalcMgrService")
	private SepEleLinkCalcMgrService sepEleLinkCalcMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 퇴직항목링크(계산식) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepEleLinkCalcMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepEleLinkCalcMgr() throws Exception {
		return "cpn/payRetire/sepEleLinkCalcMgr/sepEleLinkCalcMgr";
	}

	/**
	 * 퇴직항목링크(계산식) DB ITEM검색 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewDbItemPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewDbItemPopup() throws Exception {
		return "cpn/payRetire/sepEleLinkCalcMgr/sepEleLinkCalcMgrDbItemPopup";
	}
	@RequestMapping(params="cmd=viewDbItemLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewDbItemLayer() throws Exception {
		return "cpn/payRetire/sepEleLinkCalcMgr/sepEleLinkCalcMgrDbItemLayer";
	}

	/**
	 * 퇴직항목링크(계산식) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEleLinkCalcMgrList", method = RequestMethod.POST )
	public ModelAndView getSepEleLinkCalcMgrList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepEleLinkCalcMgrService.getSepEleLinkCalcMgrList(paramMap);
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
	 * 퇴직항목링크(계산식) 계산식작성 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEleLinkCalcMgrFormulaList", method = RequestMethod.POST )
	public ModelAndView getSepEleLinkCalcMgrFormulaList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			/* 항목계산식구분(C00040)에 따른 Value명 가져오기
			 E  : 항목코드
			 ES : 항목그룹코드
			 F  : 사용자함수
			 A  : 괄호
			 B  : 사칙연산
			 C  : 상수	*/
			list = sepEleLinkCalcMgrService.getSepEleLinkCalcMgrFormulaList(paramMap);
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
	 * 퇴직항목링크(계산식) DB ITEM검색 팝업 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEleLinkCalcMgrDbItemList", method = RequestMethod.POST )
	public ModelAndView getSepEleLinkCalcMgrDbItemList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepEleLinkCalcMgrService.getSepEleLinkCalcMgrDbItemList(paramMap);
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
	 * 퇴직항목링크(계산식) 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepEleLinkCalcMgr", method = RequestMethod.POST )
	public ModelAndView saveSepEleLinkCalcMgr(
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
			dupMap.put("ELEMENT_CD",mp.get("elementCd"));
			dupMap.put("SEARCH_SEQ",mp.get("searchSeq"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN745","ENTER_CD,ELEMENT_CD,SEARCH_SEQ","s,s,i",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = sepEleLinkCalcMgrService.saveSepEleLinkCalcMgr(convertMap);
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

	/**
	 * 퇴직항목링크(계산식) 계산식작성 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepEleLinkCalcMgrFormula", method = RequestMethod.POST )
	public ModelAndView saveSepEleLinkCalcMgrFormula(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = sepEleLinkCalcMgrService.saveSepEleLinkCalcMgrFormula(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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