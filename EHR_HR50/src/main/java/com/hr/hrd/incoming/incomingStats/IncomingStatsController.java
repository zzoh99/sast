package com.hr.hrd.incoming.incomingStats;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;

/**
 * 후임자현황
 *
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/IncomingStats.do", method=RequestMethod.POST )
public class IncomingStatsController{

	@Inject
	@Named("IncomingStatsService")
	private IncomingStatsService incomingStatsService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	/**
	 * incomingStats View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewIncomingStats", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewIncomingStats(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		ModelAndView mv = new ModelAndView();
		Map<String, Object> urlParam = new HashMap<String, Object>();
		String surl = String.valueOf(paramMap.get("surl"));
		String skey = String.valueOf(session.getAttribute("ssnEncodedKey"));

		urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );

		mv.setViewName("hrd/incoming/incomingStats/incomingStats");
		mv.addObject("mainMenuCd", urlParam.get("mainMenuCd"));
		return mv;
	}


	/**
	 * incomingStats View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewIncomingStats2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewIncomingStats2() throws Exception {
		return "hrd/incoming/incomingStats/incomingStats2";
	}

	/**
	 * 후임자현황 리스트1 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getIncomingStatsList", method = RequestMethod.POST )
	public ModelAndView getIncomingStatsList(HttpSession session,
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
		List<?> resultList = incomingStatsService.getIncomingStatsList(paramMap, searchType);
		Log.Debug("=>>>hrd/incoming/incomingStats/resultXml/orgSchemeIBOrgResult"+searchType);

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
							Map<?,?> dualMap = incomingStatsService.getIncomingStatsDualChief(paramMap2);
							if(!dualMap.isEmpty()) {
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
							Map memberMp = (Map)resultList.get(j);
							if("1".equals(memberMp.get("Hidden").toString())) {
								if(mp.get("deptcd").equals(memberMp.get("deptcd"))) {
									mp.put("listcount", memberMp.get("listcount"));
									break;
								}
							}
						}

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

}