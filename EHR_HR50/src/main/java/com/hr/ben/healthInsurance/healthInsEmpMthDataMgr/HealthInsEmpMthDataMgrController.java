package com.hr.ben.healthInsurance.healthInsEmpMthDataMgr;
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
 * 건강보험 고지금액관리 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/HealthInsEmpMthDataMgr.do", method=RequestMethod.POST )
public class HealthInsEmpMthDataMgrController {

	/**
	 * 건강보험 고지금액관리 서비스
	 */
	@Inject
	@Named("HealthInsEmpMthDataMgrService")
	private HealthInsEmpMthDataMgrService healthInsEmpMthDataMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 건강보험 고지금액관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHealthInsEmpMthDataMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHealthInsEmpMthDataMgr() throws Exception {
		return "ben/healthInsurance/healthInsEmpMthDataMgr/healthInsEmpMthDataMgr";
	}

	/**
	 * 건강보험 고지금액관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHealthInsEmpMthDataMgrList", method = RequestMethod.POST )
	public ModelAndView getHealthInsEmpMthDataMgrList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("HealthInsEmpMthDataMgrController.getHealthInsEmpMthDataMgrList Start");

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = healthInsEmpMthDataMgrService.getHealthInsEmpMthDataMgrList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.Debug("HealthInsEmpMthDataMgrController.getHealthInsEmpMthDataMgrList End");
		return mv;
	}

	/**
	 * 건강보험 고지금액관리 저장/건강보험 기본사항(TBEN201)-증번호 UPDATE
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveHealthInsEmpMthDataMgr", method = RequestMethod.POST )
	public ModelAndView saveHealthInsEmpMthDataMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("HealthInsEmpMthDataMgrController.saveHealthInsEmpMthDataMgr Start");

		// 열로 된 데이터들을 Map 형태의 연관된 데이터 셋으로 만들기 위해 같이 묶여질 param명을 ,구분자 포함하여 만든다.
		// 파싱할 항목을 , 로 구분하여 스트링형태로 생성
		String getParamNames ="sNo,sDelete,sStatus,sabun,resNo,ym,identityNo,acqYmd,lossYmd,reason,rewardTotMon,sYm,eYm,reason1,mon1,mon2,mon3,mon4,mon5,sYm2,eYm2,reason2,mon6,mon7,mon8,mon9,mon10,mon11,mon12,mon13,mon14,mon15,regYn,bigo";

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
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("YM",mp.get("ym"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TBEN212","ENTER_CD,SABUN,YM","s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재 합니다.";
			} else {
				resultCnt = healthInsEmpMthDataMgrService.saveHealthInsEmpMthDataMgr(convertMap);
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

		Log.Debug("HealthInsEmpMthDataMgrController.saveHealthInsEmpMthDataMgr End");
		return mv;
	}
}