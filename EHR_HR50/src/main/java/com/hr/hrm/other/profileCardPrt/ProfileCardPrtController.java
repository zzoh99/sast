package com.hr.hrm.other.profileCardPrt;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.logger.Log;
import com.hr.common.rd.EncryptRdService;
import com.hr.common.rd.RdRequest;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 프로필카드출력 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/ProfileCardPrt.do", method=RequestMethod.POST )
public class ProfileCardPrtController {
	/**
	 * 프로필카드출력 서비스
	 */
	@Inject
	@Named("ProfileCardPrtService")
	private ProfileCardPrtService profileCardPrtService;

	/*AuthTable */
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

    @Inject
    @Named("EncryptRdService")
    private EncryptRdService encryptRdService;

    @Autowired
    private SecurityMgrService securityMgrService;

    @Value("${rd.image.base.url}")
    private String imageBaseUrl;

	/**
	 * viewProfileCardPrt View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewProfileCardPrt", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewProfileCardPrt(HttpSession session) throws Exception {
		String ssnEnterCd = String.valueOf(session.getAttribute("ssnEnterCd"));
		String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_PRFCARD);

		session.setAttribute("rp",  CryptoUtil.encrypt(encryptKey, makeRp()));
		session.setAttribute("mp", CryptoUtil.encrypt(encryptKey, "/hrm/other/PersonProfile_20240311.mrd"));

		return "hrm/other/profileCardPrt/profileCardPrt";
	}

	/**
	 * 프로필카드출력 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getProfileCardPrtAuthList", method = RequestMethod.POST )
	public ModelAndView getProfileCardPrtAuthList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		/*AuthTable */
		paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnBaseDate", 	session.getAttribute("ssnBaseDate"));
		paramMap.put("authSqlID",		"TORG101");

		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		if(query != null) {
			Log.Debug("query.get=> "+ query.get("query"));
			paramMap.put("query",query.get("query"));
		}

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = profileCardPrtService.getProfileCardPrtAuthList(paramMap);
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
	 * getProfileCardPrtList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getProfileCardPrtList", method = RequestMethod.POST )
	public ModelAndView getProfileCardPrtList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		/*AuthTable */
		paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnBaseDate", 	session.getAttribute("ssnBaseDate"));
		paramMap.put("authSqlID",		"TORG101");

		
		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		if(query != null) {
			Log.Debug("query.get=> "+ query.get("query"));
			paramMap.put("query",query.get("query"));
		}
		
		//List<?> list  = new ArrayList<Object>();
		List<Map<String, Object>>  list = null;
		String Message = "";
	    String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";

		try{
		    
		    list =  (List<Map<String, Object>>) profileCardPrtService.getProfileCardPrtList(paramMap);
		    String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_PRFCARD);

            if (encryptKey != null) {
                for (Map<String, Object> map  : list) {
					String enterCd = String.valueOf(map.get("enterCd"));
					String sabun = String.valueOf(map.get("sabun"));
                    map.put("rk", CryptoUtil.encrypt(encryptKey, makeRk(enterCd, sabun)));
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
        Log.DebugStart();

		if (paramMap == null) {
			return null;
		}

		String ssnEnterCd = String.valueOf(session.getAttribute("ssnEnterCd"));
		String ssnSabun = String.valueOf(session.getAttribute("ssnSabun"));

		//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
		//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.
		String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_PRFCARD);
		ModelAndView mv = new ModelAndView();

		try {
			String printOption = (String) paramMap.get("printOption");

			if ("0".equals(printOption)) {
				// 출력옵션 3x1
				session.setAttribute("mp", CryptoUtil.encrypt(encryptKey, "/hrm/other/PersonProfile_20240311.mrd"));
			} else if ("1".equals(printOption)) {
				// 출력옵션 3x2
				session.setAttribute("mp", CryptoUtil.encrypt(encryptKey, "/hrm/other/PersonProfile_HR2.mrd"));
			} else if ("2".equals(printOption)) {
				// 출력옵션 3x3
				session.setAttribute("mp", CryptoUtil.encrypt(encryptKey, "/hrm/other/PersonProfile2.mrd"));
			}

			RdRequest rdRequest = RdRequest.of(paramMap, encryptKey, session);

			String param = "/rv baseUrl[" + imageBaseUrl + "]"
					+ " ssnEnterCd['" + ssnEnterCd + "']"
					+ " ssnSabun['" + ssnSabun + "']"
					+ rdRequest.makeRv();

			mv.setViewName("jsonView");
			mv.addObject("DATA", encryptRdService.encrypt(rdRequest.getMrdPath(), param));
			mv.addObject("Message", "");
		} catch (Exception e) {
			mv.addObject("Message", "암호화에 실패했습니다.");
		}

		Log.DebugEnd();
		return mv;
    }


	/**
	 * rk 생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpCardPrtRk", method = RequestMethod.POST )
	public ModelAndView getEmpCardPrtRk2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		Map<String, Object> mapResult = new HashMap<>();

		try{
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_PRFCARD);

			if (encryptKey != null) {
				String enterCd = String.valueOf(paramMap.get("enterCd"));
				String sabun = String.valueOf(paramMap.get("sabun"));
				//mapResult.put("mrdPath", CryptoUtil.encrypt(encryptKey, "/hrm/other/PersonProfile_20240311.mrd"));
				mapResult.put("rk", CryptoUtil.encrypt(encryptKey, makeRk(enterCd, sabun)));
				//mapResult.put("rp", CryptoUtil.encrypt(encryptKey, makeRp()));
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

	private String makeRk(String enterCd, String sabun) {
		String empKeys = "('" + enterCd + "','" + sabun + "')";
		String empSabuns = "'" + sabun + "'";
		String empSabuns2 = sabun;
		String cmpSort = "'" + enterCd + "_" + sabun + "',{seq}";
		String orderNo = "{seq}";

		return empKeys + "#" + empSabuns + "#" + cmpSort + "#" + orderNo + "#" + empSabuns2;
	}

	private String makeRp() {

		return "empKeys#empSabuns#cmpSort#orderNo#empSabuns2";
	}
}
