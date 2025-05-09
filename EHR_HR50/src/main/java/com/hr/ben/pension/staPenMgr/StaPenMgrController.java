package com.hr.ben.pension.staPenMgr;
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
import com.hr.common.code.CommonCodeService;

/**
 * 국민연금기본사항 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/StaPenMgr.do", method=RequestMethod.POST )
public class StaPenMgrController {

	/**
	 * 국민연금기본사항 서비스
	 */
	@Inject
	@Named("StaPenMgrService")
	private StaPenMgrService staPenMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 국민연금기본사항 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStaPenMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStaPenMgr() throws Exception {
		return "ben/pension/staPenMgr/staPenMgr";
	}

	/**
	 * 국민연금기본사항 기본사항TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStaPenMgrBasic",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStaPenMgrBasic() throws Exception {
		return "ben/pension/staPenMgr/staPenMgrBasic";
	}

	/**
	 * 국민연금기본사항 변동내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStaPenMgrChange",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStaPenMgrChange() throws Exception {
		return "ben/pension/staPenMgr/staPenMgrChange";
	}

	/**
	 * 국민연금기본사항 기본사항/변동내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStaPenMgrBasicChange",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStaPenMgrBasicChange() throws Exception {
		return "ben/pension/staPenMgr/staPenMgrBasic";
	}

	/**
	 * 국민연금기본사항 불입내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStaPenMgrPayment",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStaPenMgrPayment() throws Exception {
		return "ben/pension/staPenMgr/staPenMgrPayment";
	}

	/**
	 * 국민연금기본사항 기본사항TAB 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStaPenMgrBasicMap", method = RequestMethod.POST )
	public ModelAndView getStaPenMgrBasicMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = staPenMgrService.getStaPenMgrBasicMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 국민연금기본사항 변동내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStaPenMgrChangeList", method = RequestMethod.POST )
	public ModelAndView getStaPenMgrChangeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = staPenMgrService.getStaPenMgrChangeList(paramMap);
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
	 * 국민연금기본사항 불입내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStaPenMgrPaymentList", method = RequestMethod.POST )
	public ModelAndView getStaPenMgrPaymentList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = staPenMgrService.getStaPenMgrPaymentList(paramMap);
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
	 * 국민연금기본사항 기본사항TAB 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveStaPenMgrBasic", method = RequestMethod.POST )
	public ModelAndView saveStaPenMgrBasic(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = staPenMgrService.saveStaPenMgrBasic(paramMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 국민연금기본사항 변동내역TAB 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveStaPenMgrChange", method = RequestMethod.POST )
	public ModelAndView saveStaPenMgrChange(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = staPenMgrService.saveStaPenMgrChange(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 국민연금기본사항 불입내역TAB 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveStaPenMgrPayment", method = RequestMethod.POST )
	public ModelAndView saveStaPenMgrPayment(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("SABUN",convertMap.get("ssnSabun"));
			dupMap.put("PAY_ACTION_CD",mp.get("payActionCd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TBEN105","ENTER_CD,SABUN,PAY_ACTION_CD","s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = staPenMgrService.saveStaPenMgrPayment(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
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
	 * 본인부담금 가져오기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getF_BEN_NP_SELF_MON", method = RequestMethod.POST )
	public ModelAndView getF_BEN_NP_SELF_MON(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;
		try{
			map = staPenMgrService.getF_BEN_NP_SELF_MON(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 본인부담금 가져오기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStaPenMgrF_BEN_NP_SELF_MON", method = RequestMethod.POST )
	public ModelAndView getStaPenMgrF_BEN_NP_SELF_MON(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;
		try{
			map = staPenMgrService.getStaPenMgrF_BEN_NP_SELF_MON(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}