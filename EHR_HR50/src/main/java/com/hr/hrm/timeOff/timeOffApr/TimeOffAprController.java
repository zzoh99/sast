package com.hr.hrm.timeOff.timeOffApr;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.util.CryptoUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.ParamUtils;

/**
 * 휴복직 신청현황/관리
 *
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/TimeOffApr.do", method=RequestMethod.POST )
public class TimeOffAprController {

	@Inject
	@Named("TimeOffAprService")
	private TimeOffAprService timeOffAprService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("OtherService")
	private OtherService otherService;
	
    @Inject
    @Named("EncryptRdService")
    private EncryptRdService encryptRdService;
    
    @Autowired
    private SecurityMgrService securityMgrService;
    
    @Value("${rd.image.base.url}")
    private String imageBaseUrl;

	/**
	 * 휴복직 신청현황/관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeOffApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTimeOffApp() throws Exception {
		return "hrm/timeOff/timeOffApr/timeOffApr";
	}
	

	/**
	 * 휴복직 신청현황/관리  육아휴직신청 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeOffAprPatDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewTimeOffAprPatDet(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("TimeOffAprController.viewTimeOffAprPatDet");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("hrm/timeOff/timeOffApr/timeOffAprPatDetPopup");
		mv.addObject("searchApplSabun", paramMap.get("searchApplSabun").toString());
		mv.addObject("searchApplSeq", 	paramMap.get("searchApplSeq").toString());
		mv.addObject("searchApplCd",	paramMap.get("searchApplCd").toString());
		mv.addObject("adminYn", 		paramMap.get("adminYn").toString());
		mv.addObject("authPg", 			paramMap.get("authPg").toString());
		mv.addObject("searchApplYmd", 	paramMap.get("searchApplYmd").toString());
		mv.addObject("searchSabun", 	paramMap.get("searchSabun").toString());
		return mv;
	}

	/**
	 * 휴복직 신청현황/관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeOffAprOrd", method = RequestMethod.POST )
	public ModelAndView saveTimeOffAprOrd(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = timeOffAprService.saveTimeOffAprOrd(convertMap);
			if(resultCnt > 0){ message="처리되었습니다."; } else{ message="처리된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="처리에 실패하였습니다.";
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
     * RD 데이터 암호화
     * @param session
     * @param request
     * @param paramMap
     * @return
     * @throws Exception
    */
    @RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
    public ModelAndView getEncryptRd(
            HttpSession session, HttpServletRequest request
            , @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();

		String ssnEnterCd = String.valueOf(session.getAttribute("ssnEnterCd"));

		String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd);
		String parameter = String.valueOf(paramMap.get("parameters"));

		List<Map<String, String>> mapList = new ArrayList<>();

		// 정규식을 사용하여 문자열에서 따옴표 안에 있는 문자 추출
		Pattern pattern = Pattern.compile("'(.*?)'");
		Matcher matcher = pattern.matcher(parameter);
		while (matcher.find()) {
			String key = matcher.group(1);
			if (matcher.find()) {
				String value = matcher.group(1);
				Map<String, String> map = new HashMap<>();
				map.put(key, value);
				mapList.add(map);
			}
		}
		String target = "";
		for (Map<String, String> stringStringMap : mapList) {
			for (String key : stringStringMap.keySet()) {
				target += ",('"+ key + "','" + CryptoUtil.decrypt(encryptKey, stringStringMap.get(key)) + "')";
			}
		}

		String mrdPath = "/hrm/timeOff/TimeOffAppDet.mrd";
		String param = "/rp [" + ssnEnterCd + "]"
				+ "[" + target + "]" //신청서순번
				+ "[" + imageBaseUrl + "]";

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

    @RequestMapping(params="cmd=getTimeOffAprApplCodeList", method = RequestMethod.POST )
    public ModelAndView getTimeOffAprApplCodeList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = timeOffAprService.getTimeOffAprApplCodeList(paramMap);
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

    @RequestMapping(params="cmd=getApplStatusCdList", method = RequestMethod.POST )
    public ModelAndView getApplStatusCdList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = timeOffAprService.getApplStatusCdList(paramMap);
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

    @RequestMapping(params="cmd=getTimeOffAprList", method = RequestMethod.POST )
    public ModelAndView getTimeOffAprList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = timeOffAprService.getTimeOffAprList(paramMap);
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