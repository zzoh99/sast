package com.hr.pap.evaluation.mltsrcEvltSbj;
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
 * 다면평가 대상자 리스트 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/MltsrcEvltSbjt.do", method=RequestMethod.POST )
public class MltsrcEvltSbjtController {
	/**
	 * 다면평가 대상자 리스트 서비스
	 */
	@Inject
	@Named("MltsrcEvltSbjtService")
	private MltsrcEvltSbjtService mltsrcEvltSbjtService;


	/**
     * 다면평가 대상자 리스트 View(Main 화면 로드)
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewMltsrcEvltSbjt", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView viewMltsrcEvltSbjt(
        HttpSession session,  HttpServletRequest request,
        @RequestParam Map<String, Object> paramMap ) throws Exception {

        ModelAndView mv = new ModelAndView();
        mv.setViewName("pap/evaluation/mltsrcEvltSbjt/mltsrcEvltSbjt");
        mv.addObject("map", paramMap);

        return mv;
    }

	/**
	 * 다면평가 대상자 리스트 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMltsrcEvltSbjtList", method = RequestMethod.POST )
	public ModelAndView getMltsrcEvltSbjtList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = mltsrcEvltSbjtService.getMltsrcEvltSbjtList(paramMap);
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
	 * 다면평가 대상자 리스트 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMltsrcEvltSbjtMap", method = RequestMethod.POST )
	public ModelAndView getMltsrcEvltSbjtMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = mltsrcEvltSbjtService.getMltsrcEvltSbjtMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 다면평가 대상자 리스트 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMltsrcEvltSbjt", method = RequestMethod.POST )
	public ModelAndView saveMltsrcEvltSbjt(
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
			resultCnt =mltsrcEvltSbjtService.saveMltsrcEvltSbjt(convertMap);
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
