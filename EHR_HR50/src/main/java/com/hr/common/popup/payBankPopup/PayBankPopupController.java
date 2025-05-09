package com.hr.common.popup.payBankPopup;
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
 * 은행관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PayBankPopup.do", method=RequestMethod.POST )
public class PayBankPopupController {
	/**
	 * 은행관리 서비스
	 */
	@Inject
	@Named("PayBankPopupService")
	private PayBankPopupService payBankPopupService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 은행관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=payBankPopup", method = RequestMethod.POST )
	public String viewPayBankPopup() throws Exception {
		return "common/popup/payBankPopup";
	}
	/**
	 * 은행관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayBankPopupList", method = RequestMethod.POST )
	public ModelAndView getPayBankPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = payBankPopupService.getPayBankPopupList(paramMap);
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
	 * 은행관리 개인별급여세부내역(관리자)용 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayDayAdminPopupList", method = RequestMethod.POST )
	public ModelAndView getPayDayAdminPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = payBankPopupService.getPayDayAdminPopupList(paramMap);
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
	 * 은행관리 개인별급여세부내역용 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayDayUserPopupList", method = RequestMethod.POST )
	public ModelAndView getPayDayUserPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = payBankPopupService.getPayDayUserPopupList(paramMap);
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
	 * 은행관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayBankPopupMap", method = RequestMethod.POST )
	public ModelAndView getPayBankPopupMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = payBankPopupService.getPayBankPopupMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 은행관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePayBankPopup", method = RequestMethod.POST )
	public ModelAndView savePayBankPopup(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		// 열로 된 데이터들을 Map 형태의 연관된 데이터 셋으로 만들기 위해 
		// 같이 묶여질 param명을 ,구분자 포함하여 만든다.
		// 파싱할 항목을 , 로 구분하여 스트링형태로 생성
		String getParamNames ="sNo,sDelete,sStatus,selectImg,payActionCd,payActionNm,payYm,payCd,runType,paymentYmd,closeYn,ordSymd,ordEymd,timeYm,calTaxMethod,calTaxSym,calTaxEym,addTaxRate,bonSymd,bonEymd,gntSymd,gntEymd,bonCalType,bonApplyType,bonMonRate,paymentMethod,manCnt";
		
		// Request에서 파싱하여 저장용도로 Param을 따로 구성
		// 파싱된 객체 목록
		// "mergeRows" 	merge문을 사용하여 update,insert를 한번에 처리하기 위한 저장 List
		// "insertRows" 생성 List
		// "updateRows" 수정 List
		// "deleteRows" 삭제 List
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		
		
		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("PAY_ACTION_CD",mp.get("payActionCd"));
			dupList.add(dupMap);
		}
		
		String message = "";
		int resultCnt = -1;
		
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN201","ENTER_CD,PAY_ACTION_CD","s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt =payBankPopupService.savePayBankPopup(convertMap);
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
	
}
