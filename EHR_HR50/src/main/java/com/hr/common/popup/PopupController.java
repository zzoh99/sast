package com.hr.common.popup;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.code.CommonCodeService;
import com.hr.common.util.ParamUtils;
import com.hr.tra.basis.eduInstiMgr.EduInstiMgrService;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.logger.Log;
import com.hr.common.util.PropertyResourceUtil;
import com.hr.common.util.StringUtil;
import com.hr.common.util.fileupload.impl.FileUploadConfig;
import com.hr.common.util.securePath.SecurePathUtil;
import java.nio.file.Path;

/**
 * 공통 팝업
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/Popup.do", method=RequestMethod.POST )
public class PopupController {

	@Inject
	@Named("PopupService")
	private PopupService popupService;

	/*AuthTable */
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 교육기관관리 서비스
	 */
	@Inject
	@Named("EduInstiMgrService")
	private EduInstiMgrService eduInstiMgrService;

	/**
	 * POPUP 호출
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=popup", method = RequestMethod.POST )
	public String comPopup() throws Exception {
		return "common/popup/popup";
	}
	
	/**
	 * 메인검색 Layer 제공
	 * 
	 * @param param
	 * @return
	 */
	@RequestMapping(params="cmd=viewMainSearchLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewMainSearchLayer(@RequestParam Map<String, Object> param) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/mainSearchLayer");
		mv.addObject("layerArgument", JSONObject.toJSONString(param));
		return mv;
	}

	/**
	 * 메인 검색모달 프로세스맵 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMainSearchProcessMap", method = RequestMethod.POST )
	public ModelAndView getMainSearchProcessMap(@RequestParam Map<String, Object> param) throws Exception {
		ModelAndView mv = new ModelAndView();
		List<?> list = null;
		
		try {
			list = popupService.getMainSearchProcessMap(param);
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
		}
		
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		return mv;
	}

	/**
	 * 사원 공통정보 조회 팝업[권한]
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=employeePopup", method = RequestMethod.POST )
	public ModelAndView viewEmployeePopup(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/employeePopup");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(params="cmd=viewEmployeeLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView employeeLayer(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/employeeLayer");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=employeePopupMain", method = RequestMethod.POST )
	public ModelAndView employeePopupMain(@RequestParam Map<String, Object> paramMap, HttpServletRequest request)
			throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/employeePopupMain");
		mv.addObject("paramMap", paramMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 사원 공통정보 조회 팝업[권한]
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=commonEmployeePopup", method = RequestMethod.POST )
	public ModelAndView viewCommonEmployeePopup(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/commonEmployeePopup");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(params="cmd=viewCommonEmployeeLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCommonEmployeeLayer() {
		return "common/popup/commonEmployeeLayer";
	}

	/**
	 * 사원 공통정보 조회 팝업[권한]
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=employeesPopup", method = RequestMethod.POST )
	public ModelAndView viewEmployeesPopup(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/employeesPopup");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 사원 공통정보 조회 팝업 [전사]====>사용안함 [삭제대상] 삭제시 employeeTopPopup.jsp도 삭제 할것  [by chul]
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=employeeTopPopup", method = RequestMethod.POST )
	public ModelAndView viewEmployeeTopPopup(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/employeeTopPopup");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();
		return mv;
	}



	/**
	 * 패스워드변경  POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwChPopup", method = RequestMethod.POST )
	public String pwChangePopup() throws Exception {
		return "common/popup/pwChPopup";
	}

	/**
	 * 패스워드확인  POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwConLayer", method = RequestMethod.POST )
	public String pwConLayer() throws Exception {
		return "common/popup/pwConLayer";
	}

	/**
	 * 메인메뉴프로그램관리 PrgMgr POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prgMgrPopup", method = RequestMethod.POST )
	public String prgMgrPopup() throws Exception {
		return "common/popup/prgMgrPopup";
	}
	
	 /**
     * 메인메뉴프로그램관리 PrgMgr POPUP Layer
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewPrgMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String prgMgrLayer() throws Exception {
        return "common/popup/prgMgrLayer";
    }


	/**
	 * 공통코드 POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=commonCodePopup", method = RequestMethod.POST )
	public String commonCodePopup() throws Exception {
		return "common/popup/commonCodePopup";
	}
	
	   /**
     * 공통코드 POPUP
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewCommonCodeLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView commonCodeLayer(HttpSession session, @RequestParam Map<String, Object> paramMap,
            HttpServletRequest request) throws Exception {
        
        ModelAndView mv = new ModelAndView();

        mv.setViewName("common/popup/commonCodeLayer");
        mv.addObject("paramMap",    paramMap);
        Log.DebugEnd();

        return mv;
    }

	/**
	 * 공통코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCommonCodePopupList", method = RequestMethod.POST )
	public ModelAndView getCommonCodePopupList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = popupService.getCommonCodePopupList(paramMap);
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
	 * 공통코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPeopleShowPopExList", method = RequestMethod.POST )
	public ModelAndView getAppPeopleShowPopExList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = popupService.getAppPeopleShowPopExList(paramMap);
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
	 * 메인메뉴프로그램관리 PrgMgr 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPrgMgrPopupList", method = RequestMethod.POST )
	public ModelAndView getPrgMgrPopupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		try{
			list = popupService.getPrgMgrPopupList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 메인메뉴프로그램관리 PwrSrchMgr POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchMgrPopup", method = RequestMethod.POST )
	public String pwrSrchMgrPopup() throws Exception {
		return "common/popup/pwrSrchMgrPopup";
	}
	@RequestMapping(params="cmd=viewPwrSrchMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String pwrSrchMgrLayer() throws Exception {
		return "common/popup/pwrSrchMgrLayer";
	}

	/**
	 * 메인메뉴프로그램관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchMgrPopupList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchMgrPopupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		try{
			list = popupService.getPwrSrchMgrPopupList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 메인메뉴프로그램관리 PwrSrchMgr POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=athGrpMuRegPopup", method = RequestMethod.POST )
	public String athGrpMuRegPopup() throws Exception {
		return "common/popup/athGrpMuRegPopup";
	}
	/**
	 * 메인메뉴프로그램관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAthGrpMuRegPopupList", method = RequestMethod.POST )
	public ModelAndView getAthGrpMuRegPopupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		try{
			list = popupService.getPwrSrchMgrPopupList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 부서 정보 팝업 OrgBasicPopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=orgBasicPopup", method = RequestMethod.POST )
	public String orgBasicPopup() throws Exception {
		return "common/popup/orgBasicPopup";
	}
	@RequestMapping(params="cmd=viewOrgBasicLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String orgBasicLayer() throws Exception {
		return "common/popup/orgBasicLayer";
	}
	/**
	 * 부서 정보 팝업(평가자) orgBasicPapCreatePopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=orgBasicPapCreatePopup", method = RequestMethod.POST )
	public String orgBasicPapCreatePopup() throws Exception {
		return "common/popup/orgBasicPapCreatePopup";
	}

	/**
	 * 부서 정보 팝업 OrgBasicGrpUserPopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=orgBasicGrpUserPopup", method = RequestMethod.POST )
	public String orgBasicGrpUserPopup() throws Exception {
		return "common/popup/orgBasicGrpUserPopup";
	}

	/**
	 * 교육이수학점기준
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=eduPointStdPopup", method = RequestMethod.POST )
	public String eduPointStdPopup() throws Exception {
		return "common/popup/eduPointStdPopup";
	}

	/**
	 * 부서 정보 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgBasicPopupList", method = RequestMethod.POST )
	public ModelAndView getOrgBasicPopupList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));

		List<?> result = popupService.getOrgBasicPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 부서 정보 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgBasicGrpUserPopupList", method = RequestMethod.POST )
	public ModelAndView getOrgBasicGrpUserPopupList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnGrpCd",  session.getAttribute("ssnGrpCd"));

		List<?> result = popupService.getOrgBasicGrpUserPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 부서 정보 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgBasicPopupList2", method = RequestMethod.POST )
	public ModelAndView getOrgBasicPopupList2(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));

		List<?> result = popupService.getOrgBasicPopupList2(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 부서 정보 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduPointPopupList", method = RequestMethod.POST )
	public ModelAndView getEduPointPopupList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));

		List<?> result = popupService.getEduPointPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}


	@RequestMapping(params="cmd=getAppPeopleShowPopList", method = RequestMethod.POST )
	public ModelAndView getAppPeopleShowPopList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));

		List<?> result = popupService.getAppPeopleShowPopList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 부서 정보(트리형태) 팝업 OrgTreePopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=orgTreePopup", method = RequestMethod.POST )
	public String orgTreePopup() throws Exception {
		return "common/popup/orgTreePopup";
	}
	
	@RequestMapping(params="cmd=viewOrgTreeLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgTreeLayer() throws Exception {
		return "common/popup/orgTreeLayer";
	}
	
	/**
	 * 부서 정보(트리형태) 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgTreePopupList", method = RequestMethod.POST )
	public ModelAndView getOrgTreePopupList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));

		List<?> result = popupService.getOrgTreePopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 조직도 명칭 코드형태 리스트(부서 정보(트리형태) 팝업에서 사용)
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgChartCodeList", method = RequestMethod.POST )
	public ModelAndView getOrgChartCodeList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));

		List<?> result = popupService.getOrgChartCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList",result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조직구분항목 조회 팝업 orgMappingItemPopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=orgMappingItemPopup", method = RequestMethod.POST )
	public String orgMappingItemPopup() throws Exception {
		return "common/popup/orgMappingItemPopup";
	}
	
	@RequestMapping(params="cmd=viewOrgMappingItemLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgMappingItemLayer() throws Exception {
		return "common/popup/orgMappingItemLayer";
	}
	
	/**
	 * 조직구분항목 조회 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgMappingItemPopupList", method = RequestMethod.POST )
	public ModelAndView getOrgMappingItemPopupList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
		List<?> result = popupService.getOrgMappingItemPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 직무코드 조회 팝업 jobPopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=jobPopup", method = RequestMethod.POST )
	public String jobPopup() throws Exception {
		return "common/popup/jobPopup";
	}
	/**
	 * 직무코드 조회 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJobPopupList", method = RequestMethod.POST )
	public ModelAndView getJobPopupList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
		List<?> result = popupService.getJobPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 직무분류표 조회 팝업 jobSchemePopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=jobSchemePopup", method = RequestMethod.POST )
	public String jobSchemePopup() throws Exception {
		return "common/popup/jobSchemePopup";
	}
	/**
     * 직무분류표 조회 팝업 jobSchemePopup Layer
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewJobSchemeLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView jobSchemeLayer(HttpSession session, @RequestParam Map<String, Object> paramMap,
            HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView();

        mv.setViewName("common/popup/jobSchemeLayer");
        mv.addObject("paramMap",    paramMap);
        Log.DebugEnd();

        return mv;
    }
	/**
	 * 직무분류표 조회 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJobSchemePopupList", method = RequestMethod.POST )
	public ModelAndView getJobSchemePopupList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
		List<?> result = popupService.getJobSchemePopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 역량코드 조회 Layer
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompetencyLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompetencyLayer() throws Exception {
		return "common/popup/competencyLayer";
	}
	
	/**
	 * 역량코드 조회 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompetencyPopupList", method = RequestMethod.POST )
	public ModelAndView getCompetencyPopupList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
		List<?> result = popupService.getCompetencyPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 역량분류표 조회 Layer
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=competencySchemeLayer", method = RequestMethod.POST )
	public String competencySchemeLayer() throws Exception {
		return "common/popup/competencySchemeLayer";
	}

	/**
	 * 역량분류표 조회 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompetencySchemePopupList", method = RequestMethod.POST )
	public ModelAndView getCompetencySchemePopupList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
		List<?> result = popupService.getCompetencySchemePopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 척도코드 조회 팝업 measureCdPopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMeasureCdPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String measureCdPopup() throws Exception {
		return "common/popup/measureCdPopup";
	}
	
	@RequestMapping(params="cmd=viewMeasureCdLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMeasureCdLayer() throws Exception {
		return "common/popup/measureCdLayer";
	}
	
	/**
	 * 척도코드 조회 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMeasureCdPopupList", method = RequestMethod.POST )
	public ModelAndView getMeasureCdPopupList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
		List<?> result = popupService.getMeasureCdPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 공통사무코드 조회 팝업 taskPopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=taskPopup", method = RequestMethod.POST )
	public String taskPopup() throws Exception {
		return "common/popup/taskPopup";
	}
	/**
	 * 공통사무코드 조회 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTaskPopupList", method = RequestMethod.POST )
	public ModelAndView getTaskPopupList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
		List<?> result = popupService.getTaskPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조직원정보 조회 팝업 orgEmpPopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=orgEmpPopup", method = RequestMethod.POST )
	public String orgEmpPopup() throws Exception {
		return "common/popup/orgEmpPopup";
	}
	/**
	 * 조직원정보 조회 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgEmpList", method = RequestMethod.POST )
	public ModelAndView getOrgEmpList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnSabun",		session.getAttribute("ssnSabun"));

		List<?> result = popupService.getOrgEmpList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);

		Log.DebugEnd();
		return mv;
	}
	/**
	 * 교육기관  POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduOrgLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduOrgLayer() throws Exception {
		return "common/popup/eduOrgLayer";
	}

	/**
	 * 교육과정  POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduCourseLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduCourseLayer() throws Exception {
		return "common/popup/eduCourseLayer";
	}

	/**
	 * 교육과정-회차  POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduCourseEvtLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduCourseEvtLayer() throws Exception {
		return "common/popup/eduCourseEvtLayer";
	}
	/**
	 * 교육분류  POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=eduMBranchPopup", method = RequestMethod.POST )
	public String eduMBranchPopup() throws Exception {
		return "common/popup/eduMBranchPopup";
	}

	/**
	 * 교육회차  POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=eduEventPopup", method = RequestMethod.POST )
	public String eduEventPopup() throws Exception {
		return "common/popup/eduEventPopup";
	}

	/**
	 * 교육회차 강사선택 팝업 관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduEventLecturerNmLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduEventLecturerNmLayer() throws Exception {
		return "common/popup/eduEventLecturerNmLayer";
	}

	/**
	 * 교육회차 강사내역 팝업 관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduEventLecturerLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduEventLecturerLayer() throws Exception {
		return "common/popup/eduEventLecturerLayer";
	}

	/**
	 * 사진등록  POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=phtRegPopup", method = RequestMethod.POST )
	public String phtRegPopup() throws Exception {
		return "common/popup/phtRegPopup";
	}

	/**
	 * 사진등록  Layer
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPhtRegLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String phtRegLayer() throws Exception {
		return "common/popup/phtRegLayer";
	}

	/**
	 * 사진등록 조회 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPhtRegPopupMap", method = RequestMethod.POST )
	public ModelAndView getPhtRegPopupMap(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = popupService.getPhtRegPopupMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		return mv;
	}

	/**
	 * 사진등록 채용사전 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePhtRegPopupMap", method = RequestMethod.POST )
	public ModelAndView savePhtRegPopupMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String message = "";
		int resultCnt = 0;

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		InputStream is = getClass().getResourceAsStream("/opti.properties");
		Properties props = new Properties();
		try {
			props.load(is);
		}catch (Exception e) {
			Log.Debug(e.toString());
			resultCnt = -1; message="파일복사에 실패하였습니다.\n\n" + e.toString();
		}

		if ( resultCnt != -1 ) {
			String inPath = props != null && props.getProperty("LOCAL_DIR") != null ? props.getProperty("LOCAL_DIR").trim():"";
			String basePath = PropertyResourceUtil.getHrfilePath(request);
			
			// SecurePathUtil을 사용하여 안전한 경로 생성
			Path outPath1 = SecurePathUtil.getSecurePath(basePath, session.getAttribute("ssnEnterCd").toString());
			Path picturePath = SecurePathUtil.getSecurePath(outPath1.toString(), "picture");
			Path thumPath = SecurePathUtil.getSecurePath(picturePath.toString(), "Thum");
			
			String inFile = (String)paramMap.get("imginfo");
			String imageType = inFile.substring(inFile.lastIndexOf(".")+1).toUpperCase();
			String outFile = SecurePathUtil.sanitizeFileName((String)paramMap.get("searchSabun") + "." + imageType);
			
			Log.Debug("inPath■■■■■>> " + inPath);
			Log.Debug("outPath■■■■■>> " + thumPath.toString());
			Log.Debug("inFile■■■■■>> " + inFile);
			Log.Debug("imageType■■■■■>> " + imageType);
			Log.Debug("outFile■■■■■>> " + outFile);
			
			InputStream in = null;
			OutputStream out = null;

			try{
				// 디렉토리 생성
				SecurePathUtil.createSecureDirectory(basePath, session.getAttribute("ssnEnterCd").toString());
				SecurePathUtil.createSecureDirectory(outPath1.toString(), "picture");
				SecurePathUtil.createSecureDirectory(picturePath.toString(), "Thum");

				Path finalPath = SecurePathUtil.getSecurePath(thumPath.toString(), outFile);
				
				in = new FileInputStream(inPath + inFile);
				out = new FileOutputStream(finalPath.toString());

				byte[] buf = new byte[1024];
				int len;
				while((len = in.read(buf)) > 0){
					out.write(buf,0,len);
				}
			}catch(Exception e){
				Log.Debug(e.toString());
				resultCnt = -1; message="파일복사에 실패하였습니다.\n\n" + e.toString();
			} finally {
				if (in != null) in.close();
				if (out != null) out.close();
			}

			//THRM911 데이타 저장
			if ( resultCnt != -1 ) {
				paramMap.put("imageType",    imageType);
				paramMap.put("fileName",     outFile);

				try{
					resultCnt = popupService.savePhtRegPopupMap(paramMap);
					if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
				}catch(Exception e){
					resultCnt = -1; message="저장에 실패하였습니다.";
				}
			}
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
	 * 서명등록  POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=signRegPopup", method = RequestMethod.POST )
	public String signRegPopup() throws Exception {
		return "common/popup/signRegPopup";
	}
	@RequestMapping(params="cmd=signPadPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String signPadPopup() throws Exception {
		return "common/popup/signPadPopup";
	}
	@RequestMapping(params="cmd=signComPopup", method = RequestMethod.POST )
	public String signComPopup() throws Exception {
		return "common/popup/signComPopup";
	}
	
	 /**
     * 서명등록  Layer
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewSignRegLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView signRegLayer(HttpSession session, @RequestParam Map<String, Object> paramMap,
            HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView();

        mv.setViewName("common/popup/signRegLayer");
        mv.addObject("paramMap",    paramMap);
        Log.DebugEnd();

        return mv;
    }

    @RequestMapping(params="cmd=viewSignPadLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String signPadLayer() throws Exception {
        return "common/popup/signPadLayer";
    }
    @RequestMapping(params="cmd=viewSignComLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String signComLayer() throws Exception {
        return "common/popup/signComLayer";
    }


	/**
	 * 채용내용  POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=recBasisInfoPopup", method = RequestMethod.POST )
	public ModelAndView recBasisInfoPopup(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		Map<?, ?> Info = popupService.getRecBasisInfo(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.addObject("resultInfo",Info);
		mv.setViewName("common/popup/recBasisInfoPopup");
		return mv;
	}


	/**
	 * 입사지원서 지원자정보  POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApplicantBasisPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String applicantBasisPopup(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		return "common/popup/applicantBasisPopup";
	}

	/**
	 * 개인정보 수정신청 popup view
	 *
	 * @param session
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpInfoChangeReqPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView empInfoChangeReqPopup(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		mv.setViewName("common/popup/empInfoChangeReqPopup");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 개인정보 수정신청 Layer view
	 *
	 * @param session
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpInfoChangeReqLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView empInfoChangeReqLayer(HttpSession session, @RequestParam Map<String, Object> paramMap,
											  HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/empInfoChangeReqLayer");
		mv.addObject("paramMap",    paramMap);
		Log.Debug(">>>>>>>>>>empInfoChangeReqLayer<<<<<<<<<<");
		Log.Debug(paramMap.toString());
		//mv.addObject("paramMap",  JSONObject.toJSONString(paramMap));
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 개인정보 수정신청 Layer view
	 *
	 * @param session
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpInfoChangeDetLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView empInfoChangeDetLayer(HttpSession session, @RequestParam Map<String, Object> paramMap,
											  HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/empInfoChangeDetLayer");
		mv.addObject("paramMap",    paramMap);
		Log.Debug(">>>>>>>>>>empInfoChangeDetLayer<<<<<<<<<<");
		Log.Debug(paramMap.toString());
		//mv.addObject("paramMap",  JSONObject.toJSONString(paramMap));
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 개인이미지 수정신청 popup view
	 *
	 * @param session
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpPictureChangeReqPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView empPictureChangeReqPopup(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		mv.setViewName("common/popup/empPictureChangeReqPopup");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 개인이미지 수정신청 popup Layer
	 *
	 * @param session
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpPictureChangeReqLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView empPictureChangeReqLayer(HttpSession session, @RequestParam Map<String, Object> paramMap,
												 HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		mv.setViewName("common/popup/empPictureChangeReqLayer");
		mv.addObject("paramMap",    paramMap);
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 개인이미지 수정신청 popup Layer
	 *
	 * @param session
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpCommonChangeReqLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView empCommonChangeReqLayer(HttpSession session, @RequestParam Map<String, Object> paramMap,
												 HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		mv.setViewName("common/popup/empCommonChangeReqLayer");
		mv.addObject("paramMap",    paramMap);
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 조직개편 시뮬레이션 POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewIborgPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView iborgPopup(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		Log.Debug("data == [" + paramMap + "]");
		ObjectMapper obj = new ObjectMapper();
		Log.Debug("paramMap = " + obj.writeValueAsString(paramMap));

		ModelAndView mv = new ModelAndView();

		mv.addObject("paramData", paramMap);
		mv.setViewName("common/popup/iborgPopup");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조직개편 버전관리 Layer
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgChangeVerMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView orgChangeVerMgrPopup(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		Log.Debug("data == [" + paramMap + "]");
		ObjectMapper obj = new ObjectMapper();
		Log.Debug("paramMap = " + obj.writeValueAsString(paramMap));

		ModelAndView mv = new ModelAndView();

		mv.addObject("paramData", paramMap);
		mv.setViewName("common/popup/orgChangeVerMgrLayer");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조직도복사 POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgCopyPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView orgCopyPopup(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		Log.Debug("data == [" + paramMap + "]");
		ObjectMapper obj = new ObjectMapper();
		Log.Debug("paramMap = " + obj.writeValueAsString(paramMap));

		ModelAndView mv = new ModelAndView();

		mv.addObject("paramData", paramMap);
		mv.setViewName("common/popup/orgCopyPopup");
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * timProcessBar POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimProcessBarLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewTimProcessBarLayer(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		Log.Debug("data == [" + paramMap + "]");
		ObjectMapper obj = new ObjectMapper();
		Log.Debug("paramMap = " + obj.writeValueAsString(paramMap));

		ModelAndView mv = new ModelAndView();

		mv.addObject("paramData", paramMap);
		mv.setViewName("common/popup/timProcessBarLayer");
		Log.DebugEnd();
		return mv;
	}

	
	/**
	 * layerPopup 조직 정보 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLayerOrgCodeList", method = RequestMethod.POST )
	public ModelAndView getLayerOrgCodeList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));

		List<?> result = popupService.getLayerOrgCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}

	

	/**
	 * layerPopup 직무 정보 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLayerJobCodeList", method = RequestMethod.POST )
	public ModelAndView getLayerJobCodeList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));

		List<?> result = popupService.getLayerJobCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA",result);
		Log.DebugEnd();
		return mv;
	}
	
	

	/**
	 * 사인 저장
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSignPadPopup", method = RequestMethod.POST )
	public ModelAndView saveSignPadPopup(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun",     session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
		String message = "";
		int resultCnt = 0;
				
		try {
			//파일저장 경로
			FileUploadConfig config = new FileUploadConfig("pht002");
			String basePath = (config.getDiskPath().length()==0 ) ? request.getSession().getServletContext().getRealPath("/")+"/hrfile" : config.getDiskPath();
			
			// SecurePathUtil을 사용하여 안전한 경로 생성
			Path targetPath = SecurePathUtil.getSecurePath(basePath, session.getAttribute("ssnEnterCd").toString());

			String tmp = config.getProperty(FileUploadConfig.POSTFIX_STORE_PATH);
			tmp = tmp == null ? "" : tmp;
			
			Path finalPath = SecurePathUtil.getSecurePath(targetPath.toString(), tmp);
			
			String sign = StringUtils.split(request.getParameter("sign"), ",")[1];
	
			String fileName = SecurePathUtil.sanitizeFileName("sign"+System.currentTimeMillis()+".jpg");
			
			// 디렉토리 생성
			SecurePathUtil.createSecureDirectory(basePath, session.getAttribute("ssnEnterCd").toString());
			SecurePathUtil.createSecureDirectory(targetPath.toString(), tmp);
			
			Path filePath = SecurePathUtil.getSecurePath(finalPath.toString(), fileName);
			File f = new File(filePath.toString());
	
			FileUtils.writeByteArrayToFile(f, Base64.decodeBase64(sign));

			paramMap.put("seqNo",     0);
			
			paramMap.put("fileSize",  f.length());
			paramMap.put("filePath",  tmp);
			paramMap.put("rFileNm",   fileName );
			paramMap.put("sFileNm",   fileName );
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			resultCnt = -1;
			message = "처리 중 오류가 발생했습니다. \\n담당자에게 문의바랍니다.";
			
		}
		Log.Debug("---------------------------");
		String fileSeq = "";
		try{
			fileSeq = popupService.saveSignPadPopup(paramMap);
			if( "-1".equals(fileSeq) ){
				resultCnt = -1;
			}
		}catch(Exception e){
			Log.Error(e.getLocalizedMessage());
			resultCnt = -2;
			message = "처리 중 오류가 발생했습니다. \\n담당자에게 문의바랍니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Code", resultCnt);
		mv.addObject("Message", message);
		mv.addObject("FileSeq", fileSeq);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 키워드검색 조회 팝업
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=keywordPopup", method = RequestMethod.POST )
	public ModelAndView viewKeywordPopup(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/keywordPopup");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=keywordLayer", method = RequestMethod.POST )
	public ModelAndView viewKeywordLayer(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/keywordLayer");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 키워드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getKeywordEmpList", method = RequestMethod.POST )
	public ModelAndView getKeywordEmpList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = popupService.getKeywordEmpList(paramMap);
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
	 * 직급 선택 팝업 jikgubBasicPopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=jikgubBasicPopup", method = RequestMethod.POST )
	public String jikgubBasicPopup() throws Exception {
		return "common/popup/jikgubBasicPopup";
	}
	@RequestMapping(params="cmd=viewJikgubBasicLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String jikgubBasicLayer() throws Exception {
		return "common/popup/jikgubBasicLayer";
	}
	

	/**
	 * 직급 정보 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJikgubBasicPopupList", method = RequestMethod.POST )
	public ModelAndView getJikgubBasicPopupList(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> result = popupService.getJikgubBasicPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	

	/**
	 * 직책 선택 팝업 jikchakBasicPopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=jikchakBasicPopup", method = RequestMethod.POST )
	public String jikchakBasicPopup() throws Exception {
		return "common/popup/jikchakBasicPopup";
	}
	@RequestMapping(params="cmd=viewJikchakBasicLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String jikchakBasicLayer() throws Exception {
		return "common/popup/jikchakBasicLayer";
	}

	/**
	 * 직책 정보 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJikchakBasicPopupList", method = RequestMethod.POST )
	public ModelAndView getJikchakBasicPopupList(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> result = popupService.getJikchakBasicPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 직위 선택 팝업 jikweeBasicPopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=jikweeBasicPopup", method = RequestMethod.POST )
	public String jikweeBasicPopup() throws Exception {
		return "common/popup/jikweeBasicPopup";
	}
	@RequestMapping(params="cmd=viewJikweeBasicLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String jikweeBasicLayer() throws Exception {
		return "common/popup/jikweeBasicLayer";
	}
	
	/**
	 * 직위 정보 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJikweeBasicPopupList", method = RequestMethod.POST )
	public ModelAndView getJikweeBasicPopupList(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> result = popupService.getJikweeBasicPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 설문명 선택 팝업 researchAppPopup POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=researchAppPopup", method = RequestMethod.POST )
	public String researchAppPopup() throws Exception {
		return "common/popup/researchAppPopup";
	}

	@RequestMapping(params="cmd=researchAppLayer", method = RequestMethod.POST )
	public String researchAppLayer() throws Exception {
		return "common/popup/researchAppLayer";
	}

	/**
	 * 발령품의번호관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppmtProcessNoMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView appmtProcessNoMgrPopup(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		mv.setViewName("common/popup/appmtProcessNoMgrPopup");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();

		return mv;
	}
	
	   /**
     * 발령품의번호관리 Layer View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewAppmtProcessNoMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView appmtProcessNoMgrLayer(HttpSession session, @RequestParam Map<String, Object> paramMap,
            HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView();

        mv.setViewName("common/popup/appmtProcessNoMgrLayer");
        mv.addObject("paramMap",    paramMap);
        Log.DebugEnd();

        return mv;
    }
	
	/**
	 * 사원 공통정보 조회 팝업[권한]
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=employeeAllPopup", method = RequestMethod.POST )
	public ModelAndView viewEmployeeAllPopup(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/employeeAllPopup");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 사원 공통정보 조회 팝업[권한]
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmployeeAllLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewEmployeeAllLayer(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/employeeAllLayer");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 발령 에러메시지 팝업
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppmtSaveErrorLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewAppmtSaveErrorLayer(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/appmtSaveErrorLayer");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();
		return mv;
	}
	
	

	/**
	 * [발령내역수정] 이력 팝업
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppmtModifyHstPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView appmtModifyHstPopup(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/appmtModifyHstPopup");
		mv.addObject("paramMap",	paramMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 범위설정 레이어
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=workCalcStdMgrRngLayer", method = RequestMethod.POST )
	public String workCalcStdMgrRngLayer() throws Exception{
		return "common/popup/workCalcStdMgrRngLayer";
	}

	/**
	 * 프로그램 검색 레이어
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prgSearchLayer", method = RequestMethod.POST )
	public String prgSearchLayer() throws Exception{
		return "common/popup/prgSearchLayer";
	}

	/**
	 * 권한그룹 Layer view
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAuthGrpLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String authGrpLayer() throws Exception {
		return "common/popup/authGrpLayer";
	}

	/**
	 * 권한그룹 정보 리스트
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAuthGrpPopupList", method = RequestMethod.POST )
	public ModelAndView getAuthGrpList(
			HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = popupService.getAuthGrpPopupList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();

		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		return mv;
	}

	/**
	 * 교육만족도항목관리_회차별 popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduServeryEventMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduServeryEventMgrLayer() throws Exception {
		return "tra/basis/eduServeryEventMgr/eduServeryEventMgrLayer";
	}

	/**
	 * 교육만족도항목관_회차별 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduServeryEventMgrList", method = RequestMethod.POST )
	public ModelAndView getEduServeryEventMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = popupService.getEduServeryEventMgrList(paramMap);
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
	 * 교육만족도항목관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduServeryItemMgrList", method = RequestMethod.POST )
	public ModelAndView getEduServeryItemMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = popupService.getEduServeryItemMgrList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 교육만족도항목관_회차별 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduServeryEventMgr", method = RequestMethod.POST )
	public ModelAndView saveEduServeryEventMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("EDU_SEQ",mp.get("eduSeq"));
			dupMap.put("EDU_EVENT_SEQ",mp.get("eduEventSeq"));
			dupMap.put("SURVEY_ITEM_CD",mp.get("surveyItemCd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TTRA150","ENTER_CD,EDU_SEQ,EDU_EVENT_SEQ,SURVEY_ITEM_CD","s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt =popupService.saveEduServeryEventMgr(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
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
	 * 교육만족도항목관리_회차별 과정명popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduServeryItemMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduServeryItemMgrLayer() throws Exception {
		return "tra/basis/eduServeryEventMgr/eduServeryItemMgrLayer";
	}


	/**
	 * 교육기관관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduInstiMgrList", method = RequestMethod.POST )
	public ModelAndView getEduInstiMgrList(HttpSession session, HttpServletRequest request,
										   @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = eduInstiMgrService.getEduInstiMgrList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 교육기관관리 Popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduInstiMgrDetLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduInstiMgrDetLayer() throws Exception {
		return "tra/basis/eduInstiMgr/eduInstiMgrDetLayer";
	}

	/**
	 * 교육기관관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduInstiMgrDet", method = RequestMethod.POST )
	public ModelAndView saveEduInstiMgrDet(HttpSession session, HttpServletRequest request,
										   @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		String companyNum = (String) paramMap.get("companyNum");

		List<Map<String, Object>> dupList = new ArrayList<Map<String, Object>>();

		Map<String, Object> dupMap = new HashMap<String, Object>();
		dupMap.put("ENTER_CD", session.getAttribute("ssnEnterCd"));
		dupMap.put("COMPANY_NUM", companyNum);
		dupList.add(dupMap);

		String message = "";
		int resultCnt = -1;
		try {
			int dupCnt = 0;

			if (!"".equals(companyNum)) {
				// 중복검사
				dupCnt = commonCodeService.getDupCnt("TTRA001", "ENTER_CD,COMPANY_NUM", "s,s", dupList);
			}
			if (dupCnt > 0) {
				resultCnt = -1;
				message = "중복되어 저장할 수 없습니다.";
			} else {
				resultCnt = eduInstiMgrService.saveEduInstiMgrDet(paramMap);
				if (resultCnt > 0) {
					message = "저장 되었습니다.";
				} else {
					message = "저장된 내용이 없습니다.";
				}
			}

		} catch (Exception e) {
			resultCnt = -1;
			message = "저장에 실패하였습니다.";
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

	@RequestMapping(params="cmd=viewJobMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewJobMgrLayer() throws Exception {
		return "org/job/jobMgr/jobMgrLayer";
	}


	@RequestMapping(params="cmd=viewLayoutLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewLayoutLayer(HttpSession session
			, @RequestParam Map<String, Object> params
			, HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();

		mv.setViewName("sys/layout/layer/layoutLayer");
		mv.addObject("params", params);
		return mv;
	}

}


