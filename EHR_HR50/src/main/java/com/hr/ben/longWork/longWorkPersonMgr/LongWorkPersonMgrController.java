package com.hr.ben.longWork.longWorkPersonMgr;
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

/**
 * 근속포상대상자관리 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/LongWorkPersonMgr.do", method=RequestMethod.POST )
public class LongWorkPersonMgrController {
	/**
	 * 근속포상대상자관리 서비스
	 */
	@Inject
	@Named("LongWorkPersonMgrService")
	private LongWorkPersonMgrService longWorkPersonMgrService;

	/**
	 * 근속포상대상자관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLongWorkPersonMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLongWorkPersonMgr() throws Exception {
		return "ben/longWork/longWorkPersonMgr/longWorkPersonMgr";
	}


	/**
	 * 근속포상대상자관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLongWorkPersonMgrList", method = RequestMethod.POST )
	public ModelAndView getLongWorkPersonMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = longWorkPersonMgrService.getLongWorkPersonMgrList(paramMap);
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
	 * 근속포상대상자관리 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLongWorkPersonMgrMap", method = RequestMethod.POST )
	public ModelAndView getLongWorkPersonMgrMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = longWorkPersonMgrService.getLongWorkPersonMgrMap(paramMap);
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
	
	/**
	 * 근속포상대상자 생성 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_HRM_LONG_WORK_PERSON_CREATE", method = RequestMethod.POST )
	public ModelAndView prcP_HRM_LONG_WORK_PERSON_CREATE(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map  = longWorkPersonMgrService.prcP_HRM_LONG_WORK_PERSON_CREATE(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			} else {
				resultMap.put("Message", "사번이 생성되었습니다.");
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
	 * 근속포상대상자 확정 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_HRM_LONG_WORK_PERSON_CONFIRM", method = RequestMethod.POST )
	public ModelAndView prcP_HRM_LONG_WORK_PERSON_CONFIRM(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map  = longWorkPersonMgrService.prcP_HRM_LONG_WORK_PERSON_CONFIRM(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			} else {
				resultMap.put("Message", "사번이 생성되었습니다.");
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
	 * 근속포상대상자 확정 취소 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_HRM_LONG_WORK_PERSON_CANCEL", method = RequestMethod.POST )
	public ModelAndView prcP_HRM_LONG_WORK_PERSON_CANCEL(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map  = longWorkPersonMgrService.prcP_HRM_LONG_WORK_PERSON_CANCEL(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map != null) {
			Log.Debug("obj : " + map);
			Log.Debug("sqlcode : " + map.get("sqlcode"));
			Log.Debug("sqlerrm : " + map.get("sqlerrm"));

			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			} else {
				resultMap.put("Message", "사번이 생성되었습니다.");
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
	 * 근속포상대상자관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcConfirmLongWorkPersonMgr", method = RequestMethod.POST )
	public ModelAndView prcConfirmLongWorkPersonMgr(HttpSession session,
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
			cnt = longWorkPersonMgrService.prcConfirmLongWorkPersonMgr(convertMap);
		if (cnt > 0) { 
			message="근속포상대상자를 확정처리가 완료되었습니다.";
		}else if(cnt == 0 ) { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ Log.Debug(e.getMessage());cnt=-1; message="저장 실패하였습니다."; }

		Map resultMap = new HashMap();
		resultMap.put("Code",cnt);
		resultMap.put("Message",message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); 
		mv.addObject("Result", 	resultMap);
		Log.DebugStart();
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
	@RequestMapping(params="cmd=prcCancelLongWorkPersonMgr", method = RequestMethod.POST )
	public ModelAndView prcCancelLongWorkPersonMgr(HttpSession session,
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
			cnt = longWorkPersonMgrService.prcCancelLongWorkPersonMgr(convertMap);
		if (cnt > 0) { 
			message="근속포상대상자 데이터가 확정취소되었습니다.";
		}else if(cnt == 0 ) { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ Log.Debug(e.getMessage());cnt=-1; message="저장 실패하였습니다."; }

		Map resultMap = new HashMap();
		resultMap.put("Code",cnt);
		resultMap.put("Message",message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); 
		mv.addObject("Result", 	resultMap);
		Log.DebugStart();
		return mv;
	}

    @RequestMapping(params="cmd=saveLongWorkPersonMgr", method = RequestMethod.POST )
    public ModelAndView saveLongWorkPersonMgr(HttpSession session,
                                              @RequestParam Map<String, Object> paramMap,
                                              HttpServletRequest request) {
        Log.DebugEnd();
        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
        Log.Debug(convertMap.toString());

        String message = "";
        int cnt = 0;
        try {
            cnt = longWorkPersonMgrService.saveLongWorkPersonMgr(convertMap);
            if (cnt > 0) {
                message = "저장되었습니다.";
            } else {
                message="저장된 내용이 없습니다.";
            }
        } catch (Exception e) {
            Log.Debug(e.getMessage());cnt=-1; message="저장 실패하였습니다.";
        }

        Map resultMap = new HashMap();
        resultMap.put("Code",cnt);
        resultMap.put("Message",message);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", 	resultMap);
        Log.DebugStart();
        return mv;
    }

    @RequestMapping(params="cmd=getLongWorkPersonMgrWorkYear", method = RequestMethod.POST )
    public ModelAndView getLongWorkPersonMgrWorkYear(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = longWorkPersonMgrService.getLongWorkPersonMgrWorkYear(paramMap);
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

}
