package com.hr.hrm.psnalInfo.psnalBasic;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.rd.EncryptRdService;

/**
 * 인사기본(기본탭) Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalBasic.do", method=RequestMethod.POST )
public class PsnalBasicController {

	/**
	 * 인사기본(기본탭) 서비스
	 */
	@Inject
	@Named("PsnalBasicService")
	private PsnalBasicService psnalBasicService;


    @Inject
    @Named("EncryptRdService")
    private EncryptRdService encryptRdService;
    
	@Autowired
	private SecurityMgrService securityMgrService;
	
    @Value("${rd.image.base.url}")
    private String imageBaseUrl;

	/**
	 * 인사기본(기본탭) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalBasic", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalBasic() throws Exception {
		return "hrm/psnalInfo/psnalBasic/psnalBasic";
	}


	/**
	 * 인사기본(기본탭) 인사정보 복사 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalBasicCopyPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalBasicCopyPop() throws Exception {
		return "hrm/psnalInfo/psnalBasic/psnalBasicCopyPop";
	}

	@RequestMapping(params="cmd=viewPsnalBasicLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalBasicLayer() throws Exception {
		return "hrm/psnalInfo/psnalBasic/psnalBasicLayer";
	}

	/**
	 * 인사기본(기본탭) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicList", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";

		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("authPg", getAuthPg(session, paramMap));

		List<Map<String, Object>> result = null;

		if(ssnEnterCd != null) {

			result = (List<Map<String, Object>>) psnalBasicService.getPsnalBasicList(paramMap);

			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM);

			if (encryptKey != null) {
				for (Map<String, Object> empMap : result) {
					empMap.put("rk", CryptoUtil.encrypt(encryptKey, empMap.get("enterCd") + "#" + empMap.get("sabun")));
				}
			}
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	private String getAuthPg(HttpSession session, Map<String, Object> paramMap) throws Exception {
		String url = (String) paramMap.get("surl");
		String key = (String) session.getAttribute("ssnEncodedKey");

		String replaceUrl = url.replaceAll(" {2}", "++").replaceAll("\\s+", "+");

		Map<?, ?> rtn = securityMgrService.getDecryptUrl(replaceUrl, key) ;

		if( rtn.get("dataPrgType") != null && rtn.get("dataPrgType").equals("P")){
			return (String)rtn.get("dataRwType");
		}

		return (String) session.getAttribute("ssnDataRwType");
	}

	/**
	 * 인사기본(기본탭) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicCopyPopList", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicCopyPopList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> result = psnalBasicService.getPsnalBasicCopyPopList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사기본(기본탭) 수정
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updatePsnalBasic", method = RequestMethod.POST )
	public ModelAndView updatePsnalBasic(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = psnalBasicService.updatePsnalBasic(paramMap);
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
	 * 인사기본 (인사정보복사) - 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcPsnalBasicCopy", method = RequestMethod.POST )
	public ModelAndView prcPsnalBasicCopy(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map  = psnalBasicService.prcPsnalBasicCopy(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlcode") != null) {
				resultMap.put("Code", map.get("sqlcode").toString());
			}
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
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

	@RequestMapping(params="cmd=getPsnalBasic", method = RequestMethod.POST )
	public ModelAndView getPsnalBasic(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = psnalBasicService.getPsnalBasic(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=getPsnalTimeLineList", method = RequestMethod.POST )
	public ModelAndView getPsnalTimeLineList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> result = psnalBasicService.getPsnalTimeLineList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
}
