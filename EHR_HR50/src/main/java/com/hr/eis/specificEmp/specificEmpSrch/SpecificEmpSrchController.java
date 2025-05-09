package com.hr.eis.specificEmp.specificEmpSrch;
import java.util.*;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.ParamUtils;
import com.hr.hrm.appmtBasic.appmtItemMapMgr.AppmtItemMapMgrService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;

/**
 * 맞춤인재검색 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/SpecificEmpSrch.do", method=RequestMethod.POST )
public class SpecificEmpSrchController {

	/**
	 * 맞춤인재검색 서비스
	 */
	@Inject
	@Named("SpecificEmpSrchService")
	private SpecificEmpSrchService specificEmpSrchService;

	@Inject
	@Named("AppmtItemMapMgrService")
	private AppmtItemMapMgrService appmtItemMapMgrService;

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;

	/**
	 * 맞춤인재검색 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSpecificEmpSrch", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSpecificEmpSrch() throws Exception {
		return "eis/specificEmp/specificEmpSrch/specificEmpSrch";
	}

	/**
	 * 인재탐색/비교 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSpecificEmpSrchNew", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSpecificEmpSrchNew() throws Exception {
		return "eis/specificEmp/specificEmpSrch/specificEmpSrchNew";
	}
	
	/**
	 * 맞춤인재검색 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSelectConditionPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelectConditionPopup() throws Exception {
		return "eis/specificEmp/specificEmpSrch/selectConditionPopup";
	}

	@RequestMapping(params="cmd=viewSelectConditionLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelectConditionLayer() throws Exception {
		return "eis/specificEmp/specificEmpSrch/selectConditionLayer";
	}
	/**
	 * 결과 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSrchResultPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSrchResultPopup() throws Exception {
		return "eis/specificEmp/specificEmpSrch/srchResultPopup";
	}

	@RequestMapping(params="cmd=viewSrchResultLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSrchResultLayer() throws Exception {
		return "eis/specificEmp/specificEmpSrch/srchResultLayer";
	}
	/**
	 * 웨이팅 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWaitPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWaitPopup() throws Exception {
		return "eis/specificEmp/specificEmpSrch/waitPopup";
	}


	/**
	 * 조건 불러오기 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSpecificEmpSrchNewConditionLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSpecificEmpSrchNewConditionLayer() throws Exception {
		return "eis/specificEmp/specificEmpSrch/conditionLayer";
	}

	/**
	 * 키워드 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSpecificEmpSrchNewKeywordLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSpecificEmpSrchNewKeywordLayer() throws Exception {
		return "eis/specificEmp/specificEmpSrch/keywordLayer";
	}

	/**
	 * 맞춤인재검색 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSpecificEmpSrchPeopleMap", method = RequestMethod.POST )
	public ModelAndView getSpecificEmpSrchPeopleMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;
		try{
			map = specificEmpSrchService.getSpecificEmpSrchPeopleMap(paramMap);
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
	 *  맞춤인재검색 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSpecificEmpList", method = RequestMethod.POST )
	public ModelAndView getSpecificEmpList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = specificEmpSrchService.getSpecificEmpList(paramMap);
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
	 *  맞춤인재검색 팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSpecificEmpListPop", method = RequestMethod.POST )
	public ModelAndView getSpecificEmpListPop(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = specificEmpSrchService.getSpecificEmpListPop(paramMap);
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
	 *  맞춤인재검색 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSpecificEmpExcel", method = RequestMethod.POST )
	public ModelAndView getSpecificEmpExcel(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		
		try{
			list = specificEmpSrchService.getSpecificEmpExcel(paramMap);
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
	 *  인재탐색/비교 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSpecificEmpSrchNewList", method = RequestMethod.POST )
	public ModelAndView getSpecificEmpSrchNewList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));

		try{
			list = specificEmpSrchService.getSpecificEmpSrchNewList(paramMap);
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
	 *  키워드 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSpecificEmpSrchKeywordList", method = RequestMethod.POST )
	public ModelAndView getSpecificEmpSrchKeywordList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));

		try{
			list = specificEmpSrchService.getSpecificEmpSrchKeywordList(paramMap);
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
	 * 발령직원 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=saveSpecificEmpSrchNewChgOrd", method = RequestMethod.POST )
	public ModelAndView saveSpecificEmpSrchNewChgOrd(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun",  session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("processNo",paramMap.get("searchProcessNo"));
		String message = "";
		Map<String,Object> returnMap = null;
		List<Map<String,Object>> errorList = null;
		int resultCnt = -1;

		try{
			//발령세부내역용 (THRM223)
			// 발령항목(select문을 만들기위해 post_item을 조회)조회
			paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
			paramMap.put("ssnSabun",    session.getAttribute("ssnSabun"));
			paramMap.put("searchUseYn", "Y");

			Map<String, Object> convertMap2 = ParamUtils.requestInParamsMultiDMLPost(request,paramMap.get("s_SAVENAME").toString(),paramMap.get("s_SAVENAME2").toString(),"VALUE", appmtItemMapMgrService.getAppmtItemMapMgrList(paramMap));
			if (convertMap2 != null) {

				Iterator<String> iter = convertMap2.keySet().iterator();
				while(iter.hasNext()) {
					String key = iter.next();

					System.out.println("key: " + key);
					System.out.println("value: " + convertMap2.get(key));
				}

				convertMap2.put("ssnSabun",     session.getAttribute("ssnSabun"));
				convertMap2.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

				// insert or update
				returnMap = specificEmpSrchService.saveSpecificEmpSrchNewChgOrd(convertMap, convertMap2);

				// get result
				resultCnt = (Integer)returnMap.get("successCnt");
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
				errorList = (List<Map<String,Object>>) returnMap.get("errorList");
				if(errorList!=null && errorList.size()>0){
					message = "";
					for(Map<String,Object> err : errorList){
						message += ",{\"ordError\":\"동일한 [발령, 발령일, 사원]이 품의번호["+err.get("dupProcessNo")+"["+err.get("dupProcessTitle")+"]]에 등록되어있습니다.\"";
						Iterator<?> errIterator = err.entrySet().iterator();
						while (errIterator.hasNext()) {
							Map.Entry<?, ?> entry = (Map.Entry<?, ?>) errIterator.next();
							message += ",\""+entry.getKey()+"\":\""+entry.getValue()+"\"";
						}
						message += "}";
					}
					message = "["+message.substring(1)+"]";
				}
			}
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하 였습니다.";
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
	 * rk 생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpCardPrtRk", method = RequestMethod.POST )
	public ModelAndView getEmpCardPrtRk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		Map<String, Object> mapResult = new HashMap<>();

		try{
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM);

			if (encryptKey != null) {
				String enterCd = String.valueOf(paramMap.get("enterCd"));
				String sabun = String.valueOf(paramMap.get("sabun"));
				mapResult.put("rk", CryptoUtil.encrypt(encryptKey, enterCd + "#" + sabun));
				//mapResult.put("rp", CryptoUtil.encrypt(encryptKey, makeRp()));
			}

		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", mapResult);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		//String enterCd = paramMap.get("enterCd");

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
			String ssnSabun = session.getAttribute("ssnSabun") + "";
			String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.
			String empKey = CryptoUtil.decrypt(encryptKey, paramMap.get("rk")+"");
			String[] empKeys = empKey.split("#");

			String securityKey = request.getAttribute("securityKey")+"";

			String mrdPath = "/hrm/empcard/PersonInfoCardType1_HR.mrd";
			String param = "/rp [ ,('" + empKeys[0] + "','" + empKeys[1] +"') ]"
					+ " [" + imageBaseUrl + "] "
					+ " [Y]" // 마스킹 여부
					+ " [Y]" // hrbasic1
					+ " [Y]" // hrbasic2
					+ " [Y]" // 발령사항
					+ " [Y]" // 교육사항
					+ " [Y]" // 전체발령표시여부
					+ " [" + ssnEnterCd + "]"
					+ " ['" + ssnSabun + "']"
					+ " [" + ssnLocaleCd + "]"
					+ " ['," + empKeys[1] + "']"
					+ " [Y]" // 평가
					+ " [Y]" // 타부서발령여부
					+ " [Y]" // 연락처
					+ " [Y]" // 병역
					+ " [Y]" // 학력
					+ " [Y]" // 경력
					+ " [Y]" // 포상
					+ " [Y]" // 징계
					+ " [Y]" // 자격
					+ " [Y]" // 어학
					+ " [Y]" // 가족
					+ " [Y]" // 발령
					+ " [Y]" // 경력
					+ " [" + securityKey + "] "
					+ " /rv securityKey[" + securityKey + "] /rloadimageopt [1]"
					;


			ModelAndView mv = new ModelAndView();
			mv.setViewName("jsonView");
			try {
				mv.addObject("DATA", encryptRdService.encrypt(mrdPath, param));
				mv.addObject("Message", "");
			} catch (Exception e) {
				mv.addObject("Message", "암호화에 실패했습니다.");
			}

			Log.DebugEnd();
			return mv;
		}
		return null;
	}
}