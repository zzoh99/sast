package com.hr.cpn.payApp.deptPartPayAppMgr;
import java.util.HashMap;
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
 * 수당지급신청 Controller
 *
 * @author YSH
 *
 */
@Controller
@RequestMapping(value="/DeptPartPayAppMgr.do", method=RequestMethod.POST )
public class DeptPartPayAppMgrController {

	/**
	 * 수당지급신청 서비스
	 */
	@Inject
	@Named("DeptPartPayAppMgrService")
	private DeptPartPayAppMgrService deptPartPayAppMgrService;
	
	/**
	 *  수당지급승인관리  갱신
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveDeptPartPayAppMgr", method = RequestMethod.POST )
	public ModelAndView deleteDeptPartPayAppEx(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = deptPartPayAppMgrService.saveDeptPartPayApp(convertMap);
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
