package com.hr.ben.pension.staPenEmpMthDataMgr;
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
 * 국민연금 고지금액관리 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/StaPenEmpMthDataMgr.do", method=RequestMethod.POST )
public class StaPenEmpMthDataMgrController {

	/**
	 * 국민연금 고지금액관리 서비스
	 */
	@Inject
	@Named("StaPenEmpMthDataMgrService")
	private StaPenEmpMthDataMgrService staPenEmpMthDataMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 국민연금 고지금액관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStaPenEmpMthDataMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStaPenEmpMthDataMgr() throws Exception {
		return "ben/pension/staPenEmpMthDataMgr/staPenEmpMthDataMgr";
	}

	/**
	 * 국민연금 고지금액관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStaPenEmpMthDataMgrList", method = RequestMethod.POST )
	public ModelAndView getStaPenEmpMthDataMgrList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("StaPenEmpMthDataMgrController.getStaPenEmpMthDataMgrList Start");

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = staPenEmpMthDataMgrService.getStaPenEmpMthDataMgrList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.Debug("StaPenEmpMthDataMgrController.getStaPenEmpMthDataMgrList End");
		return mv;
	}

	/**
	 * 국민연금 고지금액관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveStaPenEmpMthDataMgr", method = RequestMethod.POST )
	public ModelAndView saveStaPenEmpMthDataMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("StaPenEmpMthDataMgrController.saveStaPenEmpMthDataMgr Start");

		// 열로 된 데이터들을 Map 형태의 연관된 데이터 셋으로 만들기 위해 같이 묶여질 param명을 ,구분자 포함하여 만든다.
		// 파싱할 항목을 , 로 구분하여 스트링형태로 생성
		String getParamNames ="sNo,sDelete,sStatus,ym,sabun,mon1,mon2,mon3,mon4,regYn,bigo";

		// Request에서 파싱하여 저장용도로 Param을 따로 구성
		// 파싱된 객체 목록
		// "mergeRows" 	merge문을 사용하여 update,insert를 한번에 처리하기 위한 저장 List
		// "insertRows" 생성 List
		// "updateRows" 수정 List
		// "deleteRows" 삭제 List
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("YM",mp.get("ym"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TBEN112","ENTER_CD,YM,SABUN","s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재 합니다.";
			} else {
				resultCnt = staPenEmpMthDataMgrService.saveStaPenEmpMthDataMgr(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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

		Log.Debug("StaPenEmpMthDataMgrController.saveStaPenEmpMthDataMgr End");
		return mv;
	}

	/**
	 * 국민연금(전체삭제)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteStaPenEmpMthDataMgrAll", method = RequestMethod.POST )
	public ModelAndView deleteStaPenEmpMthDataMgrAll(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.Debug("StaPenEmpMthDataMgrController.deleteStaPenEmpMthDataMgrAll Start");

		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = staPenEmpMthDataMgrService.deleteStaPenEmpMthDataMgrAll(paramMap);
			if(resultCnt > 0){ message="저장 되었습니다."; }
			else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하 였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.Debug("StaPenEmpMthDataMgrController.deleteAnnualSalaryPeopleMngrAll End");
		return mv;
	}
}