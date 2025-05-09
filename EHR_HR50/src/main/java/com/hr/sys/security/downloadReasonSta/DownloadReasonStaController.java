package com.hr.sys.security.downloadReasonSta;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;

/**
 * 파일다운로드 사유 현황 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/DownloadReasonSta.do", method=RequestMethod.POST )
public class DownloadReasonStaController extends ComController {

	@Inject
	@Named("DownloadReasonStaService")
	private	DownloadReasonStaService downloadReasonStaService;

	
	/**
	 * 파일다운로드 사유 현황 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewDownloadReasonSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewDownloadReasonSta() throws Exception {
		return "sys/security/downloadReasonSta/downloadReasonSta";
	}

	/**
	 * 파일다운로드 사유 현황 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getDownloadReasonStaList", method = RequestMethod.POST )
	public ModelAndView getDownloadReasonStaList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 파일다운로드 사유 현황 등록 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewDownloadReasonStaRegPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String view() throws Exception {
		return "downloadReasonStaRegLayer";
	}

	/**
	 * 파일다운로드 사유 현황 등록 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewDownloadReasonStaRegLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewDownloadReasonStaRegLayer() throws Exception {
		return "sys/security/downloadReasonSta/downloadReasonStaRegLayer";
	}

	/**
	 * 파일다운로드 사유 현황 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=regDownloadReasonSta", method = RequestMethod.POST )
	public ModelAndView regDownloadReasonSta(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		if( session != null && session.getAttribute("ssnDownloadTempPassword") != null ) {
			session.removeAttribute("ssnDownloadTempPassword");
		}
		
		String tempPassword = null;

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd",   session.getAttribute("ssnGrpCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = downloadReasonStaService.insertDownloadReasonSta(paramMap);
			if(resultCnt > 0){ 
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
				
				// 다운로드 암호 설정 여부가 활성화 되어 있지 않은 경우 실행.
				if( session.getAttribute("ssnFileDownSetPwd") == null || !"Y".equals(session.getAttribute("ssnFileDownSetPwd")) ) {
					// 임시비밀번호 생성
					Map<String,Object> result = (Map<String, Object>) downloadReasonStaService.getDownloadReasonStaTempPasswd(paramMap);
					if( result != null && result.containsKey("tPasswd") ) {
						tempPassword = (String) result.get("tPasswd");
						if( !StringUtils.isBlank(tempPassword) ) {
							session.setAttribute("ssnDownloadTempPassword", tempPassword);
						}
					}
				}
			} else{
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); 
			}
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		mv.addObject("tempPassword", tempPassword);
		Log.DebugEnd();
		return mv;
	}
}
