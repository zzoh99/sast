package com.hr.cpn.basisConfig.payRateStd.tab2;
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
 * 급여지급율관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PayRateTab2Std.do", method=RequestMethod.POST )
public class PayRateTab2StdController {
	/**
	 * 급여지급율관리 서비스
	 */
	@Inject
	@Named("PayRateTab2StdService")
	private PayRateTab2StdService payRateTab2StdService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	/**
	 * 급여지급율관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayRateTab2Std", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayRateTab2Std() throws Exception {
		return "cpn/basisConfig/payRateStd/tab2/payRateTab2Std";
	}

	/**
	 * 급여지급율관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayRateTab2StdList", method = RequestMethod.POST )
	public ModelAndView getPayRateTab2StdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = payRateTab2StdService.getPayRateTab2StdList(paramMap);
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
	 * 급여지급율관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayRateTab2StdMap", method = RequestMethod.POST )
	public ModelAndView getPayRateTab2StdMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = payRateTab2StdService.getPayRateTab2StdMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 급여지급율관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePayRateTab2Std", method = RequestMethod.POST )
	public ModelAndView savePayRateTab2Std(
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
			dupMap.put("ssnEnterCd",convertMap.get("ssnEnterCd"));
			dupMap.put("payCd",mp.get("payCd"));
			dupMap.put("gntCd",mp.get("gntCd"));
			dupMap.put("sdate",mp.get("sdate"));
			dupMap.put("seq",mp.get("seq"));
			dupList.add(dupMap);
		}
		
		String message = "";
		int resultCnt = -1;
		
		try{
			int dupCnt = 0;
            
			if(insertList.size() > 0) {
				// 중복체크
				//dupCnt = commonCodeService.getDupCnt("TCPN008","ENTER_CD,PAY_CD,GNT_CD,SDATE","s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt =payRateTab2StdService.savePayRateTab2Std(convertMap);
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
