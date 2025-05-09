package com.hr.org.job.jobDivReportMgr;
import java.util.ArrayList;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
/**
 * 직무분장표 Controller
 *
 * @author jy
 *
 */
@Controller
@RequestMapping(value="/JobDivReportMgr.do", method=RequestMethod.POST )
public class JobDivReportMgrController extends ComController {
	/**
	 * 직무분장표 서비스
	 */
	@Inject
	@Named("JobDivReportMgrService")
	private JobDivReportMgrService jobDivReportMgrService;

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;

	/**
	 * 직무분장표 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewJobDivReportMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewJobDivReportMgr() throws Exception {
		return "org/job/jobDivReportMgr/jobDivReportMgr";
	}
	
	/**
	 * 조직도 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJobDivReportMgrList", method = RequestMethod.POST )
	public ModelAndView getJobDivReportMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String ssnEnterCd = (String) session.getAttribute("ssnEnterCd");
		paramMap.put("ssnEnterCd", ssnEnterCd);

		List<Map<String, Object>> list  = new ArrayList<>();
		String Message = "";
		try{
			list = (List<Map<String, Object>>) jobDivReportMgrService.getJobDivReportMgrList(paramMap);

			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_JOB);
			if (encryptKey != null) {
				for (Map<String, Object> map : list) {
					map.put("rk", CryptoUtil.encrypt(encryptKey, paramMap.get("searchBaseDate") + "#" + map.get("orgCd") + "#" + map.get("orgNm") + "#" + map.get("chiefName")
							+ "#" + imageBaseUrl + "#" + map.get("chiefSabun")));
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
	 * RD
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

		//String enterCd = paramMap.get("enterCd");

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String type = String.valueOf(paramMap.get("type"));

			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_JOB);
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

				String[] keys = new String[0];
				for(String str : splited) {
					String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim()+"");
					keys = strDecrypt.split("#");
				}

				String securityKey = request.getAttribute("securityKey")+"";

				mrdPath = "/hrm/job/OrgJob.mrd";
				param = "/rp [" + ssnEnterCd + "]"
						+ " [" + keys[0] + "]"
						+ " [" + keys[1] + "]"
						+ " [" + keys[2] + "]"
						+ " [" + keys[3] + "]"
						+ " [" + imageBaseUrl + "]"
						+ " [" + keys[4] +"]"
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
}
