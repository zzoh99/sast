package com.hr.pap.progress.appFeedBackLst;

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
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;

/**
 * 평가결과피드백 Controller
 *
 */
@Controller
@RequestMapping(value="/AppFeedBackLst.do", method=RequestMethod.POST )
public class AppFeedBackLstController extends ComController {
	
	@Autowired
	private SecurityMgrService securityMgrService;
	
	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;
	
	@Inject
	@Named("AppFeedBackLstService")
	private AppFeedBackLstService appFeedBackLstService;
	
	/**
	 * 평가결과피드백 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppFeedBackLst", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppFeedBackLst() throws Exception {
		return "pap/progress/appFeedBackLst/appFeedBackLst";
	}

	/**
	 * 평가결과_임시 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppFeedBackLst2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppFeedBackLst2() throws Exception {
		return "pap/progress/appFeedBackLst/appFeedBackLst2";
	}
	
	/**
	 * 평가결과피드백 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppFeedBackLst3", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppFeedBackLst3() throws Exception {
		return "pap/progress/appFeedBackLst/appFeedBackLst3";
	}

	/**
	 * 평가결과피드백 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppFeedBackLstList", method = RequestMethod.POST )
	public ModelAndView getAppFeedBackLstList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가결과피드백 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppFeedBackLst", method = RequestMethod.POST )
	public ModelAndView saveAppFeedBackLst(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 이의제기 Comment View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppFeedBackLstComment", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppFeedBackLstComment() throws Exception {
		return "pap/progress/appFeedBackLst/appFeedBackLstComment";
	}

	/**
	 * 이의제기 Comment View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppFeedBackLstCommentLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppFeedBackLstCommentLayer() throws Exception {
		return "pap/progress/appFeedBackLst/appFeedBackLstCommentLayer";
	}

	/**
	 * 이의제기 Comment 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppFeedBackCommentLstList", method = RequestMethod.POST )
	public ModelAndView getAppFeedBackCommentLstList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 이의제기 Comment 저장
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppFeedBackLstComment", method = RequestMethod.POST )
	public ModelAndView saveAppFeedBackLstComment(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		// System.out.println(paramMap);

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = appFeedBackLstService.saveAppFeedBackLstComment(paramMap);
			if (resultCnt > 0) {
				message = "저장되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
		} catch (Exception e) {
			resultCnt = -1;
			message = "저장에 실패하였습니다.";
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
	 * 평가결과피드백(관리자) View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppFeedBackAllLst", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppFeedBackAllLst() throws Exception {
		return "pap/progress/appFeedBackLst/appFeedBackAllLst";
	}

	/**
	 * 평가결과피드백(관리자) 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppFeedBackAllLstList", method = RequestMethod.POST )
	public ModelAndView getAppFeedBackAllLstList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<Map<String, Object>>  list = null;
		String Message = "";
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		paramMap.put("ssnEnterCd",ssnEnterCd);
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		
		try {
			list = (List<Map<String, Object>>)  appFeedBackLstService.getAppFeedBackAllLstList(paramMap);
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.PAP_APPREPORT);
		
			if (encryptKey != null) {
	                for (Map<String, Object> map  : list) {
	                    map.put("rk", CryptoUtil.encrypt(encryptKey, paramMap.get("ssnEnterCd") + "#" + map.get("sabun")));
	        
	                }
			}
		} catch (Exception e) {
			Message=LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다.");
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		return mv;
	}
	
	/**
	 * 평가결과피드백 탭 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppFeedBackLstTab", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppFeedBackLstTab() throws Exception {
		return "pap/progress/appFeedBackLst/appFeedBackLstTab";
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

					//('회사코드','사번')
					empKeys.append(",('").append(keys[0]).append("','").append(keys[1]).append("')");
					//,사번
					empSabunKeys.append(",").append(keys[1]);
					//첫문째문자제거
					empSabunKeys.deleteCharAt(0);
				}
			}
            
            String securityKey = request.getAttribute("securityKey")+"";
            String mrdPath = "/pap/progress/AppReport_HR.mrd";
            
            String param = "/rp " + ssnEnterCd
            		+ " [5]" // 단계
            		+ " [6]" // 차수
            		+ " [" + paramMap.get("searchAppraisalCdSAbunAppOrgCd_s") + "]" // 피평가자 사번, 평가소속
            		+ " [Y]"; // 최종결과출력
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
	
	@RequestMapping(params="cmd=viewAppFeedBackLstLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppFeedBackLstLayer() throws Exception {
		return "/pap/progress/appFeedBackLst/appFeedBackLstLayer";
	}
	
	@RequestMapping(params="cmd=viewAppFeedBackResultLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppFeedBackResultLayer() throws Exception {
		return "/pap/progress/appFeedBackLst/appFeedBackResultLayer";
	}
}
