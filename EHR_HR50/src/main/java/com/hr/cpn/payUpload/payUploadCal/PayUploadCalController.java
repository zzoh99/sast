package com.hr.cpn.payUpload.payUploadCal;

import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * 연봉관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/PayUploadCal.do", method=RequestMethod.POST )
public class PayUploadCalController extends ComController {
	/**
	 * 연봉관리 서비스
	 */
	@Inject
	@Named("PayUploadCalService")
	private PayUploadCalService payUploadCalService;


	@RequestMapping(params="cmd=viewPayUploadCal", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayUploadCal() throws Exception{
		return "cpn/payUpload/payUploadCal/payUploadCal";
	}

	/**
	 *  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayUploadCalTitleList", method = RequestMethod.POST )
	public ModelAndView getPayUploadCalTitleList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	@RequestMapping(params="cmd=getPayUploadCalList", method = RequestMethod.POST )
	public ModelAndView getPayUploadCalList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 연봉관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePayUploadCal", method = RequestMethod.POST )
	public ModelAndView savePayUploadCal(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("elementType","A");
		List<?> list = payUploadCalService.getPayUploadCalTitleList(paramMap);
		convertMap.put("monArr",list);


		paramMap.put("elementType","D");
		list = payUploadCalService.getPayUploadCalTitleList(paramMap);
		convertMap.put("dedArr",list);


		String message = "";
		int resultCnt = -1;
		try {
			resultCnt =payUploadCalService.savePayUploadCal(convertMap);
			if (resultCnt > 0) {
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			} else {
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}
		} catch(Exception e) {
			resultCnt = -1;
			message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=getPayUploadCalCountTcpn203", method = RequestMethod.POST )
	public ModelAndView getPayUploadCalCountTcpn203(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}



	/**
	 * 급여 업로드 반영 UPDATE
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_CAL_UPLOAD", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_CAL_UPLOAD(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map = payUploadCalService.prcP_CPN_CAL_UPLOAD(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("sqlcode : "+map.get("sqlcode"));
		Log.Debug("sqlerrm : "+map.get("sqlerrm"));

		Map<String, Object> resultMap = new HashMap<>();
		if (map.get("sqlcode") == null) {
			resultMap.put("Code", "0");
		} else {
			resultMap.put("Code", map.get("sqlcode").toString());
		}
		if (!("0").equals(resultMap.get("Code").toString())) {
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "반영 오류입니다.");
			}
		} else {
			resultMap.put("Message", "정상처리 되었습니다.");
		}

		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
}
