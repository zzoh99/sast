package com.hr.hrm.empContract.empContractCre;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
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

/**
 * empContractCre Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/EmpContractCre.do", method=RequestMethod.POST )
public class EmpContractCreController {
	/**
	 * empContractCre 서비스
	 */
	@Inject
	@Named("EmpContractCreService")
	private EmpContractCreService empContractCreService;

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
	 * empContractCre View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpContractCre", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpContractCre() throws Exception {
		return "hrm/empContract/empContractCre/empContractCre";
	}

	/**
	 * empContractCre(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpContractCrePop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpContractCrePop() throws Exception {
		return "hrm/empContract/empContractCre/empContractCrePop";
	}

	/**
	 * empContractCre header 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpContractCreHeaderList", method = RequestMethod.POST )
	public ModelAndView getCertiAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		List<?> titleList  = new ArrayList<Object>();
		String Message = "";
		try{
			titleList = empContractCreService.getDataList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", titleList);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 계약서배포 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpContractCreList", method = RequestMethod.POST )
	public ModelAndView getEmpContractCreList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String ssnEnterCd = session.getAttribute("ssnEnterCd")+"";
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<Map<String, Object>> list  = null;
		
		String Message = "";
		try{
		    
		    if(ssnEnterCd != null) {
    			list = (List<Map<String, Object>>)  empContractCreService.getEmpContractCreList(paramMap);
    			
    	        String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_CONTRACT);
    
    	            if (encryptKey != null) {
    	                for (Map<String, Object> map  : list) {
    	                    map.put("rk", CryptoUtil.encrypt(encryptKey, map.get("sabun") + "#" + map.get("contType")  + "#" + map.get("stdDate") ));
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
	@RequestMapping(params="cmd=getEmpContractCreList", method = RequestMethod.POST )
	public ModelAndView getEmpContractCreList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		List<?> titleList = new ArrayList<Object>();

		try{
			paramMap.put("cmd", "getEmpContractCreHeaderList");
			titleList = empContractCreService.getDataList(paramMap);
			paramMap.put("titles", titleList);

			paramMap.put("cmd", "getEmpContractCreList");

			list = empContractCreService.getDataList(paramMap);
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
	 */
	
	/**
	 * empContractCre 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEmpContractCre", method = RequestMethod.POST )
	public ModelAndView saveEmpContractCre(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		// 저장 대상 입력항목 정보 설정
		List<String> saveEleNmList = new ArrayList<String>();
		List<String> saveEleColList = new ArrayList<String>();
		
		String strEleNmList = (String) convertMap.get("eleNmList");
		String strEleColList = (String) convertMap.get("eleColList");
		
		if(!StringUtils.isBlank(strEleColList)) {
			String delimeter = "@";
			
			if(!strEleColList.contains(delimeter)) {
				saveEleNmList.add(strEleNmList);
				saveEleColList.add(strEleColList);
			} else {
				String[] eleArr = strEleNmList.split(delimeter);
				for (String string : eleArr) {
					saveEleNmList.add(string);
				}
				String[] valArr = strEleColList.split(delimeter);
				for (String string : valArr) {
					saveEleColList.add(string);
				}
			}
		}
		convertMap.put("saveEleNmList", saveEleNmList);
		convertMap.put("saveEleColList", saveEleColList);
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =empContractCreService.saveEmpContractCre(convertMap);
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
	 * empContractCre 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpContractCreMap", method = RequestMethod.POST )
	public ModelAndView getEmpContractCreMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = empContractCreService.getEmpContractCreMap(paramMap);
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
	 * 계약서배포 전사원 생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=excTargetCreate", method = RequestMethod.POST )
	public ModelAndView excTargetCreate(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =empContractCreService.targetCreate(paramMap);
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

   @RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
    public ModelAndView getEncryptRd(
            HttpSession session, HttpServletRequest request
            , @RequestBody Map<String, Object> paramMap) throws Exception{
        Log.DebugStart();

        //String enterCd = paramMap.get("enterCd");

        if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
            String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
            String ssnSabun = session.getAttribute("ssnSabun") + "";
            String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";

            //반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
            String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_CONTRACT);
            //rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.
            
            String strParam = paramMap.get("rk").toString();
            
            strParam = strParam.replaceAll("[\\[\\]]", "");
            String[] splited = strParam.split(",") ; 

            Map<String,ArrayList<String>> map = new HashMap<String,ArrayList<String>>();
            for(String str : splited) {
                String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim()+"");
                String[] keys = strDecrypt.split("#");
                
                ArrayList<String> arr = new ArrayList<String>();
                arr.add(keys[1]); //계약서유형 
                arr.add(keys[2]); // 기준일자 
 
                map.put(keys[0],arr); //사번이 map key 로 들어감
            }
            
            StringBuilder empKeys = new StringBuilder();

            for (String key : map.keySet()) {
                //('사번','계약서유형','기준일자')
                empKeys.append(",('" + key + "','");
                ArrayList<String>  values = map.get(key);
                empKeys.append(  values.get(0) + "','" + values.get(1)+ "')");
            }
            
            //첫문째문자제거 
            empKeys.deleteCharAt(0);
            
            String securityKey = request.getAttribute("securityKey")+"";

            String mrdPath = "/hrm/other/EmpContract_annual_salary.mrd";
            String param = "/rp [" + ssnEnterCd + "]"
                    + " [ (" + empKeys + ") ]"
                    + " [ " + imageBaseUrl + " ] "
                    + " [ " + securityKey + " ] "
                    + " /rv securityKey[" + securityKey + "]"
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
        }else {
            
        }
        return null;
    }

}
