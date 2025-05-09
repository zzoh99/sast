package com.hr.pap.evaluation.appSelfReportReg;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 자기신고서등록 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/AppSelfReportReg.do", method=RequestMethod.POST )
public class AppSelfReportRegController {
	/**
	 * 자기신고서등록 서비스
	 */
	@Inject
	@Named("AppSelfReportRegService")
	private AppSelfReportRegService appSelfReportRegService;
	/**
	 * 자기신고서등록 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppSelfReportReg", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppSelfReportReg() throws Exception {
		return "pap/evaluation/appSelfReportReg/appSelfReportReg";
	}
	/**
	 * 자기신고서등록 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppSelfReportReg2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppSelfReportReg2() throws Exception {
		return "appSelfReportReg/appSelfReportReg";
	}
	/**
	 * 자기신고서등록 -직무기술 - 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppSelfReportRegList", method = RequestMethod.POST )
	public ModelAndView getAppSelfReportRegList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = appSelfReportRegService.getAppSelfReportRegList(paramMap);
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
	 * 자기신고서등록 -전환희망- 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppSelfReportRegList2", method = RequestMethod.POST )
	public ModelAndView getAppSelfReportRegList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = appSelfReportRegService.getAppSelfReportRegList2(paramMap);
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
	 * 자기신고서등록 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppSelfReportRegMap", method = RequestMethod.POST )
	public ModelAndView getAppSelfReportRegMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = appSelfReportRegService.getAppSelfReportRegMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 자기신고서등록 -직무기술-저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppSelfReportReg", method = RequestMethod.POST )
	public ModelAndView saveAppSelfReportReg(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();


		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String itmp = paramMap.get("itemCd").toString();


		List  jobDescriptionList		= new ArrayList();


		String [] itemCdArray = request.getParameterValues("itemCd");


		for(int i=0;i< itemCdArray.length;i++){
			Map   jobDescriptionMap 		= new HashMap();
			jobDescriptionMap.put("itemCd", itemCdArray[i]);
			String tmpvalueCd = request.getParameter("valueCd"+itemCdArray[i]);
			if(tmpvalueCd == null){
				jobDescriptionMap.put("valueCd","");
			}else{
				jobDescriptionMap.put("valueCd",tmpvalueCd);
			}
			jobDescriptionList.add(jobDescriptionMap);
		}

		paramMap.put("mergeRows",jobDescriptionList);




		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =appSelfReportRegService.saveAppSelfReportReg(paramMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 자기신고서등록 -전환희망- 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppSelfReportReg2", method = RequestMethod.POST )
	public ModelAndView saveAppSelfReportReg2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =appSelfReportRegService.saveAppSelfReportReg2(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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

}
