package com.hr.hrm.empRcmd.aiEmpRcmd;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.SessionUtil;
import com.hr.hrm.other.empList.EmpListService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * AI인재추천 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/AiEmpRcmd.do", method=RequestMethod.POST )
public class AiEmpRcmdController extends ComController {

	/**
	 * AI인재추천 서비스
	 */
	@Inject
	@Named("AiEmpRcmdService")
	private AiEmpRcmdService aiEmpRcmdService;

	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	@Inject
	@Named("OtherService")
	private OtherService otherService;

	@Inject
	@Named("EmpListService")
	private EmpListService empListService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	/**
	 * viewEmpList View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAiEmpRcmd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpList(HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("viewAiEmpRcmd =====");
		Log.Debug(paramMap.toString());
		String skey = String.valueOf(SessionUtil.getRequestAttribute("ssnEncodedKey"));
		Map<String, Object> urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( paramMap.get("murl").toString(), skey);
		Map<String, Object> urlParam2 = (Map<String, Object>) securityMgrService.getDecryptUrl( paramMap.get("surl").toString(), skey);
		Log.Debug(urlParam.toString());
		Log.Debug(urlParam2.toString());
		return "hrm/empRcmd/aiEmpRcmd/aiEmpRcmd";
	}

	/**
	 * viewAiEmpRcmdLayer View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAiEmpRcmdLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAiEmpRcmdLayer() throws Exception {
		return "hrm/empRcmd/aiEmpRcmd/aiEmpRcmdLayer";
	}

	/**
	 * viewAiEmpRcmdPromptLayer View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAiEmpRcmdPromptLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAiEmpRcmdPromptLayer() throws Exception {
		return "hrm/empRcmd/aiEmpRcmd/aiEmpRcmdPromptLayer";
	}

	/**
	 * viewAiEmpRcmdSelLayer View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAiEmpRcmdSelLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAiEmpRcmdSelLayer() throws Exception {
		return "hrm/empRcmd/aiEmpRcmd/aiEmpRcmdSelLayer";
	}

	/**
	 * 인원명부 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpListList", method = RequestMethod.POST )
	public ModelAndView getEmpListList(
			HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {

		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		//권한 부여
		paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnBaseDate", 	session.getAttribute("ssnBaseDate"));

		String ssnLocaleCd = (String)session.getAttribute("ssnLocaleCd");
		paramMap.put("ssnLocaleCd", ssnLocaleCd);
		paramMap.put("viewSearchDate", paramMap.get("searchDate"));

		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		paramMap.put("query",query.get("query"));
		paramMap.put("searchViewNm", "인사_인사기본_기준일");
		String	viewQuery = otherService.getViewQuery(paramMap);
		paramMap.put("selectViewQuery", viewQuery);

		// column 정보 조회, List 형태로 param에 담기
		List<Map> columnInfo = (List<Map>) empListService.getEmpListTitleList(paramMap);
		List<String> colHeader = Arrays.asList(columnInfo.get(0).get("colHeader").toString().split("\\|"));
		List<String> colName = Arrays.asList(columnInfo.get(0).get("colName").toString().split("\\|"));

		paramMap.put("colHeader", colHeader);
		paramMap.put("colName", colName);

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try {
			Log.Debug(paramMap.get("empRcmdType").toString());
//			Log.Debug((paramMap.get("empRcmdType") == null) + ":empRcmdType1");
//			Log.Debug("".equals(paramMap.get("empRcmdType")) + ":empRcmdType2");
//			if(paramMap.get("empRcmdType") == null || "".equals(paramMap.get("empRcmdType"))){
//				list = empListService.getEmpListList(paramMap);
//			}else{
//				list = aiEmpRcmdService.getAiEmpRcmdEmpList(paramMap);
//			}
			list = aiEmpRcmdService.getAiEmpRcmdEmpList(paramMap);
		} catch(Exception e) {
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
	 * AI추천
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAiEmpRcmd", method = RequestMethod.POST )
	public ModelAndView getAiEmpRcmdMgrType(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

//		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		//getAiEmpRcmd
		String Message = "";
		try{
			aiEmpRcmdService.getAiEmpRcmd(request, paramMap);
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
//		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인재추천구분
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAiEmpRcmdGubunList", method = RequestMethod.POST )
	public ModelAndView getAiEmpRcmdGubunList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		String Message = "";
		List<?> list  = new ArrayList<Object>();
		try{
			list = aiEmpRcmdService.getAiEmpRcmdGubunList(request, paramMap);
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인재추천구분
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAiEmpRcmdPart", method = RequestMethod.POST )
	public ModelAndView getAiEmpRcmdPart(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		String Message = "";
		List<?> list  = new ArrayList<Object>();
		try{
			list = aiEmpRcmdService.getAiEmpRcmdPart(request, paramMap);
		}catch(Exception e){
			Log.Debug(e.getMessage());
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
	 * 프롬프트 내용
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAiEmpRcmdPrompt", method = RequestMethod.POST )
	public ModelAndView getAiEmpRcmdPrompt(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		String Message = "";
		String result = "";
		try{
			result = aiEmpRcmdService.getAiEmpRcmdPrompt(request, paramMap);
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인재추천 대상자 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAiEmpRcmd", method = RequestMethod.POST )
	public ModelAndView saveAiEmpRcmd(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =aiEmpRcmdService.saveAiEmpRcmd(paramMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * 인재추천 대상자 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteAiEmpRcmd", method = RequestMethod.POST )
	public ModelAndView deleteAiEmpRcmd(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =aiEmpRcmdService.deleteAiEmpRcmd(paramMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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

}
