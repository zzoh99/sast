package com.hr.hri.applyApproval.appBeforeLst;

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
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 미결함
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/AppBeforeLst.do", method=RequestMethod.POST )
public class AppBeforeLstController extends ComController {

	@Inject
	@Named("AppBeforeLstService")
	private AppBeforeLstService appBeforeLstService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 미결함 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppBeforeLst", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppBeforeLst(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("AppBeforeLstController.viewAppBeforeLst");
		return "hri/applyApproval/appBeforeLst/appBeforeLst";
	}

	/**
	 * 미결함 리스트 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppBeforeLstList", method = RequestMethod.POST )
	public ModelAndView getAppBeforeLstList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		//한글이 들어 올경우 UTF-8로 Convertion해줘야 된다.
		paramMap = ParamUtils.converterParams(request);
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> result = appBeforeLstService.getAppBeforeLstList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신성서 종류 코드 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppBeforeLstApplCdList", method = RequestMethod.POST )
	public ModelAndView getAppBeforeLstApplCdList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> codeList = appBeforeLstService.getAppBeforeLstApplCdList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("codeList", codeList);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 미결함 저장
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppBeforeLst", method = RequestMethod.POST )
	public ModelAndView saveAppBeforeLst(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugEnd();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		Log.Debug(convertMap.toString());
		String message = "";
		int cnt =0;
		try{ 
			cnt = appBeforeLstService.saveAppBeforeLst(convertMap);
		if (cnt > 0) { message="일괄결재가 완료되었습니다.\n결재하신 내용은 모든문서 메뉴에서 확인하실 수 있습니다."; }  
		else if(cnt == 0 ) { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ Log.Debug(e.getMessage());cnt=-1; message="저장 실패하였습니다."; }

		Map resultMap = new HashMap();
		resultMap.put("Code",cnt); resultMap.put("Message",message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); 
		mv.addObject("Result", 	resultMap);
		Log.DebugStart();
		return mv;
	}
	

	/**
	 * 일괄결제 프로시져 호출
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppBeforeLstProcCall", method = RequestMethod.POST )
	public ModelAndView prcAppBeforeLstProcCall(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));


		Map map  = appBeforeLstService.prcAppBeforeLstProcCall(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("sqlcode : "+map.get("sqlcode"));
		Log.Debug("sqlerrm : "+map.get("sqlerrm"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		} else {
			resultMap.put("Message", "결재가 완료되었습니다.");
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