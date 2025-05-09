package com.hr.hrm.appmt.reEmpDataCopy;
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
 * 사번변경 Controller 
 * 
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/ReEmpDataCopy.do", method=RequestMethod.POST )
public class ReEmpDataCopyController {
	/**
	 * 사번변경 서비스
	 */
	@Inject
	@Named("ReEmpDataCopyService")
	private ReEmpDataCopyService reEmpDataCopyService;
	/**
	 * 사번변경 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewReEmpDataCopy", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReEmpDataCopy() throws Exception {
		return "hrm/appmt/reEmpDataCopy/reEmpDataCopy";
	}
	/**
	 * 사번변경 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSabunDupCheckPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReEmpDataCopy2() throws Exception {
		return "hrm/appmt/reEmpDataCopy/sabunDupCheckPopup";
	}
	/**
	 * 사번변경 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getReEmpDataCopyList", method = RequestMethod.POST )
	public ModelAndView getReEmpDataCopyList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = reEmpDataCopyService.getReEmpDataCopyList(paramMap);
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

	@RequestMapping(params="cmd=reEmpDataCopyEmpPopup", method = RequestMethod.POST )
	public ModelAndView viewreEmpDataCopyEmpPopup(@RequestParam Map<String, Object> paramMap, HttpServletRequest request)
			throws Exception {

		String uri = "hrm/appmt/reEmpDataCopy/reEmpDataCopyEmpPopup";
		ModelAndView mv = new ModelAndView();
		mv.setViewName(uri);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=viewReEmpDataCopyEmpLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewReEmpDataCopyEmpLayer(@RequestParam Map<String, Object> paramMap, HttpServletRequest request)
			throws Exception {

		String uri = "hrm/appmt/reEmpDataCopy/reEmpDataCopyEmpLayer";
		ModelAndView mv = new ModelAndView();
		mv.setViewName(uri);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 사번변경 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveReEmpDataCopy", method = RequestMethod.POST )
	public ModelAndView saveReEmpDataCopy(
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
			resultCnt =reEmpDataCopyService.saveReEmpDataCopy(convertMap);
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
     * 사번변경 프로시져
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=prcP_HRM_POST_REEMP_DATA_COPY", method = RequestMethod.POST )
    public ModelAndView prcP_BEN_MTH_CLUB_INFO_CRE(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

        Map map = reEmpDataCopyService.prcP_HRM_POST_REEMP_DATA_COPY(paramMap);

        Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("Code", "");

        if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
            resultMap.put("Code", map.get("sqlcode").toString());
            if (map.get("sqlerrm") != null) {
                resultMap.put("Message", map.get("sqlerrm").toString());
            } else {
                resultMap.put("Message", "사번변경 중 오류가 발생 했습니다.");
            }
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);

        Log.DebugEnd();
        return mv;
    }

}
