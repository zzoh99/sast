package com.hr.pap.evaluation.mltsrcEvlt;
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
 * 개인별 다면평가 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/MltsrcEvlt.do", method=RequestMethod.POST )
public class MltsrcEvltController {
	/**
	 * 개인별 다면평가 서비스
	 */
	@Inject
	@Named("MltsrcEvltService")
	private MltsrcEvltService mltsrcEvltService;

	/**
     * 개인별 다면평가 View(Main 화면 로드)
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewMltsrcEvlt", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView viewMltsrcEvlt(
        HttpSession session,  HttpServletRequest request,
        @RequestParam Map<String, Object> paramMap ) throws Exception {

        ModelAndView mv = new ModelAndView();
        mv.setViewName("pap/evaluation/mltsrcEvlt/mltsrcEvlt");
        mv.addObject("map", paramMap);

        return mv;
    }


	/**
	 * 개인별 다면평가 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMltsrcEvltMap", method = RequestMethod.POST )
	public ModelAndView getMltsrcEvltMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<?, ?> map = mltsrcEvltService.getMltsrcEvltMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 개인별 다면평가 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMltsrcEvlt", method = RequestMethod.POST )
	public ModelAndView saveMltsrcEvlt(
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
			resultCnt =mltsrcEvltService.saveMltsrcEvlt(convertMap);
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
     * 개인별 다면평가 저장 - (평가완료)
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=prcMltsrcEvlt", method = RequestMethod.POST )
    public ModelAndView prcMltsrcEvlt(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

        Map map  = mltsrcEvltService.prcMltsrcEvlt(paramMap);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        if(map != null) {
        	Log.Debug("obj : "+map);
        	Log.Debug("sqlcode : "+map.get("sqlcode"));
        	Log.Debug("sqlerrm : "+map.get("sqlerrm"));
        	
        	if (map.get("sqlcode") != null) {
        		resultMap.put("Code", map.get("sqlcode").toString());
        	}
        	if (map.get("sqlerrm") != null) {
        		resultMap.put("Message", map.get("sqlerrm").toString());
        	}
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);
        Log.DebugEnd();
        return mv;
    }
    
	/**
	 * 개인별 다면평가 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMltsrcEvltAppItemOpinion", method = RequestMethod.POST )
	public ModelAndView saveMltsrcEvltAppItemOpinion(
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
			resultCnt =mltsrcEvltService.saveMltsrcEvltAppItemOpinion(convertMap);
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
