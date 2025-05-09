package com.hr.common.employee;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;

import com.hr.common.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.rd.EncryptRdService;

/**
 * 임직원 검색
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/Employee.do", method=RequestMethod.POST )
public class EmployeeController {

	@Inject
	@Named("EmployeeService")
	private EmployeeService employeeService;

	@Inject
	@Named("OtherService")
	private OtherService otherService;

	/*AuthTable */
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	@Autowired
	private SecurityMgrService securityMgrService;


    @Inject
    @Named("EncryptRdService")
    private EncryptRdService encryptRdService;
    
    
    @Value("${rd.image.base.url}")
    private String imageBaseUrl;
	/**
	 * 자동검색 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=employeeList", method = RequestMethod.POST )
	public ModelAndView getEmployeeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		String ssnEnterCd = StringUtil.stringValueOf(session.getAttribute("ssnEnterCd"));
		String ssnLocaleCd = StringUtil.stringValueOf(session.getAttribute("ssnLocaleCd"));
		String ssnSabun = StringUtil.stringValueOf(session.getAttribute("ssnSabun"));

		paramMap.put("ssnEnterCd",		ssnEnterCd);
		paramMap.put("ssnLocaleCd",		ssnLocaleCd);
		paramMap.put("ssnSabun",		ssnSabun);

		String skey = StringUtil.stringValueOf(session.getAttribute("ssnEncodedKey"));
		String murl = StringUtil.stringValueOf(paramMap.get("s_SUBURL"));
		Map<String, Object> urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( murl, skey );
		
		String searchUseYn = StringUtil.stringValueOf(urlParam.get("searchUseYn"));
		if("1".equals(searchUseYn)) {
			paramMap.put("enableOnlySearchMyself", "Y");
		}

		paramMap.put("ssnSearchType",	paramMap.get("searchEmpType").toString().equals("T") ?   "A": session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		paramMap.get("searchEmpType").toString().equals("T") ?  "10": session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnBaseDate", 	session.getAttribute("ssnBaseDate"));
		paramMap.put("authSqlID",		"THRM151");
		
		paramMap.put("ssnAdminYn",		session.getAttribute("ssnAdminYn"));	
		paramMap.put("ssnEnterAllYn",	session.getAttribute("ssnEnterAllYn"));
		paramMap.put("ssnPreSrchYn",	session.getAttribute("ssnPreSrchYn"));
		paramMap.put("ssnRetSrchYn",	session.getAttribute("ssnRetSrchYn"));
		paramMap.put("ssnResSrchYn",	session.getAttribute("ssnResSrchYn"));

		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		if(query != null) {
			//Log.Debug("query.get=> "+ query.get("query"));
			paramMap.put("query",query.get("query"));
		}

		List<?> result = employeeService.employeeList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 메인페이지 데이터 조회
	 * 
	 * @param param
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMainEmployeeSearch", method = RequestMethod.POST )
	public ModelAndView getMainEmployeeSearch(@RequestParam Map<String, Object> param
											, HttpSession session) throws Exception {
		param.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		param.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
		param.put("ssnSabun",		session.getAttribute("ssnSabun"));
		
		List<?> list = employeeService.getMainEmployeeSearch(param);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		
		return mv;
	}
	
	
	
	/**
	 * 자동검색 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=commonEmployeeList", method = RequestMethod.POST )
	public ModelAndView commonEmployeeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",		session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun",		session.getAttribute("ssnSabun"));
		
		Log.Debug(session.getAttribute("ssnSearchType").toString());
		Log.Debug(session.getAttribute("ssnGrpCd").toString());
		
		Log.DebugStart();
		paramMap.put("ssnSearchType",	paramMap.get("searchEmpType").toString().equals("T") ?   "A": session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		paramMap.get("searchEmpType").toString().equals("T") ?  "10": session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnBaseDate", 	session.getAttribute("ssnBaseDate"));
		paramMap.put("authSqlID",		"THRM151");
		
		paramMap.put("ssnAdminYn",		session.getAttribute("ssnAdminYn"));	
		paramMap.put("ssnEnterAllYn",	session.getAttribute("ssnEnterAllYn"));
		paramMap.put("ssnPreSrchYn",	session.getAttribute("ssnPreSrchYn"));
		paramMap.put("ssnRetSrchYn",	session.getAttribute("ssnRetSrchYn"));
		paramMap.put("ssnResSrchYn",	session.getAttribute("ssnResSrchYn"));	
		
		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		//Log.Debug("query.get=> "+ query.get("query"));
		paramMap.put("query", query != null ? query.get("query"):null);
		
		List<?> result = employeeService.commonEmployeeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 사원검색 상세
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBaseEmployeeDetail", method = RequestMethod.POST )
	public ModelAndView baseEmployeeDetail(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnEnterCd",ssnEnterCd);
		
		paramMap.put("ssnAdminYn",		session.getAttribute("ssnAdminYn"));	
		paramMap.put("ssnEnterAllYn",	session.getAttribute("ssnEnterAllYn"));
		paramMap.put("ssnPreSrchYn",	session.getAttribute("ssnPreSrchYn"));
		paramMap.put("ssnRetSrchYn",	session.getAttribute("ssnRetSrchYn"));
		paramMap.put("ssnResSrchYn",	session.getAttribute("ssnResSrchYn"));	
		paramMap.put("ssnEncodedKey",     session.getAttribute("ssnEncodedKey"));
		
		// 서비스 호출
        Map<String, Object> map = (Map<String, Object>)  employeeService.baseEmployeeDetail(paramMap);
        if(map == null) {
        	map = new HashMap<String, Object>();
        }
        String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_DETAIL);
        if (encryptKey != null) {
            map.put("rk", CryptoUtil.encrypt(encryptKey, (String) map.get("sabun")));
        }

//		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
//		// return 형태 설정
		mv.setViewName("jsonView");
//		// return 형태로 넘어갈 값 Add

		//임직원공통 권한이면 결과값 제한함
		String ssnGrpCd = (String)session.getAttribute("ssnGrpCd");
		if( ssnGrpCd.equals("99") ){
			Map<String, String> map2 = new HashMap<String, String>();
        	map2.put("sabun", (String)map.get("sabun"));//empAlias
	        map2.put("name", (String)map.get("name"));
	        map2.put("empAlias", (String)map.get("empAlias"));
	        map2.put("orgNm", (String)map.get("orgNm"));
	        map2.put("jikgubNm", (String)map.get("jikgubNm"));
	        map2.put("jikchakNm", (String)map.get("jikchakNm"));
	        map2.put("officeTel", (String)map.get("officeTel"));
	        map2.put("handPhone", (String)map.get("handPhone"));
	        map2.put("faxNo", (String)map.get("faxNo"));
	        map2.put("mailId", (String)map.get("mailId"));
			mv.addObject("map",map2);
		}else{
			mv.addObject("map",map);
		}
//
		// comment 종료
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 임직원 Top  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=employeeTopList", method = RequestMethod.POST )
	public ModelAndView getEmployeeTopList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",     session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun",		session.getAttribute("ssnSabun"));

		/*AuthTable */
		paramMap.put("ssnSearchType",	"A");
		paramMap.put("ssnGrpCd",		"10");
		paramMap.put("ssnBaseDate", 	session.getAttribute("ssnBaseDate"));
		paramMap.put("authSqlID",		"THRM151");
		
		paramMap.put("ssnAdminYn",		session.getAttribute("ssnAdminYn"));	
		paramMap.put("ssnEnterAllYn",	session.getAttribute("ssnEnterAllYn"));
		paramMap.put("ssnPreSrchYn",	session.getAttribute("ssnPreSrchYn"));
		paramMap.put("ssnRetSrchYn",	session.getAttribute("ssnRetSrchYn"));
		paramMap.put("ssnResSrchYn",	session.getAttribute("ssnResSrchYn"));	

		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		if(query != null) {
			//Log.Debug("query.get=> "+ query.get("query"));
			paramMap.put("query",query.get("query"));
		}

		List<?> result = employeeService.employeeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * EmployeeHeader컬럼정보  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=employeeHeaderColInfo", method = RequestMethod.POST )
	public ModelAndView getEmployeeHeaderColInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("EmployeeController.employeeHeaderColInfo Start");

		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",     session.getAttribute("ssnLocaleCd"));
		
		paramMap.put("ssnAdminYn",		session.getAttribute("ssnAdminYn"));	
		paramMap.put("ssnEnterAllYn",	session.getAttribute("ssnEnterAllYn"));
		paramMap.put("ssnPreSrchYn",	session.getAttribute("ssnPreSrchYn"));
		paramMap.put("ssnRetSrchYn",	session.getAttribute("ssnRetSrchYn"));
		paramMap.put("ssnResSrchYn",	session.getAttribute("ssnResSrchYn"));	

		List<?> result = employeeService.getEmployeeHeaderColInfo(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.Debug("EmployeeController.getEmployeeHeaderColInfo End");
		return mv;
	}

	/**
	 * EmployeeHeader의  Hidden 정보  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=employeeHiddenInfo", method = RequestMethod.POST )
	public ModelAndView getEmployeeHiddenInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("EmployeeController.getEmployeeHiddenInfo Start");

		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",     session.getAttribute("ssnLocaleCd"));
		
		paramMap.put("ssnAdminYn",		session.getAttribute("ssnAdminYn"));	
		paramMap.put("ssnEnterAllYn",	session.getAttribute("ssnEnterAllYn"));
		paramMap.put("ssnPreSrchYn",	session.getAttribute("ssnPreSrchYn"));
		paramMap.put("ssnRetSrchYn",	session.getAttribute("ssnRetSrchYn"));
		paramMap.put("ssnResSrchYn",	session.getAttribute("ssnResSrchYn"));	

		List<?> result = employeeService.getEmployeeHiddenInfo(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.Debug("EmployeeController.getEmployeeHiddenInfo End");
		return mv;
	}

	/**
	 * EmployeeHeader의  컬럼 정보  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmployeeHeaderColDataMap", method = RequestMethod.POST )
	public ModelAndView getEmployeeHeaderColDataMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = employeeService.getEmployeeHeaderColDataMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * EmployeeHeader의 정보  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmployeeHeaderDataMap", method = RequestMethod.POST )
	public ModelAndView getEmployeeHeaderDataMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String ssnLocaleCd = (String)session.getAttribute("ssnLocaleCd");
		paramMap.put("ssnLocaleCd", ssnLocaleCd);
		paramMap.put("searchViewNm", "인사_인사기본_기준일");
		Map<?, ?> map = null;
		String Message = "";

		String viewQuery = otherService.getViewQuery(paramMap);
		paramMap.put("selectViewQuery", viewQuery);

		try{
			Map<?, ?> hmap  = employeeService.getEmployeeHeaderColDataMap(paramMap);
			if (hmap != null) {
				paramMap.put("selectColumn", hmap.get("selectColumn"));
			} else {
				paramMap.put("selectColumn", null);
			}
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		try{
			map = employeeService.getEmployeeHeaderDataMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}


	/**
	 * 전직원 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmployeeAllList", method = RequestMethod.POST )
	public ModelAndView getEmployeeAllList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",     session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun",		session.getAttribute("ssnSabun"));

		List<?> result = employeeService.getEmployeeAllList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
}