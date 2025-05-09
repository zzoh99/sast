package com.hr.sample;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.MessageSource;
import org.springframework.context.MessageSourceAware;
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
 * 샘플 Controller
 *
 * @author isuSystem
 *
 */
@Controller
@RequestMapping(value="/Sample.do", method=RequestMethod.POST )
public class SampleController extends ComController {
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("SampleService")
	private SampleService sampleService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 샘플 화면
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSampleTab", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSampleTab() throws Exception {
		return "sample/sampleTab";
	}


	/**
	 * 기본화면 가이드( sampleDefault.jsp ) 화면
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSampleDefault", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSampleDefault() throws Exception {
		return "sample/sampleDefault";
	}

	/**
	 * 신청결재화면 가이드( sampleApproval.jsp ) 화면
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSampleApproval", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSampleApproval() throws Exception {
		return "sample/sampleApproval";
	}

	/**
	 * 신청결재화면 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSampleApprovalDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSampleApprovalDet() throws Exception {
		return "sample/sampleApprovalDet";
	}

	/**
	 * 샘플 화면 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSampleList", method = RequestMethod.POST )
	public ModelAndView getSampleList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 샘플 화면 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSample", method = RequestMethod.POST )
	public ModelAndView saveSample(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"ZTST001", "SABUN,SEQ", "sabun,seq", "s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}

	/**
	 * 프로시저 호출 샘플
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=samplePrcCall", method = RequestMethod.POST )
	public ModelAndView samplePrcCall(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		return execPrc(session, request, paramMap);
	}

	/**
	 * 신청결재 샘플 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSampleApprovalList", method = RequestMethod.POST )
	public ModelAndView getSampleApprovalList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 신청결재 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteSampleApproval", method = RequestMethod.POST )
	public ModelAndView deleteSampleApproval(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 신청결재 샘플 정보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSampleApprovalMap", method = RequestMethod.POST )
	public ModelAndView getSampleApprovalMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 신청결재 샘플 세부내역 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSampleApprovalDet", method = RequestMethod.POST )
	public ModelAndView saveSampleApprovalDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}