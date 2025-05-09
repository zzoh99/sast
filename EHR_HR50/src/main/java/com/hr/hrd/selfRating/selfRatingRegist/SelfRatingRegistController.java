package com.hr.hrd.selfRating.selfRatingRegist;

import com.hr.common.language.Language;
import com.hr.common.language.LanguageUtil;
import com.hr.common.util.ListUtil;
import com.hr.common.util.ModelAndViewUtil;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.ParameterMapUtil;
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

@Controller
@RequestMapping(value="/SelfRatingRegist.do", method=RequestMethod.POST )
public class SelfRatingRegistController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("SelfRatingRegistService")
	private SelfRatingRegistService selfRatingRegistService;

	@RequestMapping(params="cmd=viewSelfRatingRegist", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfRatingRegist(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfRating/selfRatingRegist/selfRatingRegist";
	}

	@RequestMapping(params="cmd=getSelfRatingRegistList", method = RequestMethod.POST )
	public ModelAndView getSelfRatingRegistList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(selfRatingRegistService.getSelfRatingRegistList(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=saveSelfRatingRegist", method = RequestMethod.POST )
	public ModelAndView saveSelfRatingRegist(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(), "");
		ParameterMapUtil.loadGlobalValues(session, convertMap);

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfRatingRegistService.saveSelfRatingRegist(convertMap);

			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			}
			else{
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		return ModelAndViewUtil.getJsonResultView(resultMap);
	}

	@RequestMapping(params="cmd=getSelfRatingRegistDetailList1", method = RequestMethod.POST )
	public ModelAndView getSelfRatingRegistgetDetailList1(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(selfRatingRegistService.getSelfRatingRegistDetailList1(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=saveSelfRatingRegistDetail1", method = RequestMethod.POST )
	public ModelAndView saveSelfRatingRegistDetail1(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(), "");
		ParameterMapUtil.loadGlobalValues(session, convertMap);

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfRatingRegistService.saveSelfRatingRegistDetail1(convertMap);

			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			}
			else{
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		return ModelAndViewUtil.getJsonResultView(resultMap);
	}

	@RequestMapping(params="cmd=getSelfRatingRegistDetailList2", method = RequestMethod.POST )
	public ModelAndView getSelfRatingRegistgetDetailList2(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(selfRatingRegistService.getSelfRatingRegistDetailList2(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=saveSelfRatingRegistDetail2", method = RequestMethod.POST )
	public ModelAndView saveSelfRatingRegistDetail2(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(), "");
		ParameterMapUtil.loadGlobalValues(session, convertMap);
		convertMap.put("techBizType", "T");

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfRatingRegistService.saveSelfRatingRegistDetail2(convertMap);

			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			}
			else{
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		return ModelAndViewUtil.getJsonResultView(resultMap);
	}

	@RequestMapping(params="cmd=getSelfRatingRegistDetailList3", method = RequestMethod.POST )
	public ModelAndView getSelfRatingRegistgetDetailList3(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(selfRatingRegistService.getSelfRatingRegistDetailList3(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=saveSelfRatingRegistDetail3", method = RequestMethod.POST )
	public ModelAndView saveSelfRatingRegistDetail3(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(), "");
		ParameterMapUtil.loadGlobalValues(session, convertMap);
		convertMap.put("techBizType", "B");

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfRatingRegistService.saveSelfRatingRegistDetail3(convertMap);

			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			}
			else{
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		return ModelAndViewUtil.getJsonResultView(resultMap);
	}
}
