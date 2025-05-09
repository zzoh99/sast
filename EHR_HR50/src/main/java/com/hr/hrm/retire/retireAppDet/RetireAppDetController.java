package com.hr.hrm.retire.retireAppDet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 퇴직신청 세부내역 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping({"/RetireApp.do","/RetireAppDet.do"})
public class RetireAppDetController {

	/**
	 * 퇴직신청 세부내역 서비스
	 */
	@Inject
	@Named("RetireAppDetService")
	private RetireAppDetService retireAppDetService;

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
	 * 퇴직신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetireAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetireAppDet() throws Exception {
		return "hrm/retire/retireAppDet/retireAppDet";
	}
	
	/**
	 * 퇴직신청 퇴직설문지 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetireSurveyPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetireSurveyPopup() throws Exception {
		return "hrm/retire/retireAppDet/retireSurveyPopup";
	}
	
	@RequestMapping(params="cmd=viewRetireSurveyLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetireSurveyLayer() throws Exception {
		return "hrm/retire/retireAppDet/retireSurveyLayer";
	}
	
	/**
	 * 퇴직자 CheckList 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetireCheckListAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetireCheckListAppDet() throws Exception {
		return "hrm/retire/retireCheckListAppDet/retireCheckListAppDet";
	}
		

	/**
	 * 퇴직신청 결재자 구분 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetireGb", method = RequestMethod.POST )
	public ModelAndView getRetireGb(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<?,?> mp = retireAppDetService.getRetireGb(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", mp);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 퇴직신청 세부내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetireAppDetList", method = RequestMethod.POST )
	public ModelAndView getRetireAppDetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String ssnEnterCd = (String) session.getAttribute("ssnEnterCd");
		paramMap.put("ssnEnterCd", ssnEnterCd);

		List<Map<String, Object>> list  = new ArrayList<>();
		String Message = "";
		try{
			list = (List<Map<String, Object>>) retireAppDetService.getRetireAppDetList(paramMap);

			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_RETIRE);
			if (encryptKey != null) {
				for (Map<String, Object> map : list) {
					map.put("rk", CryptoUtil.encrypt(encryptKey, map.get("sabun") + "#" + map.get("applYmd") + "#" + map.get("signFileSeq")));
					map.put("rk2", CryptoUtil.encrypt(encryptKey, map.get("sabun") + "#" + map.get("applYmd") + "#" + map.get("applSeq") + "#" + map.get("signFileSeq1")
									+ "#" + map.get("finWorkYmd") + "#" + map.get("retSchYmd") + "#" + map.get("note") + "#" + map.get("retContractNo")));
				}
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
	 * 퇴직신청 세부내역 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRetireAppDet", method = RequestMethod.POST )
	public ModelAndView saveRetireAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
		String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd);
		convertMap.put("schSignFileSeq1", CryptoUtil.decrypt(encryptKey, convertMap.get("schSignFileSeq1")+""));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = retireAppDetService.saveRetireAppDet(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 퇴직신청(퇴직설문지) 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetireSurveyPopList", method = RequestMethod.POST )
	public ModelAndView getRetireSurveyPopList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = retireAppDetService.getRetireSurveyPopList(paramMap);
			//저장된 데이터가 없을경우 설문항목관리에서 테이더 가져오기
			if(list == null || list.size() < 1) {
				list = retireAppDetService.getRetireSurveyPopList1(paramMap);
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
	 * 퇴직신청(퇴직설문지-불만족) 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetireSurveyPopDisList", method = RequestMethod.POST )
	public ModelAndView getRetireSurveyPopDisList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = retireAppDetService.getRetireSurveyPopDisList(paramMap);
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
	 * 퇴직신청 퇴직설문지 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRetireSurveyPopList", method = RequestMethod.POST )
	public ModelAndView saveRetireSurveyPopList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		convertMap.put("sabun",paramMap.get("sabun"));
		convertMap.put("reqDate",paramMap.get("reqDate"));
		convertMap.put("surveyMemoHid",paramMap.get("surveyMemoHid"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = retireAppDetService.saveRetireSurveyPopList(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 퇴직신청 설문지 등록여부 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetireSurveyYnMap", method = RequestMethod.POST )
	public ModelAndView getRetireSurveyYnMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<?,?> mp = retireAppDetService.getRetireSurveyYnMap(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", mp);
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
			String type = String.valueOf(paramMap.get("type"));

			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_RETIRE);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.

			String strParam = paramMap.get("rk").toString();

			strParam = strParam.replaceAll("[\\[\\]]", "");
			String[] splited = strParam.split(",") ;
			String mrdPath = "";
			String param = "";
			if ("1".equalsIgnoreCase(type)) { // 비밀서약서
				String sabun = "";
				String applYmd = "";
				String signFileSeq = "";

				for(String str : splited) {
					String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim()+"");
					String[] keys = strDecrypt.split("#");
					sabun = keys[0];
					applYmd = keys[1];
					signFileSeq = keys[2];
				}

				String securityKey = request.getAttribute("securityKey")+"";

				mrdPath = "/hrm/retire/RetireSecret.mrd";
				param = "/rp [" + ssnEnterCd + "]"
						+ " [" +  sabun + "]"
						+ " [" +  applYmd + "]"
						+ " [" + imageBaseUrl + "]"
						+ " [" +  signFileSeq +"]"
						;
			} else if  ("2".equalsIgnoreCase(type)) { // 사직원
				String sabun = "";
				String applYmd = "";
				String applSeq = "";
				String signFileSeq = "";
				String finWorkYmd = "";
				String retSchYmd = "";
				String note = "";
				String retContractNo = "";
				String target = "";
				for(String str : splited) {
					if ("".equalsIgnoreCase(str)) {
						continue;
					}
					String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim()+"");
					String[] keys = strDecrypt.split("#");
					sabun = keys[0];
					applYmd = keys[1];
					applSeq = keys[2];
//					signFileSeq = keys[3];
//					finWorkYmd = keys[4];
//					retSchYmd = keys[5];
//					note = keys[6];
//					retContractNo = keys[7];
					target += ",('" + ssnEnterCd + "','" + applSeq + "')";
				}

				String securityKey = request.getAttribute("securityKey")+"";
				mrdPath = "/hrm/retire/Retire_EB.mrd";
				//sabun = ",('${ssnEnterCd}','" + sheet1.GetCellValue(row,"applSeq") + "')";
				param = "/rp [" + ssnEnterCd + "]"
						+ " [" + target + "]"
						+ " [" + applYmd + "]"
						+ " [" + applSeq + "]"
						+ " [" + imageBaseUrl + "]"
//						+ " [" +  signFileSeq +"]"
//						+ " [" +  finWorkYmd +"]"
//						+ " [" +  retSchYmd +"]"
//						+ " [" +  note +"]"
//						+ " [" +  retContractNo +"]"
				;
			} else if  ("3".equalsIgnoreCase(type)) { // 사직원 미리보기
				String sabun = "";
				String reqDate = "";
				String applSeq = "";
				String signFileSeq = "";
				String finWorkYmd = "";
				String retSchYmd = "";
				String note = "";
				String retContractNo = "";
				String target = "";
				for(String str : splited) {
					if ("".equalsIgnoreCase(str)) {
						continue;
					}
					String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim()+"");
					String[] keys = strDecrypt.split("#");
					sabun = keys[0];
					reqDate = keys[1];
					applSeq = keys[2];
					signFileSeq = keys[3];
					finWorkYmd = keys[4];
					retSchYmd = keys[5];
					note = keys[6];
					retContractNo = keys[7];
//					target += ",('" + ssnEnterCd + "','" + applSeq + "')";
				}

				String securityKey = request.getAttribute("securityKey")+"";
				mrdPath = "/hrm/retire/Retire_EB_PreView.mrd";
				//sabun = ",('${ssnEnterCd}','" + sheet1.GetCellValue(row,"applSeq") + "')";
				param = "/rp [" + ssnEnterCd + "]"
						+ " [" + sabun + "]"
						+ " [" + reqDate + "]"
						+ " [" + applSeq + "]"
						+ " [" + imageBaseUrl + "]"
						+ " [" +  signFileSeq +"]"
						+ " [" +  finWorkYmd +"]"
						+ " [" +  retSchYmd +"]"
						+ " [" +  note +"]"
						+ " [" +  retContractNo +"]"
				;
			}
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

	@RequestMapping(params="cmd=getRdRk", method = RequestMethod.POST )
	public ModelAndView getRdRk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		Map<String, Object> mapResult = new HashMap<>();

		try{

			String type = (String) paramMap.get("type");
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_RETIRE);
			if (encryptKey != null) {
				if(type.equals("1")) { // 비밀서약서
					String sabun = paramMap.get("sabun").toString().isEmpty() ? " " : paramMap.get("sabun").toString();
					String reqDate = paramMap.get("reqDate").toString().isEmpty() ? " " : paramMap.get("reqDate").toString();
					String secretSeq = paramMap.get("secretSeq").toString().isEmpty() ? " " : paramMap.get("secretSeq").toString();

					String rk = sabun + "#" +
							reqDate + "#" +
							secretSeq + "#";
					mapResult.put("rk", CryptoUtil.encrypt(encryptKey, rk));

				} else if(type.equals("2") || type.equals("3")) { // 사직원
					String sabun = paramMap.get("sabun").toString().isEmpty() ? " " : paramMap.get("sabun").toString();
					String reqDate = paramMap.get("reqDate").toString().isEmpty() ? " " : paramMap.get("reqDate").toString();
					String applSeq = paramMap.get("applSeq").toString().isEmpty() ? " " : paramMap.get("applSeq").toString();
					String signFileSeq1 = paramMap.get("signFileSeq1").toString().isEmpty() ? " " : paramMap.get("signFileSeq1").toString();
					String finWorkYmd = paramMap.get("finWorkYmd").toString().isEmpty() ? " " : paramMap.get("finWorkYmd").toString();
					String retSchYmd = paramMap.get("retSchYmd").toString().isEmpty() ? " " : paramMap.get("retSchYmd").toString();
					String note = paramMap.get("note").toString().isEmpty() ? " " : paramMap.get("note").toString();
					String retContractNo = paramMap.get("retContractNo").toString().isEmpty() ? " " : paramMap.get("retContractNo").toString();

					String rk = sabun + "#" +
							reqDate + "#" +
							applSeq + "#" +
							signFileSeq1 + "#" +
							finWorkYmd + "#" +
							retSchYmd + "#" +
							note + "#" +
							retContractNo + "#";
					mapResult.put("rk", CryptoUtil.encrypt(encryptKey, rk));
				}
			}

		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", mapResult);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
