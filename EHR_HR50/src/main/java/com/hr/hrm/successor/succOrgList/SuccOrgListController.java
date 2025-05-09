package com.hr.hrm.successor.succOrgList;

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

/**
 * 화상조직도
 *
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/SuccOrgList.do", method=RequestMethod.POST )
public class SuccOrgListController{

	@Inject
	@Named("SuccOrgListService")
	private SuccOrgListService succOrgListService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * succOrgList View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSuccOrgList", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSuccOrgList() throws Exception {
		return "hrm/successor/succOrgList/succOrgList";
	}

	/**
	 * succOrgList View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSuccOrgList2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSuccOrgList2() throws Exception {
		return "hrm/successor/succOrgList/succOrgList2";
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
	@RequestMapping(params="cmd=getSuccOrgList", method = RequestMethod.POST )
	public ModelAndView getSuccOrgListList(HttpSession session,
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
		List<?> resultList = succOrgListService.getSuccOrgList(paramMap, searchType);
		Log.Debug("=>>>hrm/successor/succOrgList/"+searchType);

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