package com.hr.org.organization.orgSchemeIBOrgSrch;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hr.common.rd.EncryptRdService;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;

/**
 * 화상조직도
 *
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/OrgSchemeIBOrgSrch.do", method=RequestMethod.POST )
public class OrgSchemeIBOrgSrchController{

	@Inject
	@Named("OrgSchemeIBOrgSrchService")
	private OrgSchemeIBOrgSrchService orgSchemeIBOrgSrchService;

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
	 * orgSchemeIBOrgSrch View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgSchemeIBOrgSrch", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgSchemeIBOrgSrch() throws Exception {
		return "org/organization/orgSchemeIBOrgSrch/orgSchemeIBOrgSrch";
	}

	/**
	 * orgSchemeIBOrgSrch View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgSchemeIBOrgSrch2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgSchemeIBOrgSrch2() throws Exception {
		return "org/organization/orgSchemeIBOrgSrch/orgSchemeIBOrgSrch2";
	}

	/**
	 * 화상조직도 리스트1 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgSchemeIBOrgSrchList", method = RequestMethod.POST )
	public ModelAndView getOrgSchemeIBOrgSrchList(HttpSession session,
			HttpServletRequest request,HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		paramMap.put("searchSdate", paramMap.get("searchSdate").toString().replaceAll("-", ""));
		paramMap.put("baseDate", paramMap.get("baseDate").toString().replaceAll("-", ""));

		Log.Debug("=>>>searchSdate:"+paramMap.get("searchSdate").toString());

		String searchType = paramMap.get("searchType").toString();
		if(searchType.indexOf("Org") >= 0) {
			searchType = "Org";
		}
		String Message = "";
		List<?> resultList = orgSchemeIBOrgSrchService.getOrgSchemeIBOrgSrchList(paramMap, searchType);
		Log.Debug("=>>>org/organization/orgSchemeIBOrgSrch/resultXml/orgSchemeIBOrgResult"+searchType);

		List<Object> orgList = new ArrayList<Object>();
		List<Object> memberList = new ArrayList<Object>();
		Map<String, Object> etcMember = new HashMap<String, Object>();

		if(resultList != null && resultList.size() > 0) {
			for(int i = 0; i < resultList.size(); i++) {
				if(resultList.get(i) instanceof Map) {
					@SuppressWarnings("unchecked")
					Map<String, Object> mp = (Map<String, Object>) resultList.get(i);
					// 히든 여부 체크
					if("0".equals(mp.get("Hidden").toString())) {
						// 공동조직장일 경우
						if("Y".equals(mp.get("dualemp"))) {
							// 공동조직장을 쿼리를 통해 조회
							Map<String, Object> paramMap2 = new HashMap<String, Object>();
							paramMap2.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
							paramMap2.put("searchSdate", paramMap.get("searchSdate").toString().replaceAll("-", ""));
							paramMap2.put("baseDate", paramMap.get("baseDate").toString().replaceAll("-", ""));
							paramMap2.put("searchOrgCd", mp.get("deptcd"));
							Map<?,?> dualMap = orgSchemeIBOrgSrchService.getOrgSchemeIBOrgSrchDualChief(paramMap2);
							if(dualMap != null && !dualMap.isEmpty()) {
								mp.put("deptnm2", dualMap.get("deptnm"));
								mp.put("deptcd2", dualMap.get("deptcd"));
								mp.put("empnm2", dualMap.get("empnm"));
								mp.put("position2", dualMap.get("position"));
								mp.put("title2", dualMap.get("title"));
								mp.put("empcd2", dualMap.get("empcd"));
								mp.put("inline2", dualMap.get("inline"));
								mp.put("hp2", dualMap.get("hp"));
								mp.put("email2", dualMap.get("email"));
							}
						}

						for(int j = i+1; j < resultList.size(); j++) {
							Map<?, ?> memberMp = (Map<?, ?>)resultList.get(j);
							if("1".equals(memberMp.get("Hidden").toString())) {
								if(mp.get("deptcd").equals(memberMp.get("deptcd"))) {
									mp.put("listcount", memberMp.get("listcount"));
									break;
								}
							}
						}
						// 멤버조회
						Map<String, Object> paramMap3 = new HashMap<String, Object>();
						paramMap3.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
						paramMap3.put("searchSdate", paramMap.get("searchSdate").toString().replaceAll("-", ""));
						paramMap3.put("baseDate", paramMap.get("baseDate").toString().replaceAll("-", ""));
						paramMap3.put("searchOrgCd", mp.get("deptcd"));
//						paramMap3.put("")
						List<?> temp = orgSchemeIBOrgSrchService.getOrgSchemeIBOrgSrchMemberList(paramMap3);
						mp.put("memberList", temp);
						orgList.add(mp);
					} else {
						memberList.add(mp);
					}
				}
			}
		}

		etcMember.put("orgList", orgList);
		etcMember.put("memberList", memberList);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", orgList);
		mv.addObject("Etc", etcMember);
		mv.addObject("Message", Message);
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
	public ModelAndView getEmpCardPrtRk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		Map<String, Object> mapResult = new HashMap<>();

		try{
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_EMPCARD);

			if (encryptKey != null) {
				String enterCd = String.valueOf(paramMap.get("enterCd"));
				String sabun = String.valueOf(paramMap.get("sabun"));
				mapResult.put("rk", CryptoUtil.encrypt(encryptKey, enterCd + "#" + sabun));
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

	@RequestMapping(params="cmd=getEmpCardEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEmpCardEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		//String enterCd = paramMap.get("enterCd");

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
			String ssnSabun = session.getAttribute("ssnSabun") + "";
			String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_EMPCARD);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.
			String empKey = CryptoUtil.decrypt(encryptKey, paramMap.get("rk")+"");
			String[] empKeys = empKey.split("#");

			String securityKey = request.getAttribute("securityKey")+"";

			String mrdPath = "/hrm/empcard/PersonInfoCardType2_HR.mrd";
			String param = "/rp [ ,('" + empKeys[0] + "','" + empKeys[1] +"') ]"
					+ " [" + imageBaseUrl + "] "
					+ " [Y]" // 마스킹 여부
					+ " [Y]" // 인사기본1
					+ " [Y]" // 인사기본2
					+ " [Y]" // 발령사항
					+ " [Y]" // 교육사항
					+ " [Y]" // 전체발령표시여부
					+ " [" + ssnEnterCd + "]"
					+ " ['" + ssnSabun + "']"
					+ " [" + ssnLocaleCd + "]"
					+ " ['," + empKeys[1] + "']"
					+ " [Y]" // 평가
					+ " [Y]" // 타부서발령여부
					+ " [Y]" // 연락처
					+ " [Y]" // 병역
					+ " [Y]" // 학력
					+ " [Y]" // 경력
					+ " [Y]" // 포상
					+ " [Y]" // 징계
					+ " [Y]" // 자격
					+ " [Y]" // 어학
					+ " [Y]" // 가족
					+ " [Y]" // 발령
					+ " [Y]" // 경력
					+ " [" + securityKey + "] "
					+ " /rv securityKey[" + securityKey + "] /rloadimageopt [1]"
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
		return null;
	}
}