package com.hr.pap.appCompetency.compAppraisalGubun;
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
 * 리더십진단항목정의 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/CompAppraisalGubun.do", method=RequestMethod.POST )
public class CompAppraisalGubunController {
	/**
	 * 리더십진단항목정의 서비스
	 */
	@Inject
	@Named("CompAppraisalGubunService")
	private CompAppraisalGubunService compAppraisalGubunService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 리더십진단항목정의 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompAppraisalGubun", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompAppraisalGubun() throws Exception {
		return "pap/appCompetency/compAppraisalGubun/compAppraisalGubun";
	}

	/**
	 * 역량항목 레이어팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompetencyMngLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompetencyMngLayer() throws Exception {
		return "pap/appCompetency/compAppraisalGubun/competencyMngLayer";
	}

	/**
	 * 범위설정 레이어팝업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompAppraisalGubunRngLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompAppraisalGubunRngLayer() throws Exception {
		return "pap/appCompetency/compAppraisalGubun/compAppraisalGubunRngLayer";
	}


	/**
	 * 리더십진단항목정의 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppraisalGubunList", method = RequestMethod.POST )
	public ModelAndView getCompAppraisalGubunList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = compAppraisalGubunService.getCompAppraisalGubunList(paramMap);
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
	 * 리더십진단항목정의 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCompAppraisalGubun", method = RequestMethod.POST )
	public ModelAndView saveCompAppraisalGubun(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		// Request에서 파싱하여 저장용도로 Param을 따로 구성
		// 파싱된 객체 목록
		// "mergeRows" 	merge문을 사용하여 update,insert를 한번에 처리하기 위한 저장 List
		// "insertRows" 생성 List
		// "updateRows" 수정 List
		// "deleteRows" 삭제 List
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("COMP_APPRASIAL_CD",mp.get("compApprasialCd"));
			dupMap.put("LDS_COMPETENCY_CD",mp.get("ldsCompetencyCd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TPAP523","ENTER_CD,COMP_APPRAISAL_CD,LDS_COMPETENCY_CD","s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt =compAppraisalGubunService.saveCompAppraisalGubun(convertMap);
				if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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

    @RequestMapping(params="cmd=getAppGroupMgrRngPopList1", method = RequestMethod.POST )
    public ModelAndView getAppGroupMgrRngPopList1(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = compAppraisalGubunService.getAppGroupMgrRngPopList1(paramMap);
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
}
