package com.hr.cpn.payReport.payIncomeRecSta;
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


import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;

/**
 * payIncomeRecSta Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/PayIncomeRecSta.do", method=RequestMethod.POST )
public class PayIncomeRecStaController {
	/**
	 * payIncomeRecSta 서비스
	 */
	@Inject
	@Named("PayIncomeRecStaService")
	private PayIncomeRecStaService payIncomeRecStaService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
    @Inject
    @Named("EncryptRdService")
    private EncryptRdService encryptRdService;
    
    @Autowired
    private SecurityMgrService securityMgrService;
    
    @Value("${rd.image.base.url}")
    private String imageBaseUrl;

	/**
	 * payIncomeRecSta View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayIncomeRecSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayIncomeRecSta() throws Exception {
		return "cpn/payReport/payIncomeRecSta/payIncomeRecSta";
	}

	/**
	 * payIncomeRecSta(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayIncomeRecStaPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayIncomeRecStaPop() throws Exception {
		return "cpn/payReport/payIncomeRecSta/payIncomeRecStaPop";
	}

	/**
	 * payIncomeRecSta 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayIncomeRecStaList", method = RequestMethod.POST )
	public ModelAndView getPayIncomeRecStaList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = payIncomeRecStaService.getPayIncomeRecStaList(paramMap);
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
	 * payIncomeRecSta 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePayIncomeRecSta", method = RequestMethod.POST )
	public ModelAndView savePayIncomeRecSta(
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
			resultCnt =payIncomeRecStaService.savePayIncomeRecSta(convertMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * payIncomeRecSta 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayIncomeRecStaMap", method = RequestMethod.POST )
	public ModelAndView getPayIncomeRecStaMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = payIncomeRecStaService.getPayIncomeRecStaMap(paramMap);
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
    
        String language = paramMap.get("language")+"";
        String mrdPath = language.equals("E") ? "/cpn/payReport/WorkIncomeWithholdReceiptCalEng_view.mrd" : "/cpn/payReport/WorkIncomeWithholdReceiptCal_view.mrd";
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
