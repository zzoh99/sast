package com.hr.org.organization.corpImgReg;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 법인이미지 Controller
      다른 App를 가져온 것이므로, viewCorpImgReg 를 제외하고는 거의 빈 함수 들임.
   
 * @author 김한규
 *
 */
@Controller
@RequestMapping(value="/CorpImgReg.do", method=RequestMethod.POST )
public class CorpImgRegController {
	/**
	 * 법인이미지 서비스
	 */
	@Inject
	@Named("CorpImgRegService")
	private CorpImgRegService corpImgRegService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;


	/**
	 * 법인이미지 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCorpImgReg", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCorpImgReg() throws Exception {
		return "org/organization/corpImgReg/corpImgReg";
	}

	/**
	 * 법인이미지 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCorpImgRegList", method = RequestMethod.POST )
	public ModelAndView getCorpImgRegList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = corpImgRegService.getCorpImgRegList(paramMap);
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
	 * 법인이미지
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updateCorpImgReg", method = RequestMethod.POST )
	public ModelAndView updateCorpImgReg(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String getParamNames ="sNo,sStatus,pmtCd,pmtNm,baseYmd,targetNum,pmtNum,ordTypeCd,ordYmd,processNo,processYn";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = corpImgRegService.updateCorpImgReg(convertMap);
			if(resultCnt > 0){ message="수정 되었습니다."; } else{ message="수정된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="수정에 실패하였습니다.";
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
	 * 법인이미지(품의번호적용) 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcCorpImgReg", method = RequestMethod.POST )
	public ModelAndView prcCorpImgReg(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("pmtCd",paramMap.get("pmtCd"));
		paramMap.put("processNo",paramMap.get("processNo"));

		Map map  = corpImgRegService.prcCorpImgReg(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
		}

		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄
		// comment 종료
		Log.DebugEnd();
		return mv;
	}
}
