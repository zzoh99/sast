package com.hr.ben.gift.giftStd;

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.ParamUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 선물기준관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping({"/GiftStd.do", "/GiftApp.do"}) 
public class GiftStdController extends ComController {
	/**
	 * 선물기준관리 서비스
	 */
	@Inject
	@Named("GiftStdService")
	private GiftStdService giftStdService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Autowired
	private SecurityMgrService securityMgrService;
	
	/**
	 * 선물기준관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewGiftStd",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewGiftStd() throws Exception {
		return "ben/gift/giftStd/giftStd";
	}
	
	/**
	 * 선물기준관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGiftStdList", method = RequestMethod.POST )
	public ModelAndView getGiftStdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	/**
	 * 선물기준관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGiftStdDtlList", method = RequestMethod.POST )
	public ModelAndView getGiftStdDtlList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 선물기준관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveGiftStd", method = RequestMethod.POST )
	public ModelAndView saveGiftStd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		return saveData(session, request, paramMap);
	}

	/**
	 * 선물기준관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveGiftStdDtl", method = RequestMethod.POST )
	public ModelAndView saveGiftStdDtl(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map> mergeList = (List<Map>)convertMap.get("mergeRows");

		String enterCd = (String) session.getAttribute("ssnEnterCd");
		String encryptKey = securityMgrService.getEncryptKey(enterCd);

		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		for(Map<String, Object> mp : insertList) {
			// 중복체크
			Map<String,Object> dupMap = new HashMap<>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("GIFT_SEQ",mp.get("giftSeq"));
			dupMap.put("GIFT_CD",mp.get("giftCd"));
			dupList.add(dupMap);
			// GIFT_IMG_SEQ 값 복호화
			String giftImgSeq = (String) mp.getOrDefault("giftImgSeq", "");

			if(!giftImgSeq.equals("")) {
				mp.put("giftImgSeq", CryptoUtil.decrypt(encryptKey, giftImgSeq));
			}
		}

		for(Map<String, Object> mp : mergeList) {
			// GIFT_IMG_SEQ 값 복호화
			String giftImgSeq = (String) mp.getOrDefault("giftImgSeq", "");

			if(!giftImgSeq.equals("")) {
				mp.put("giftImgSeq", CryptoUtil.decrypt(encryptKey, giftImgSeq));
			}
		}

		convertMap.put("insertRows", insertList);
		convertMap.put("mergeRows", mergeList);

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TBEN766","ENTER_CD,GIFT_SEQ,GIFT_CD","s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = giftStdService.saveGiftStdDtl(convertMap);
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
}
