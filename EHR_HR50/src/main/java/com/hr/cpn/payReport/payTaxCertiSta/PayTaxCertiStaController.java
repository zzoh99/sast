package com.hr.cpn.payReport.payTaxCertiSta;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.ParamUtils;
/**
 * 납세필증명서 Controller 
 * 
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/PayTaxCertiSta.do", method=RequestMethod.POST )
public class PayTaxCertiStaController {
	/**
	 * 납세필증명서 서비스
	 */
	@Inject
	@Named("PayTaxCertiStaService")
	private PayTaxCertiStaService payTaxCertiStaService;
	
    @Inject
    @Named("EncryptRdService")
    private EncryptRdService encryptRdService;
    
    @Autowired
    private SecurityMgrService securityMgrService;
    
    @Value("${rd.image.base.url}")
    private String imageBaseUrl;
    
	/**
	 * 납세필증명서 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayTaxCertiSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayTaxCertiSta() throws Exception {
		return "cpn/payReport/payTaxCertiSta/payTaxCertiSta"; 
	}
	/**
	 * 납세필증명서 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayTaxCertiStaList", method = RequestMethod.POST )
	public ModelAndView getPayTaxCertiStaList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = payTaxCertiStaService.getPayTaxCertiStaList(paramMap);
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
	 * 납세필증명서 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePayTaxCertiSta", method = RequestMethod.POST )
	public ModelAndView savePayTaxCertiSta(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =payTaxCertiStaService.savePayTaxCertiSta(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 납세필증명서 삭제
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deletePayTaxCertiSta", method = RequestMethod.POST )
	public ModelAndView deletePayTaxCertiSta(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,name,sabun,orgNm";

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = payTaxCertiStaService.deletePayTaxCertiSta(convertMap);
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
	
	/**
	 * 납세필증명서 세부내역 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=payTaxCertiStaPopup", method = RequestMethod.POST )
	public String payTaxCertiStaPopup() throws Exception {
		return "cpn/payReport/payTaxCertiSta/payTaxCertiStaPopup";
	}		
	
	/**
	 * iframe조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayTaxCertiStaIfrm", method = RequestMethod.POST )
	public ModelAndView getLargeAppmtMgrColumMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			map = payTaxCertiStaService.getPayTaxCertiStaIfrm(paramMap);
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
     * RD 데이터 암호화
     * @param session
     * @param request
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
    public ModelAndView getEncryptRd(
            HttpSession session, HttpServletRequest request
            , @RequestBody Map<String, Object> paramMap) throws Exception{
        Log.DebugStart();
   
        String mrdPath = "/cpn/payReport/TaxClearanceCertificate.mrd";
        String param = "/rp " + paramMap.get("parameters");

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        try {
            mv.addObject("DATA", encryptRdService.encrypt(mrdPath, param));
            mv.addObject("Message", "");
        } catch (Exception e) {
            mv.addObject("Message", "암호화에 실패했습니다.");
        }

        Log.DebugEnd();
        return mv;
    }

}
