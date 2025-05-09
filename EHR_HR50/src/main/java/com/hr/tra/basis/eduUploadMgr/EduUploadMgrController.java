package com.hr.tra.basis.eduUploadMgr;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 교육과정업로드 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/EduUploadMgr.do", method=RequestMethod.POST )
public class EduUploadMgrController extends ComController {
	/**
	 * 교육과정업로드 서비스
	 */
	@Inject
	@Named("EduUploadMgrService")
	private EduUploadMgrService eduUploadMgrService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 교육과정업로드 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduUploadMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduUploadMgr() throws Exception {
		return "tra/basis/eduUploadMgr/eduUploadMgr";
	}
	
	/**
	 * 교육과정업로드 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduUploadMgrList", method = RequestMethod.POST )
	public ModelAndView getEduUploadMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 교육과정업로드 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduUploadMgr", method = RequestMethod.POST )
	public ModelAndView saveEduUploadMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = eduUploadMgrService.saveEduUploadMgr(convertMap);
			if(resultCnt > 0){
				message="저장 되었습니다.";
			} else if (resultCnt == -99) {
				resultCnt = -1;
				message="동일한 교육기간["+convertMap.get("eduSYmd")+"~"+convertMap.get("eduSYmd")+"]이 존재하여 저장 할 수 없습니다.";
			} else{
				message="저장된 내용이 없습니다.";
			}
		}catch(HrException he){
			resultCnt = -1; message= he.getMessage();
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.\n("+e.getMessage()+")";
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
