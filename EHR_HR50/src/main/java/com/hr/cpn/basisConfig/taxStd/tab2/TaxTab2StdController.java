package com.hr.cpn.basisConfig.taxStd.tab2;
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
@RequestMapping({"/TaxStd.do", "/TaxTab2Std.do"}) 
public class TaxTab2StdController {
	/**
	 * 세율 및 과세표준 관리 서비스
	 */
	@Inject
	@Named("TaxTab2StdService")
	private TaxTab2StdService taxTab2StdService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	

	/**
	 * 세율 및 과세표준 관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTaxTab2Std", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTaxTab2Std() throws Exception {
		return "cpn/basisConfig/taxStd/tab2/taxTab2Std";
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
	@RequestMapping(params="cmd=getTaxTab2StdList", method = RequestMethod.POST )
	public ModelAndView getTaxTab2StdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = taxTab2StdService.getTaxTab2StdList(paramMap);
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
	@RequestMapping(params="cmd=getTaxTab2StdMap", method = RequestMethod.POST )
	public ModelAndView getTaxTab2StdMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map =null;
		String Message = "";
		try{
			map = taxTab2StdService.getTaxTab2StdMap(paramMap);
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
	@RequestMapping(params="cmd=saveTaxTab2Std", method = RequestMethod.POST )
	public ModelAndView saveTaxTab2Std(
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
			dupMap.put("SEQ",mp.get("seq"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				//dupCnt = commonCodeService.getDupCnt("TCPN502","ENTER_CD,WORK_YY,SEQ","s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt =taxTab2StdService.saveTaxTab2Std(convertMap);
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
	@RequestMapping(params="cmd=insertTaxTab2Std", method = RequestMethod.POST )
	public ModelAndView insertTaxTab2Std(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sResult,sStatus,workYy,seq,lowMon,highMon,taxRate,nujinMon";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = taxTab2StdService.insertTaxTab2Std(convertMap);
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
	 * 세율 및 과세표준 관리 수정
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updateTaxTab2Std", method = RequestMethod.POST )
	public ModelAndView updateTaxTab2Std(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sResult,sStatus,workYy,seq,lowMon,highMon,taxRate,nujinMon";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = taxTab2StdService.updateTaxTab2Std(convertMap);
			if(resultCnt > 0){ message="수정 되었습니다."; } else{ message="수정된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="수정에 실패하였습니다.";
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
	 * 세율 및 과세표준 관리 삭제
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteTaxTab2Std", method = RequestMethod.POST )
	public ModelAndView deleteTaxTab2Std(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sResult,sStatus,workYy,seq,lowMon,highMon,taxRate,nujinMon";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = taxTab2StdService.deleteTaxTab2Std(convertMap);
			if(resultCnt > 0){ message="삭제 되었습니다."; } else{ message="삭제된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="삭제에 실패하였습니다.";
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
