package com.hr.cpn.payRetire.retMonRptSta;
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
 * retMonRptSta Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/RetMonRptSta.do", method=RequestMethod.POST )
public class RetMonRptStaController {
	/**
	 * retMonRptSta 서비스
	 */
	@Inject
	@Named("RetMonRptStaService")
	private RetMonRptStaService retMonRptStaService;

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
	 * retMonRptSta View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetMonRptSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetMonRptSta() throws Exception {
		return "cpn/payRetire/retMonRptSta/retMonRptSta";
	}

	/**
	 * retMonRptSta(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetMonRptStaPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetMonRptStaPop() throws Exception {
		return "cpn/payRetire/retMonRptSta/retMonRptStaPop";
	}

	/**
	 * retMonRptSta 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetMonRptStaList", method = RequestMethod.POST )
	public ModelAndView getRetMonRptStaList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		String ssnEnterCd = session.getAttribute("ssnEnterCd")+"";
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		//List<?> list  = new ArrayList<Object>();
		List<Map<String, Object>> list = null;
		
	
		String Message = "";
		try{
		    if(ssnEnterCd != null) {
		        list =  (List<Map<String, Object>>) retMonRptStaService.getRetMonRptStaList(paramMap);
		        String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.CPN_RETMONRPTSTA);
		        if (encryptKey != null) {
                    for (Map<String, Object> empMap : list) {
                        empMap.put("rk", CryptoUtil.encrypt(encryptKey,  empMap.get("payActionCd") + "#" + empMap.get("sabun")));
                    }
                }
            }
			
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
	 * retMonRptSta 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRetMonRptSta", method = RequestMethod.POST )
	public ModelAndView saveRetMonRptSta(
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
			resultCnt =retMonRptStaService.saveRetMonRptSta(convertMap);
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
	 * retMonRptSta 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetMonRptStaMap", method = RequestMethod.POST )
	public ModelAndView getRetMonRptStaMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = retMonRptStaService.getRetMonRptStaMap(paramMap);
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
	
	@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
    public ModelAndView getEncryptRd(
            HttpSession session, HttpServletRequest request
            , @RequestBody Map<String, Object> paramMap) throws Exception{
        Log.DebugStart();

        //String enterCd = paramMap.get("enterCd");

        if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
            String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";

            //반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
            String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.CPN_RETMONRPTSTA);
            //rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.
        
            String strParam = paramMap.get("rk").toString();
            strParam = strParam.replaceAll("[\\[\\]]", "");
            String[] splited = strParam.split(",") ; 

            StringBuilder payActionCdKeys = new StringBuilder();
            StringBuilder empKeys = new StringBuilder();
            
            for(String str : splited) {
                String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim()+"");
                String[] keys = strDecrypt.split("#");
                
                //'급여구분'
                payActionCdKeys.append(",'" + keys[0] + "'");
                //'사번'
                empKeys.append(",'" +  keys[1]  + "'");
            }           
            
            //첫문째문자제거 
            payActionCdKeys.deleteCharAt(0);
            empKeys.deleteCharAt(0);

            String mrdPath = "/cpn/payRetire/RetirementPayAccount3.mrd";
            String param = "/rp ['" + ssnEnterCd + "']"
                    + " [" +  payActionCdKeys + "]"
                    + " [" +  empKeys + "]"
            ;

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
          return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
    }
}
