package com.hr.hrd.selfRating.selfRatingApproval;

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
@RequestMapping(value="/SelfRatingApproval.do", method=RequestMethod.POST )
public class SelfRatingApprovalController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("SelfRatingApprovalService")
	private SelfRatingApprovalService selfRatingApprovalService;

	@RequestMapping(params="cmd=viewSelfRatingApproval", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfRatingApproval(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfRating/selfRatingApproval/selfRatingApproval";
	}

	@RequestMapping(params="cmd=getSelfRatingApprovalList", method = RequestMethod.POST )
	public ModelAndView getSelfRatingApprovalList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(selfRatingApprovalService.getSelfRatingApprovalList(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=saveSelfRatingApproval", method = RequestMethod.POST )
	public ModelAndView saveSelfRatingApproval(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(), "");
		ParameterMapUtil.loadGlobalValues(session, convertMap);

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfRatingApprovalService.saveSelfRatingApproval(convertMap);

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

	@RequestMapping(params="cmd=getSelfRatingApprovalDetailList1", method = RequestMethod.POST )
	public ModelAndView getSelfRatingApprovalgetDetailList1(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(selfRatingApprovalService.getSelfRatingApprovalDetailList1(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=saveSelfRatingApprovalDetail1", method = RequestMethod.POST )
	public ModelAndView saveSelfRatingApprovalDetail1(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(), "");
		ParameterMapUtil.loadGlobalValues(session, convertMap);

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfRatingApprovalService.saveSelfRatingApprovalDetail1(convertMap);

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

	@RequestMapping(params="cmd=getSelfRatingApprovalDetailList2", method = RequestMethod.POST )
	public ModelAndView getSelfRatingApprovalgetDetailList2(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(selfRatingApprovalService.getSelfRatingApprovalDetailList2(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=saveSelfRatingApprovalDetail2", method = RequestMethod.POST )
	public ModelAndView saveSelfRatingApprovalDetail2(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(), "");
		ParameterMapUtil.loadGlobalValues(session, convertMap);
		convertMap.put("techBizType", "T");

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfRatingApprovalService.saveSelfRatingApprovalDetail2(convertMap);

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

	@RequestMapping(params="cmd=getSelfRatingApprovalDetailList3", method = RequestMethod.POST )
	public ModelAndView getSelfRatingApprovalgetDetailList3(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(selfRatingApprovalService.getSelfRatingApprovalDetailList3(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=saveSelfRatingApprovalDetail3", method = RequestMethod.POST )
	public ModelAndView saveSelfRatingApprovalDetail3(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(), "");
		ParameterMapUtil.loadGlobalValues(session, convertMap);
		convertMap.put("techBizType", "B");

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfRatingApprovalService.saveSelfRatingApprovalDetail3(convertMap);

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
