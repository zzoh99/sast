package com.hr.ben.benefitBasis.welfarePayDataMgr;
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
 * 복리후생마감관리 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/WelfarePayDataMgr.do", method=RequestMethod.POST )
public class WelfarePayDataMgrController {

	/**
	 * 복리후생마감관리 서비스
	 */
	@Inject
	@Named("WelfarePayDataMgrService")
	private WelfarePayDataMgrService welfarePayDataMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	
	/**
	 * 복리후생마감관리 화면 View
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWelfarePayDataMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWelfarePayDataMgr(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug();
		return "ben/benefitBasis/welfarePayDataMgr/welfarePayDataMgr";
	}
	
	/**
	 * 복리후생마감관리 화면 View
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWelfarePayDataMgr2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWelfarePayDataMgr2(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug();
		return "ben/benefitBasis/welfarePayDataMgr2/welfarePayDataMgr2";
	}
	
	
	/**
	 * getWelfarePayDataMgrList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWelfarePayDataMgrList", method = RequestMethod.POST )
	public ModelAndView getWelfarePayDataMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = welfarePayDataMgrService.getWelfarePayDataMgrList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * getWelfarePayDataMgr2List 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWelfarePayDataMgr2List", method = RequestMethod.POST )
	public ModelAndView getWelfarePayDataMgr2List(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = welfarePayDataMgrService.getWelfarePayDataMgr2List(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	
	
	/**
	 * 복리후생마감관리 전월자료복사
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=insertWelfarePayDataMgrMonthData", method = RequestMethod.POST )
	public ModelAndView insertWelfarePayDataMgrMonthData(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			// 중복체크
			List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",paramMap.get("ssnEnterCd"));
			dupMap.put("YM",paramMap.get("ym").toString().replaceAll("-", ""));
			dupList.add(dupMap);

			dupCnt = commonCodeService.getDupCnt("TBEN991","ENTER_CD,YM","s,s",dupList);

			if (dupCnt > 0) {
				resultCnt = -1;
				message= paramMap.get("ym").toString() + " 자료가 존재합니다.";
			} else {
				resultCnt = welfarePayDataMgrService.insertWelfarePayDataMgrMonthData(paramMap);
				if(resultCnt > 0){ message="전월자료복사 되었습니다."; } else{ message="전월자료복사된 내용이 없습니다."; }
			}
		}catch(Exception e){
			resultCnt = -1; message="전월자료복사에 실패하였습니다.";
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
	 * callP_CPN_AD_CREEP_CANCEL 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callP_CPN_AD_CREEP_CANCEL", method = RequestMethod.POST )
	public ModelAndView callP_CPN_AD_CREEP_CANCEL(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map map  ;
		map = welfarePayDataMgrService.callP_CPN_AD_CREEP_CANCEL(paramMap);

		if (map != null) {
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
	/**
	 * callP_CPN_AD_CREEP_INS 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callP_CPN_AD_CREEP_INS", method = RequestMethod.POST )
	public ModelAndView callP_CPN_AD_CREEP_INS(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map  ;
		map = welfarePayDataMgrService.callP_CPN_AD_CREEP_INS(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("sqlcode : "+map.get("sqlcode"));
		Log.Debug("sqlerrm : "+map.get("sqlerrm"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
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
	/**
	 * callP_BEN_PAY_DATA_CREATE 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callP_BEN_PAY_DATA_CREATE", method = RequestMethod.POST )
	public ModelAndView callP_BEN_PAY_DATA_CREATE(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map map;
		map = welfarePayDataMgrService.callP_BEN_PAY_DATA_CREATE(paramMap);

		if (map != null) {
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
	/**
	 * callP_BEN_PAY_DATA_CREATE_DEL 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callP_BEN_PAY_DATA_CREATE_DEL", method = RequestMethod.POST )
	public ModelAndView callP_BEN_PAY_DATA_CREATE_DEL(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map map  ;
		map = welfarePayDataMgrService.callP_BEN_PAY_DATA_CREATE_DEL(paramMap);

		if (map != null) {
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
	
	/**
	 * callP_BEN_PAY_DATA_CLOSE 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callP_BEN_PAY_DATA_CLOSE", method = RequestMethod.POST )
	public ModelAndView callP_BEN_PAY_DATA_CLOSE(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map map;
		map = welfarePayDataMgrService.callP_BEN_PAY_DATA_CLOSE(paramMap);
		if (map != null) {
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
	/**
	 * callP_BEN_PAY_DATA_CLOSE_CANCEL 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callP_BEN_PAY_DATA_CLOSE_CANCEL", method = RequestMethod.POST )
	public ModelAndView callP_BEN_PAY_DATA_CLOSE_CANCEL(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map  ;
		map = welfarePayDataMgrService.callP_BEN_PAY_DATA_CLOSE_CANCEL(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("sqlcode : "+map.get("sqlcode"));
		Log.Debug("sqlerrm : "+map.get("sqlerrm"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
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