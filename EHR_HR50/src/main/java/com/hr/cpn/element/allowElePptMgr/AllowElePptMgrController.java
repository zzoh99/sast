package com.hr.cpn.element.allowElePptMgr;

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

import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 공통 팝업
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/AllowElePptMgr.do", method=RequestMethod.POST )
public class AllowElePptMgrController {

	@Inject
	@Named("AllowElePptMgrService")
	private AllowElePptMgrService allowElePptMgrService;

	/**
	 * 항목그룹
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAllowElePptMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAllowElePptMgr() throws Exception {
		return "cpn/element/allowElePptMgr/allowElePptMgr";
	}

	/**
	 * 항목그룹
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAllowElePptMgrList", method = RequestMethod.POST )
	public ModelAndView getAllowElePptMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		try{
			list = allowElePptMgrService.getAllowElePptMgrList(paramMap);
		}catch(Exception e){
			Message = LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다.");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}	/**
	 * 항목그룹1
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAllowElePptMgrListFirst", method = RequestMethod.POST )
	public ModelAndView getAllowElePptMgrListFirst(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		try{
			list = allowElePptMgrService.getAllowElePptMgrListFirst(paramMap);
		}catch(Exception e){
			Message = LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다.");;
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 항목그룹2
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAllowElePptMgrListSecond", method = RequestMethod.POST )
	public ModelAndView getAllowElePptMgrListSecond(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		try{
			list = allowElePptMgrService.getAllowElePptMgrListSecond(paramMap);
		}catch(Exception e){
			Message = LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다.");;
		}
		// searchElemCd
		// 변경전 임시
		HashMap<String, String> converMap = null;

		// 변경후 완성된
	    List<HashMap> createList = new ArrayList<HashMap>();

		if(list.size() != 0){
			converMap = (HashMap)list.get(0);

			// 수습적용율
		    HashMap<String, String> createMap2 = new HashMap<String, String>();
		    createMap2.put("elementCd", converMap.get("elementCd").toString());
		    createMap2.put("elementSetNm", "수습적용율");
		    createMap2.put("attribute", converMap.get("attribute2").toString());
		    createList.add(createMap2);

		    // 과세여부
		    HashMap<String, String> createMap3 = new HashMap<String, String>();
		    createMap3.put("elementCd", converMap.get("elementCd").toString());
		    createMap3.put("elementSetNm", "과세여부");
		    createMap3.put("attribute", converMap.get("attribute3").toString());
		    createList.add(createMap3);

			// 신입/복직일할계산
		    HashMap<String, String> createMap4 = new HashMap<String, String>();
		    createMap4.put("elementCd", converMap.get("elementCd").toString());
		    createMap4.put("elementSetNm", "신입/복직일할계산");
		    createMap4.put("attribute", converMap.get("attribute4").toString());
		    createList.add(createMap4);

			// 퇴직당월일할계산
		    HashMap<String, String> createMap5 = new HashMap<String, String>();
		    createMap5.put("elementCd", converMap.get("elementCd").toString());
		    createMap5.put("elementSetNm", "퇴직당월일할계산");
		    createMap5.put("attribute", converMap.get("attribute5").toString());
		    createList.add(createMap5);

			// 발령관련일할계산
		    HashMap<String, String> createMap6 = new HashMap<String, String>();
		    createMap6.put("elementCd", converMap.get("elementCd").toString());
		    createMap6.put("elementSetNm", "발령관련일할계산");
		    createMap6.put("attribute", converMap.get("attribute6").toString());
		    createList.add(createMap6);

			// 징계관련일할계산
		    HashMap<String, String> createMap7 = new HashMap<String, String>();
		    createMap7.put("elementCd", converMap.get("elementCd").toString());
		    createMap7.put("elementSetNm", "징계관련일할계산");
		    createMap7.put("attribute", converMap.get("attribute7").toString());
		    createList.add(createMap7);

			// 근태관련일할계산
		    HashMap<String, String> createMap9 = new HashMap<String, String>();
		    createMap9.put("elementCd", converMap.get("elementCd").toString());
		    createMap9.put("elementSetNm", "근태관련일할계산");
		    createMap9.put("attribute", converMap.get("attribute9").toString());
		    createList.add(createMap9);

		    // 산재관련일할계산
		    /*
		    HashMap<String, String> createMap11 = new HashMap<String, String>();
		    createMap11.put("elementCd", converMap.get("elementCd").toString());
		    createMap11.put("elementSetNm", "산재관련일할계산");
		    createMap11.put("attribute", converMap.get("attribute11").toString());
		    createList.add(createMap11);
		    */

			// 연말정산필드
		    HashMap<String, String> createMap8 = new HashMap<String, String>();
		    createMap8.put("elementCd", 	converMap.get("elementCd").toString());
		    createMap8.put("elementSetNm",	"연말정산필드");
		    createMap8.put("attribute", 	converMap.get("attribute8").toString());
		    createMap8.put("attributeNm", 	converMap.get("attribute8Nm").toString());
		    createList.add(createMap8);

			// 상여관련
		    HashMap<String, String> createMap10 = new HashMap<String, String>();
		    createMap10.put("elementCd", converMap.get("elementCd").toString());
		    createMap10.put("elementSetNm", "상여관련");
		    createMap10.put("attribute", converMap.get("attribute10").toString());
		    createList.add(createMap10);
		}
		else{
			// 수습적용율
		    HashMap<String, String> createMap2 = new HashMap<String, String>();
		    createMap2.put("elementCd", paramMap.get("searchElemCd").toString());
		    createMap2.put("elementSetNm", "수습적용율");
		    createMap2.put("attribute", "");
		    createList.add(createMap2);

		    // 과세여부
		    HashMap<String, String> createMap3 = new HashMap<String, String>();
		    createMap3.put("elementCd", paramMap.get("searchElemCd").toString());
		    createMap3.put("elementSetNm", "과세여부");
		    createMap3.put("attribute", "");
		    createList.add(createMap3);

			// 신입/복직일할계산
		    HashMap<String, String> createMap4 = new HashMap<String, String>();
		    createMap4.put("elementCd", paramMap.get("searchElemCd").toString());
		    createMap4.put("elementSetNm", "신입/복직일할계산");
		    createMap4.put("attribute", "");
		    createList.add(createMap4);

			// 퇴직당월일할계산
		    HashMap<String, String> createMap5 = new HashMap<String, String>();
		    createMap5.put("elementCd", paramMap.get("searchElemCd").toString());
		    createMap5.put("elementSetNm", "퇴직당월일할계산");
		    createMap5.put("attribute", "");
		    createList.add(createMap5);

			// 발령관련일할계산
		    HashMap<String, String> createMap6 = new HashMap<String, String>();
		    createMap6.put("elementCd", paramMap.get("searchElemCd").toString());
		    createMap6.put("elementSetNm", "발령관련일할계산");
		    createMap6.put("attribute", "");
		    createList.add(createMap6);

			// 징계관련일할계산
		    HashMap<String, String> createMap7 = new HashMap<String, String>();
		    createMap7.put("elementCd", paramMap.get("searchElemCd").toString());
		    createMap7.put("elementSetNm", "징계관련일할계산");
		    createMap7.put("attribute", "");
		    createList.add(createMap7);

			// 근태관련일할계산
		    HashMap<String, String> createMap9 = new HashMap<String, String>();
		    createMap9.put("elementCd", paramMap.get("searchElemCd").toString());
		    createMap9.put("elementSetNm", "근태관련일할계산");
		    createMap9.put("attribute", "");
		    createList.add(createMap9);

		    // 산재관련일할계산
		    /*
		    HashMap<String, String> createMap11 = new HashMap<String, String>();
		    createMap11.put("elementCd", paramMap.get("searchElemCd").toString());
		    createMap11.put("elementSetNm", "산재관련일할계산");
		    createMap11.put("attribute", "");
		    createList.add(createMap11);
		    */

			// 연말정산필드
		    HashMap<String, String> createMap8 = new HashMap<String, String>();
		    createMap8.put("elementCd", paramMap.get("searchElemCd").toString());
		    createMap8.put("elementSetNm", "연말정산필드");
		    createMap8.put("attribute", "");
		    createMap8.put("attributeNm", "");
		    createList.add(createMap8);

			// 상여관련
		    HashMap<String, String> createMap10 = new HashMap<String, String>();
		    createMap10.put("elementCd", paramMap.get("searchElemCd").toString());
		    createMap10.put("elementSetNm", "상여관련");
		    createMap10.put("attribute", "");
		    createList.add(createMap10);
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", createList);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 항목그룹3
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAllowElePptMgrListThird", method = RequestMethod.POST )
	public ModelAndView getAllowElePptMgrListThird(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		try{
			list = allowElePptMgrService.getAllowElePptMgrListThird(paramMap);
		}catch(Exception e){
			Message = LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 항목그룹2 수정
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updateAllowElePptMgrListSecond", method = RequestMethod.POST )
	public ModelAndView updateEleGroupMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = allowElePptMgrService.updateAllowElePptMgrListSecond(convertMap);
			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			} else {
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}
		}catch(Exception e){
			resultCnt = -1;
			message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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