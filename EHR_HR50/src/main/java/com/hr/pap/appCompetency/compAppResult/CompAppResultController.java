package com.hr.pap.appCompetency.compAppResult;
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
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;

/**
 * 다면평가결과조회 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/CompAppResult.do", method=RequestMethod.POST )
public class CompAppResultController extends ComController {
	
	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;
	
	@Autowired
	private SecurityMgrService securityMgrService;
	
	
	/**
	 * 다면평가결과조회 서비스
	 */
	@Inject
	@Named("CompAppResultService")
	private CompAppResultService compAppResultService;
	
	/**
	 * 다면평가결과조회 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompAppResult", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompAppResult() throws Exception {
		return "pap/appCompetency/compAppResult/compAppResult";
	}
	/**
	 * 다면평가결과 상세조회 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompAppResultDtlPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String veiwCompAppResultDtlPopup() throws Exception {
		return "pap/appCompetency/compAppResult/compAppResultDtlPopup";
	}
	
	/**
	 * 다면평가결과조회 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppResultList", method = RequestMethod.POST )
	public ModelAndView getCompAppResultList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<Map<String, Object>> list  = null;
		String Message = "";
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		paramMap.put("ssnEnterCd", ssnEnterCd);
		
		try{
			list = (List<Map<String, Object>>) compAppResultService.getCompAppResultList(paramMap);
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.PAP_APPREPORT);
			if (encryptKey != null) {
				 for (Map<String, Object> map  : list) {
	                    map.put("rk", CryptoUtil.encrypt(encryptKey, paramMap.get("ssnEnterCd") + "#" + paramMap.get("searchSabun") + "#" + paramMap.get("searchAppraisalCd")));
	                }
				//rk = CryptoUtil.encrypt(encryptKey, paramMap.get("ssnEnterCd") + "#" + paramMap.get("searchSabun") + "#" + paramMap.get("searchAppraisalCd"));
			}
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
	 * 다면평가결과조회 상세화면 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppResultDtlList", method = RequestMethod.POST )
	public ModelAndView getCompAppResultDtlList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = compAppResultService.getCompAppResultDtlList(paramMap);
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
	 * 다면평가결과 문항별비교 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppResultList2", method = RequestMethod.POST )
	public ModelAndView getCompAppResultList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 다면평가결과 주관식응답 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppResultList3", method = RequestMethod.POST )
	public ModelAndView getCompAppResultList3(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		return getDataList(session, request, paramMap);
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
		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
			String ssnSabun = session.getAttribute("ssnSabun") + "";
			String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";
			
			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.PAP_APPREPORT);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.
			
			String strParam = paramMap.get("rk").toString();
			strParam = strParam.replaceAll("[\\[\\]]", "");
			String[] splited = strParam.split(",") ;
			
			StringBuilder empKeys = new StringBuilder();
            StringBuilder empSabunKeys = new StringBuilder();
            
            if (StringUtils.isNoneEmpty(splited)) {
				for (String str : splited) {
					String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim() + "");
					String[] keys = strDecrypt.split("#");

					//('회사코드','사번','평가코드')
					empKeys.append(",('").append(keys[0]).append("','").append(keys[1]).append("','").append(keys[2]).append("')");
					//,사번
					empSabunKeys.append(",").append(keys[1]);
					//첫문째문자제거
					empSabunKeys.deleteCharAt(0);
				}
			}
            
            String securityKey = request.getAttribute("securityKey")+"";
            String mrdPath = (String)paramMap.get("rdMrd");
            
            String param = "/rp " + ssnEnterCd
            		+ " [" + paramMap.get("searchAppraisalCd") + "]" // 피평가자 사번, 평가소속
            		+ " [" + paramMap.get("searchSabun") + "]" ;
//            		+ " /rv securityKey[" + securityKey + "]";
            
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
		return null;
	}
	
	/**
	 * RD 데이터 암호화
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEncryptRd2", method = RequestMethod.POST )
	public ModelAndView getEncryptRd2(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
			String ssnSabun = session.getAttribute("ssnSabun") + "";
			String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";
			
			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.PAP_APPREPORT);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.
			
			String strParam = paramMap.get("rk").toString();
			strParam = strParam.replaceAll("[\\[\\]]", "");
			String[] splited = strParam.split(",") ;
			
			StringBuilder empKeys = new StringBuilder();
            StringBuilder empSabunKeys = new StringBuilder();
            
            if (StringUtils.isNoneEmpty(splited)) {
				for (String str : splited) {
					String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim() + "");
					String[] keys = strDecrypt.split("#");

					//('회사코드','사번','평가코드')
					empKeys.append(",('").append(keys[0]).append("','").append(keys[1]).append("','").append(keys[2]).append("')");
					//,사번
					empSabunKeys.append(",").append(keys[1]);
					//첫문째문자제거
					empSabunKeys.deleteCharAt(0);
				}
			}
            
            String securityKey = request.getAttribute("securityKey")+"";
            String mrdPath = (String)paramMap.get("rdMrd");
            
            String param = "/rp " + ssnEnterCd
            		+ " [" + paramMap.get("searchAppraisalCd") + "]" // 피평가자 사번, 평가소속
            		+ " [" + paramMap.get("baseURL") + "]" ;
//            		+ " /rv securityKey[" + securityKey + "]";
            
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
		return null;
	}

}
