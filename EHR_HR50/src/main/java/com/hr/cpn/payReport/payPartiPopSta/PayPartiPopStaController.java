package com.hr.cpn.payReport.payPartiPopSta;
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
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.ParamUtils;
import com.hr.common.language.LanguageUtil;
/**
 * 급/상여명세서 Controller 
 * 
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/PayPartiPopSta.do", method=RequestMethod.POST )
public class PayPartiPopStaController {
	/**
	 * 급/상여명세서 서비스
	 */
	@Inject
	@Named("PayPartiPopStaService")
	private PayPartiPopStaService payPartiPopStaService;
	
    @Inject
    @Named("EncryptRdService")
    private EncryptRdService encryptRdService;

    @Autowired
    private SecurityMgrService securityMgrService;

    @Value("${rd.image.base.url}")
    private String imageBaseUrl;

	    
	/**
	 * 급/상여명세서 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayPartiPopSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayPartiPopSta() throws Exception {
		return "cpn/payReport/payPartiPopSta/payPartiPopSta"; 
	}
	/**
	 * 급/상여명세서 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayPartiPopStaList", method = RequestMethod.POST )
	public ModelAndView getPayPartiPopStaList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		//List<?> list  = new ArrayList<Object>();
		List<Map<String, Object>>  list = null;
		String Message = "";
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		paramMap.put("ssnEnterCd",ssnEnterCd);
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		
		try{
		    
			list = (List<Map<String, Object>>)  payPartiPopStaService.getPayPartiPopStaList(paramMap);
            String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.CPN_PARTIPOPSTA);

            if (encryptKey != null) {
                for (Map<String, Object> map  : list) {
                    map.put("rk", CryptoUtil.encrypt(encryptKey, paramMap.get("searchPayActionCd") + "#" + map.get("sabun")));
                }
            }
		
		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급/상여명세서 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePayPartiPopSta", method = RequestMethod.POST )
	public ModelAndView savePayPartiPopSta(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =payPartiPopStaService.savePayPartiPopSta(convertMap);
			if(resultCnt > 0){ message=LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message= LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message=LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * 급/상여명세서 삭제
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deletePayPartiPopSta", method = RequestMethod.POST )
	public ModelAndView deletePayPartiPopSta(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,name,sabun,orgNm";

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = payPartiPopStaService.deletePayPartiPopSta(convertMap);
			if(resultCnt > 0){ message=LanguageUtil.getMessage("msg.alertDeleteOk", null, "자료가 삭제되었습니다."); } else{ message=LanguageUtil.getMessage("msg.alertDelNoData", null, "삭제된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message=LanguageUtil.getMessage("msg.errorDelete2", null, "삭제에 실패하였습니다.");
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
	 * 급/상여명세서 세부내역 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=payPartiPopStaPopup", method = RequestMethod.POST )
	public String payPartiPopStaPopup() throws Exception {
		return "cpn/payReport/payPartiPopSta/payPartiPopStaPopup";
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
            String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.CPN_PARTIPOPSTA);
            //rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.
        
            String strParam = paramMap.get("rk").toString();
            
            strParam = strParam.replaceAll("[\\[\\]]", "");
            String[] splited = strParam.split(",") ; 

            List<String> list = new ArrayList<String>();
            String payAcitionCdKey = "";
           
            for(String str : splited) {
                String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim()+"");
                String[] keys = strDecrypt.split("#");
                payAcitionCdKey = keys[0];
                //순서위해 list에 들어감
                list.add(keys[1]);
            }           
            StringBuilder empKeys = new StringBuilder();

            for (String str  : list) {
                //'사번'
                empKeys.append(",'" + str + "'");
            }
            //첫문째문자제거 
            empKeys.deleteCharAt(0);
            
            String securityKey = request.getAttribute("securityKey")+"";

            String mrdPath = "/cpn/payReport/PayAllowanceParticulars.mrd";
            String param = "/rp ['" + ssnEnterCd + "']"
                    + " [ '" +  payAcitionCdKey + "' ]"
                    + " [ " +  empKeys + " ]"
                    + " [ " + imageBaseUrl + " ] "
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
