package com.hr.common.groupware;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.json.XML;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
//import com.hr.ben.houseFund.houseFundAppDet.HouseFundAppDetService;
import com.hr.common.logger.Log;
import com.hr.common.notification.NotificationService;
import com.hr.common.util.StringUtil;
//import com.hr.common.util.eai.EaiSend;
import com.hr.hri.applyApproval.approvalMgrResult.ApprovalMgrResultService;

/**
 * Groupware Controller
 * 
 * @author 이름
 *
 */
@Controller
public class GroupwareController {
	/**
	 * Groupware 서비스
	 */
	@Inject
	@Named("GroupwareService")
	private GroupwareService groupwareService;

	/**
	 * Approval 서비스
	 */
	@Inject
	@Named("ApprovalMgrResultService")
	private ApprovalMgrResultService approvalMgrResultService;

	/**
	 * Approval 서비스
	 */
//	@Inject
//	@Named("HouseFundAppDetService")
//	private HouseFundAppDetService houseFundAppDetService;

	/**
	 * Notification 서비스
	 */
	@Inject
	@Named("NotificationService")
	private NotificationService notificationService;

	// 그룹웨어전자결재 송신 url
	@Value("${gw.appl.url}")
	private String GW_APPL_URL;

	/**
	 * Groupware 승인완료
	 *
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/GroupwareAppRcv.do", method=RequestMethod.POST )
	public ModelAndView groupwareAppRcv(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
		// comment 시작
		Log.DebugStart();

		// return 변수 선언
		Map<String, Object> resultMap = new HashMap<String, Object>();
		ModelAndView mv = new ModelAndView();
		String message = "";
		int resultCnt = -1;

		String ssnEnterCd = "";
		String ssnSabun = "7777777";

		// http://localhost:9080/GroupwareAppRcv.do?businessid=HLOANAPPLY&event=8
		/*-----------------------------------------------------------------*
		 * eventid
		 ( 2021.03.12 확인결과 아래는 레거시 코드고.. 그룹웨어에서는 8 : 결재완료 , 16 : 반려 )
		 * HCI0400010	신청
		 * HCI0400020	담당자확인
		 * HCI0400030	담당자반려
		 * HCI0400040	결제품의
		 * HCI0400050	결제완료
		 * HCI0400060	결제반려
		 *-----------------------------------------------------------------*/
		// 문서ID
		//String docid = StringUtil.stringValueOf(paramMap.get("docid"));
		// 사용자ID
		//String userid = StringUtil.stringValueOf(paramMap.get("userid"));
		// 결제일
		//String signdate = StringUtil.stringValueOf(paramMap.get("signdate"));
		// 시스템ID
		//String systemid = StringUtil.stringValueOf(paramMap.get("systemid"));
		// 업무ID
		String businessid = StringUtil.stringValueOf(paramMap.get("businessid")).toUpperCase();
		// 결제결과
		String eventid = StringUtil.stringValueOf(paramMap.get("event"));
		// xml
		String postedXmlData = "";

		try {
			Iterator<String> iterator = paramMap.keySet().iterator();
			while (iterator.hasNext()) {
				String key = (String) iterator.next();
				String value = StringUtil.stringValueOf(paramMap.get(key));
				Log.Debug("key[" + key + "] value[" + value + "]");
				if (value.contains("<?xml")) {
					postedXmlData = value;
					break;
				}
			}

			@SuppressWarnings("unchecked")
			Map<String, Object> postedMap = new ObjectMapper().readValue((XML.toJSONObject(postedXmlData)).toString(), Map.class);
			
			String agreeStatusCd = "10"; // 결재상태코드(R10050)
			String applStatusCd  = "31";  // 신청서상태코드(R10010)
			
		    /* 8 : 결재완료 , 16 : 반려 */
			//String agreeStatusCd = "8".equals(eventid) ? "20" : "16".equals(eventid) ? "30" : "10"; // 결재상태코드(R10050)
			//String applStatusCd = "8".equals(eventid) ? "99" : "16".equals(eventid) ? "33" : "31"; // 신청서상태코드(R10010)
			
			if ("8".equals(eventid)) {
				agreeStatusCd = "20";
				applStatusCd  = "99";
			}else if("16".equals(eventid)) {
				agreeStatusCd = "30";
				applStatusCd  = "33";
			}
			
			String applSeq = "";

			if ("HLOANAPPLY".equals(businessid)) {
				applSeq = String.valueOf(((Map<?, ?>) ((Map<?, ?>) postedMap.get("HLOANApply")).get("HWI_HLOANAPPLY")).get("NO_APPLY"));
			}

			Map<String, Object> convertMap = new HashMap<String, Object>();
			convertMap.put("applSeq", applSeq);
			convertMap.put("applStatusCd", applStatusCd);
			convertMap.put("agreeStatusCd", agreeStatusCd);
			convertMap.put("agreeGubun", "99".equals(applStatusCd) ? "1" : "0"); // 작업구분('0' ; 반려, '1':결재)

			// 결재상태변경
			Map<?, ?> map = groupwareService.getGroupwareAppRcvMap(convertMap);
			if(map != null) {
				ssnEnterCd = StringUtil.stringValueOf(map.get("enterCd"));
				convertMap.put("ssnEnterCd", ssnEnterCd);
				convertMap.put("ssnSabun", ssnSabun);
				convertMap.put("searchApplSeq", applSeq);
				convertMap.put("searchApplCd", StringUtil.stringValueOf(map.get("applCd")));
				convertMap.put("searchSabun", StringUtil.stringValueOf(map.get("applSabun")));
				convertMap.put("searchApplSabun", StringUtil.stringValueOf(map.get("applSabun")));
				convertMap.put("agreeSeq", StringUtil.stringValueOf(map.get("agreeSeq")));
				convertMap.put("pathSeq", StringUtil.stringValueOf(map.get("pathSeq")));
				convertMap.put("agreeTime", StringUtil.stringValueOf(map.get("agreeTime")));
				convertMap.put("agreeUserMemo", StringUtil.stringValueOf(map.get("agreeUserMemo")));
				convertMap.put("procExecYn", StringUtil.stringValueOf(map.get("procExecYn")));
				convertMap.put("afterProcStatusCd", StringUtil.stringValueOf(map.get("afterProcStatusCd")));

				resultCnt = approvalMgrResultService.saveApprovalMgrResult("", "", convertMap);
			}
			if (resultCnt > 0) {
				message = "저장되었습니다.";
				/* == 알림 push 시작 == */
//				@SuppressWarnings("rawtypes")
//				List pushList = approvalMgrResultService.getApprovalPushSabun(convertMap);
//
//				for (Object o : pushList) {
//					@SuppressWarnings("rawtypes")
//					Map pushMap = (Map) o;
//					if (pushMap != null) {
//						this.notificationService.notify(ssnEnterCd, (String) pushMap.get("sabun"), "notification", "결재 상태가 변경 되었습니다.");
//					}
//				}
				/* == 알림 push 끝 == */
			} else if (resultCnt == 0) {
				message = "저장된 내용이 없습니다.";
			}

			// 로그 저장
			saveGroupwareLog("GWAPP_RCV", ssnEnterCd, ssnSabun, "", paramMap.toString(), "Y");
		} catch (Exception e) {
			Log.Error(ExceptionUtils.getStackTrace(e));
			resultCnt = -1;
			message = "저장 실패하였습니다.";

			// 로그 저장
			saveGroupwareLog("GWAPP_RCV", ssnEnterCd, ssnSabun, ExceptionUtils.getStackTrace(e), paramMap.toString(), "N");
		}

		// return
		resultMap.put("Code", resultCnt > 0 ? "1" : "0");
		resultMap.put("Message", resultCnt > 0 ? "Success" : ("Failed" +" ["+ message +"]"));
		mv.addObject("Result", resultMap);
		mv.setViewName("common/groupware/groupwareAppRcv");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * Groupware 결재요청
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/GroupwareAppSnd.do", method=RequestMethod.POST )
	public ModelAndView groupwareAppSnd(HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
		// comment 시작
		Log.DebugStart();

		// return 변수 선언
		Map<String, Object> resultMap = new HashMap<String, Object>();
		ModelAndView mv = new ModelAndView();

		// session setting
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		/*------------------------------------------*
		 * userid       : hongildong
		 * systemid     : 열린마당
		 * businessid   : 지출결의서
		 * formversion  : 1.0
		 * title        : 휴가원
		 * legacyout    : 지출결의서 XML
		 * HLOANAPPLY     주택자금대여신청
		 * KFCCHR         인사급여 HRIFHoliday   휴가신청
		 * KFCCHR         인사급여 HRIFBizTravel 출장신청
		 *------------------------------------------*/
		/*------------------------------------------------*
		 * <option value='HRIFExpDecision' >지출결의서</option>
		 * <option value='HRIFTmpPayDecision' >가지급결의서</option>
		 * <option value='HRIFTmpPaySTDecision' >가지급정산결의서</option>
		 *------------------------------------------------*/

		String businessid = StringUtil.stringValueOf(paramMap.get("businessid"));
		String title = "";
		String legacyin = "";

		if ("HLoanApply".equals(businessid)) { // 대소문자주의
			Map<String, Object> map = getLegacyin_HLOANAPPLY(paramMap);
			
			title = (String)map.get("title");
			legacyin = (String)map.get("legacyin");
		}

		// return
		resultMap.put("url", GW_APPL_URL);
		resultMap.put("title", title);
		resultMap.put("userid", StringUtil.nvlValueOf(paramMap.get("userid"), String.valueOf(session.getAttribute("ssnSabun"))));
		resultMap.put("systemid", StringUtil.nvlValueOf(paramMap.get("systemid"), "KFCCHR"));
		resultMap.put("businessid", businessid);
		resultMap.put("legacyin", legacyin);

		// 로그 저장
		saveGroupwareLog("GWAPP_SND", StringUtil.stringValueOf(session.getAttribute("ssnEnterCd")), StringUtil.stringValueOf(session.getAttribute("ssnSabun")), "", resultMap.toString(), "Y");

		mv.addObject("map", resultMap);
		mv.setViewName("common/groupware/groupwareAppSnd");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private Map<String, Object> getLegacyin_HLOANAPPLY(Map<String, Object> paramMap) throws Exception {
		Map<String, Object> rtn = new HashMap<String, Object>();
		
		String title = "";
		StringBuffer xml = new StringBuffer();

		Map<?, ?> map_HLOANApply = groupwareService.getGroupwareAppSndMap_HLOANApply(paramMap);
		if (map_HLOANApply != null) {
			title = (String)map_HLOANApply.get("title");
			
			// 해당 사번,신청회차의 신청정보 읽어오기-------------
			Map<?, ?> map_HWI_HLOANAPPLY = groupwareService.getGroupwareAppSndMap_HWI_HLOANAPPLY(paramMap);

			// 채권정보 읽어오기
			Map<?, ?> map_HWI_HLOANCREDIT = groupwareService.getGroupwareAppSndMap_HWI_HLOANCREDIT(paramMap);

			// 기존대여현황
			Map<?, ?> map_HWI_HLOANMST = groupwareService.getGroupwareAppSndMap_HWI_HLOANMST(paramMap);

			// 인사정보 가져오기
			Map<?, ?> map_HHI_PERMST01 = groupwareService.getGroupwareAppSndMap_HHI_PERMST01(paramMap);

			xml.append("<HLOANApply xmlns='http://tempuri.org/HLOANApply.xsd'>");
			xml.append("\r\n").append("<HWI_HLOANAPPLY>" + mapToXml(map_HWI_HLOANAPPLY) + "</HWI_HLOANAPPLY>");
			xml.append("\r\n").append("<HWI_HLOANCREDIT>" + mapToXml(map_HWI_HLOANCREDIT) + "</HWI_HLOANCREDIT>");
			xml.append("\r\n").append("<HHI_PERMST01>" + mapToXml(map_HHI_PERMST01) + "</HHI_PERMST01>");

			if (map_HWI_HLOANMST != null) {
				xml.append("\r\n").append("<HWI_HLOANMST>" + mapToXml(map_HWI_HLOANMST) + "</HWI_HLOANMST>");
			}

			xml.append("\r\n").append("</HLOANApply>");
		}
		
		rtn.put("title", title);
		rtn.put("legacyin", xml.toString());
		
		return rtn;
	}

	/**
	 * @param map
	 * @return
	 */
	private String mapToXml(Map<?, ?> map) {
		String rtn = "";

		if (map == null) {
			return "";
		}

		List<String> arr = new ArrayList<String>();
		Iterator<?> iterator = (Iterator<?>) map.keySet().iterator();
		while (iterator.hasNext()) {
			String key = (String) iterator.next();
			String value = StringUtil.nvlValueOf(map.get(key), "").trim();

			String convertKey = StringUtil.convertToUnderScore(key).toUpperCase();
			@SuppressWarnings("deprecation")
			String convertValue = URLEncoder.encode(StringUtil.str2XML(value));
			convertValue = StringUtil.replaceAll(value, "\"", "'");

			arr.add("<" + convertKey + ">" + convertValue + "</" + convertKey + ">");
		}
		rtn = String.join("\r\n", arr);

		return rtn;
	}

	private void saveGroupwareLog(String bizCd, String enterCd, String sabun, String errLog, String contentLog, String successYn) throws Exception {
		// comment 시작
		Log.DebugStart();
		
		String encoding = "UTF-8";
		
		if (errLog.getBytes(encoding).length > 4000) {
			byte[] bt = new byte[4000];
			System.arraycopy(errLog.getBytes(encoding), 0, bt, 0, bt.length);
			errLog = new String(bt, encoding);
		}
		
		Map<String, Object> logMap = new HashMap<String, Object>();
		logMap.put("bizCd", bizCd);
		logMap.put("enterCd", enterCd);
		logMap.put("chkid", sabun);
		logMap.put("errLog", errLog);
		logMap.put("contentLog", contentLog);
		logMap.put("successYn", successYn);

		groupwareService.saveGroupwareLog(logMap);

		Log.DebugEnd();
	}
}
