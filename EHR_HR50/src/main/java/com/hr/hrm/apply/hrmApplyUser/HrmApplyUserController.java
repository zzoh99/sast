package com.hr.hrm.apply.hrmApplyUser;

import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.StringUtil;
import com.hr.hrm.other.empInfoChangeMgr.EmpInfoChangeMgrService;
import com.hr.hrm.other.empPictureChangeMgr.EmpPictureChangeMgrService;
import com.hr.hrm.psnalInfoUpload.PsnalInfoUploadService;
import org.springframework.stereotype.Controller;
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
 * 임직원공통_인사신청 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/HrmApplyUser.do", method=RequestMethod.POST )
public class HrmApplyUserController {

	/**
	 * 임직원공통_인사신청 서비스
	 */
	@Inject
	@Named("HrmApplyUserService")
	private HrmApplyUserService hrmApplyUserService;

	/**
	 * 임직원공통_인사신청 서비스
	 */
	@Inject
	@Named("EmpPictureChangeMgrService")
	private EmpPictureChangeMgrService empPictureChangeMgrService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	@Inject
	@Named("EmpInfoChangeMgrService")
	private EmpInfoChangeMgrService empInfoChangeMgrService;

	@Inject
	@Named("PsnalInfoUploadService")
	private PsnalInfoUploadService psnalInfoUploadService;

	/**
	 * 임직원공통_인사신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHrmApplyTypeUser", method = {RequestMethod.POST, RequestMethod.GET } )
	public String viewHrmApplyTypeUser() throws Exception {
		return "hrm/apply/hrmApplyTypeUser/hrmApplyTypeUser";
	}

	/**
	 * 임직원공통_인사신청 리스트 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHrmApplyListUser",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHrmApplyListUser() throws Exception {
		return "hrm/apply/hrmApplyListUser/hrmApplyListUser";
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
	@RequestMapping(params="cmd=viewEmpInfoChangeReqLayer",method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewEmpInfoChangeReqLayer(HttpSession session, @RequestParam Map<String, Object> paramMap,
												 HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("hrm/apply/");
		mv.addObject("paramMap", paramMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 임직원공통_인사신청 인사신청 가능한 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHrmApplyTypeUserList", method = RequestMethod.POST )
	public ModelAndView getHrmApplyTypeUserList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		String surl = StringUtil.stringValueOf(paramMap.get("surl"));
		String skey = StringUtil.stringValueOf(session.getAttribute("ssnEncodedKey"));
		Map<String, Object> urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl(surl, skey);
		paramMap.put("mainMenuCd", urlParam.get("mainMenuCd"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		try {
			mv.addObject("map", hrmApplyUserService.getHrmApplyTypeUserList(paramMap));
			mv.addObject("msg", "");
		} catch(Exception e) {
			e.printStackTrace();
			Log.Error(" ** 임직원공통_인사신청서 리스트 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("map", new HashMap<>());
			mv.addObject("msg", "조회에 실패 하였습니다.");
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청내역 상세조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpPictureChangeMgrDupChk", method = RequestMethod.POST )
	public ModelAndView getEmpPictureChangeMgrDupChk(HttpSession session, HttpServletRequest request,
													 @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("searchSabun", session.getAttribute("ssnSabun"));

		Map<String, Object> map  = (Map<String, Object>) empPictureChangeMgrService.getEmpPictureChangeMgrDupChk(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		Log.DebugEnd();
		return mv;

	}

	/**
	 * 신청내역 상세조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpInfoChangeMgrDupChk", method = RequestMethod.POST )
	public ModelAndView getEmpInfoChangeMgrDupChk(HttpSession session, HttpServletRequest request,
												  @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = new HashMap<>();

		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("empTable", paramMap.get("empTable"));

		List<Map<String, Object>> list = (List<Map<String, Object>>) empInfoChangeMgrService.getEmpInfoColumnPkSeqList(convertMap);


		convertMap = new HashMap<>();
		StringBuilder columnCdQuery = new StringBuilder();

		if ( !list.isEmpty() ) {
			for ( Map<String, Object> map : list ) {
				String columnCd = StringUtil.stringValueOf(map.get("columnCd"));
				String camelColumnCd = StringUtil.getCamelize(StringUtil.stringValueOf(map.get("columnCd")));
				columnCdQuery.append(" AND B.").append(columnCd).append(" = '").append(paramMap.get(camelColumnCd)).append("' ");
			}
		}

		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("empTable", paramMap.get("empTable"));
		convertMap.put("empTableHist", StringUtil.upperCase(StringUtil.stringValueOf(paramMap.get("empTable")) + "_HIST"));
		convertMap.put("columnCdQuery", columnCdQuery);

		Map<String, Object> returnMap = (Map<String, Object>) empInfoChangeMgrService.getEmpInfoColumnUseList(convertMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", returnMap);
		Log.DebugEnd();
		return mv;

	}



	/**
	 * 변경신청 생성 콤보 박스 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpInfoChangeTypeList", method = RequestMethod.POST )
	public ModelAndView getEmpInfoChangeTypeList(HttpSession session, HttpServletRequest request,
												 @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = new HashMap<>();

		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("sabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<Map<String, Object>> list = (List<Map<String, Object>>) empInfoChangeMgrService.getEmpInfoChangeTypeList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		Log.DebugEnd();
		return mv;

	}

	/**
	 * 변경신청 생성 콤보 박스 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpInfoChangeTypeList2", method = RequestMethod.POST )
	public ModelAndView getEmpInfoChangeTypeList2(HttpSession session, HttpServletRequest request,
												 @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = new HashMap<>();

		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("sabun", 	session.getAttribute("ssnSabun"));

		List<Map<String, Object>> list = (List<Map<String, Object>>) empInfoChangeMgrService.getEmpInfoChangeTypeList2(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		Log.DebugEnd();
		return mv;

	}

	/**
	 * 인사정보 업로드 테이블 컬럼 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTableNameList", method = RequestMethod.POST )
	public ModelAndView getTableNameList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = psnalInfoUploadService.getTableNameList(paramMap);
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
	 * 인사정보 업로드 테이블 컬럼 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTableOtherList", method = RequestMethod.POST )
	public ModelAndView getTableOtherList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String surl = StringUtil.stringValueOf(paramMap.get("surl"));
		String skey = StringUtil.stringValueOf(session.getAttribute("ssnEncodedKey"));
		Map<String, Object> urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl(surl, skey);
		paramMap.put("mainMenuCd", urlParam.get("mainMenuCd"));

		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = psnalInfoUploadService.getTableOtherList(paramMap);
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


}
