package com.hr.hrd.code.moveHope;

import com.hr.common.language.Language;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
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
@RequestMapping(value="/MoveHope.do", method=RequestMethod.POST )
public class MoveHopeController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("MoveHopeService")
	private MoveHopeService moveHopeService;

	@RequestMapping(params="cmd=viewMoveHope", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMoveHope(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/code/moveHope/moveHope";
	}

	@RequestMapping(params="cmd=getMoveHopeList", method = RequestMethod.POST )
	public ModelAndView getMoveHopeList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(moveHopeService.getMoveHopeList(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=saveMoveHope", method = RequestMethod.POST )
	public ModelAndView saveMoveHope(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(), "");
		ParameterMapUtil.loadGlobalValues(session, convertMap);

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = moveHopeService.saveMoveHope(convertMap);

			if(resultCnt > 0){
//				message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1");
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			}
			else{
//				message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData");
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
