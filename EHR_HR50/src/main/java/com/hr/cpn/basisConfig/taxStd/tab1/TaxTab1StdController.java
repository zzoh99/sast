package com.hr.cpn.basisConfig.taxStd.tab1;
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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.code.CommonCodeService;

/**
 * 세율 및 과세표준 관리 Controller 
 * 
 * @author AhnChangJu
 *
 */
@Controller
@RequestMapping({"/TaxStd.do", "/TaxTab1Std.do"}) 
public class TaxTab1StdController {
	/**
	 * 세율 및 과세표준 관리 서비스
	 */
	@Inject
	@Named("TaxTab1StdService")
	private TaxTab1StdService taxTab1StdService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	

	/**
	 * 세율 및 과세표준 관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTaxTab1Std", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTaxTab1Std() throws Exception {
		return "cpn/basisConfig/taxStd/tab1/taxTab1Std";
	}
	/**
	 * 세율 및 과세표준 관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTaxTab1StdList", method = RequestMethod.POST )
	public ModelAndView getTaxTab1StdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = taxTab1StdService.getTaxTab1StdList(paramMap);
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
	 * 세율 및 과세표준 관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTaxTab1StdMap", method = RequestMethod.POST )
	public ModelAndView getTaxTab1StdMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map =null;
		String Message = "";
		try{
			map = taxTab1StdService.getTaxTab1StdMap(paramMap);
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
	 * 세율 및 과세표준 관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTaxTab1Std", method = RequestMethod.POST )
	public ModelAndView saveTaxTab1Std(
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
			dupMap.put("WORK_YY",mp.get("workYy"));
			dupMap.put("TAX_RATE_CD",mp.get("taxRateCd"));
			dupList.add(dupMap);
		}
		
		String message = "";
		int resultCnt = -1;
		
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN501","ENTER_CD,WORK_YY,TAX_RATE_CD","s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt =taxTab1StdService.saveTaxTab1Std(convertMap);
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
	 * 세율 및 과세표준 관리 생성
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=insertTaxTab1Std", method = RequestMethod.POST )
	public ModelAndView insertTaxTab1Std(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sResult,sStatus,workYy,taxRateCd,taxRateNm,baseMon,ratio1,ratio2,applyMon,gubunMon,limitMon";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = taxTab1StdService.insertTaxTab1Std(convertMap);
			if(resultCnt > 0){ message="생성 되었습니다."; } else{ message="생성된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="생성에 실패하였습니다.";
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
	 * 세율 관리 및 과세 표준  - 전년도 자료 복사
	 * 
	 * 세율 관리 : TCPN501
	 * 과세 표준 : TCPN502
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcTariffMaxYearCall", method = RequestMethod.POST )
	public ModelAndView prcTariffMaxYearCall(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		
		// 프로시져 파라미터
		Map map  = taxTab1StdService.prcTariffMaxYearCall(paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if(Integer.parseInt(map.get("pCnt").toString()) == -1){
			
			resultMap.put("Code", Integer.parseInt(map.get("pCnt").toString()));
			resultMap.put("Message", "해당 년도 자료가 있습니다.");
		}else{
			resultMap.put("Code", Integer.parseInt(map.get("pCnt").toString()));
			resultMap.put("Message", "자료를 복사 하였습니다.");
		}
		
		Log.Debug("obj : "+map);
		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄
		// comment 종료
		Log.DebugEnd();
		return mv;
	}
}
