package com.hr.hrm.appmt.orgAppmtMgr.tab2;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
import com.hr.hrm.appmtBasic.appmtItemMapMgr.AppmtItemMapMgrService;

/**
 * 조직개편발령 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping({"/OrgAppmtMgr.do", "/OrgAppmtMgrTab2.do"})
public class OrgAppmtMgrTab2Controller {

	/**
	 * 조직개편발령 서비스
	 */
	@Inject
	@Named("OrgAppmtMgrTab2Service")
	private OrgAppmtMgrTab2Service orgAppmtMgrTab2Service;
	
	
	@Inject
	@Named("AppmtItemMapMgrService")
	private AppmtItemMapMgrService appmtItemMapMgrService;

	/**
	 * 조직개편발령 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgAppmtMgrTab2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgAppmtMgrTab2() throws Exception {
		return "hrm/appmt/orgAppmtMgr/tab2/orgAppmtMgrTab2";
	}
	
	/**
	 * 발령구분(부서전배, 조직개편) 발령종류코드(콤보로 사용할때) 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgAppmtMgrTabOrdCodeList", method = RequestMethod.POST )
	public ModelAndView getOrgAppmtMgrTabOrdCodeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> result = orgAppmtMgrTab2Service.getOrgAppmtMgrTabOrdCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}	
	
	/**
	 * 발령구분(부서전배, 조직개편) 발령종류코드(ORD_TYPE_CD 콤보로 사용할때) 조회 
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgAppmtMgrTabOrdTypeCodeList", method = RequestMethod.POST )
	public ModelAndView getOrgAppmtMgrTabOrdTypeCodeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> result = orgAppmtMgrTab2Service.getOrgAppmtMgrTabOrdTypeCodeList
				(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}
	

	/**
	 * 발령조직 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgAppmtMgrTab2OrgList", method = RequestMethod.POST )
	public ModelAndView getOrgAppmtMgrTab2OrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgAppmtMgrTab2Service.getOrgAppmtMgrTab2OrgList(paramMap);

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
	 * 발령직원 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgAppmtMgrTab2UserList", method = RequestMethod.POST )
	public ModelAndView getOrgAppmtMgrTab2UserList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgAppmtMgrTab2Service.getOrgAppmtMgrTab2UserList(paramMap);
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
	 * 발령직원 추가
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=insertOrgAppmtMgrTab2User", method = RequestMethod.POST )
	public ModelAndView insertOrgAppmtMgrTab2User(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		// 열로 된 데이터들을 Map 형태의 연관된 데이터 셋으로 만들기 위해
		// 같이 묶여질 param명을 ,구분자 포함하여 만든다.
		// 파싱할 항목을 , 로 구분하여 스트링형태로 생성
		String getParamNames ="sNo,sStatus,sabun,ordTypeCd,ordDetailCd,orgNm,workTypeNm,jikchakNm,jikweeNm"
							 +",sabun,name,workType,jikweeCd,jikgubCd,jikchakCd,jobCd,jobNm,ordYmd"
							 +",ordOrgCd,ordOrgNm,processNo,select";

		// Request에서 파싱하여 저장용도로 Param을 따로 구성
		// 파싱된 객체 목록
		// "mergeRows" 	merge문을 사용하여 update,insert를 한번에 처리하기 위한 저장 List
		// "insertRows" 생성 List
		// "updateRows" 수정 List
		// "deleteRows" 삭제 List
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("chgOrdDetailCd",request.getParameter("chgOrdDetailCd") );
		convertMap.put("chgOrdYmd",request.getParameter("chgOrdYmd") );


		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =orgAppmtMgrTab2Service.insertOrgAppmtMgrTab2User(convertMap);
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
     * 발령직원 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
	@SuppressWarnings("unchecked")
    @RequestMapping(params="cmd=saveOrgAppmtMgrTab2User", method = RequestMethod.POST )
    public ModelAndView saveOrgAppmtMgrTab2User(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();
        
        Log.Debug("000번");

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun",  session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        convertMap.put("processNo",paramMap.get("searchProcessNo"));
        String message = "";
        Map<String,Object> returnMap = null;
        List<Map<String,Object>> errorList = null;
        int resultCnt = -1;
        
        Log.Debug("111번");
        
        try{
            //발령세부내역용 (THRM223)
            // 발령항목(select문을 만들기위해 post_item을 조회)조회
            paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
            paramMap.put("ssnSabun",    session.getAttribute("ssnSabun"));          
            paramMap.put("searchUseYn", "Y");           
            //paramMap.put("includeNm", "Y");
               
            Log.Debug("222번");
            
            Map<String, Object> convertMap2 = ParamUtils.requestInParamsMultiDMLPost(request,paramMap.get("s_SAVENAME").toString(),paramMap.get("s_SAVENAME2").toString(),"VALUE", appmtItemMapMgrService.getAppmtItemMapMgrList(paramMap));
            if (convertMap2 != null) {
            	Log.Debug("2224번");
                convertMap2.put("ssnSabun",     session.getAttribute("ssnSabun"));
                convertMap2.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
                convertMap2.put("processNo",paramMap.get("processNo"));
                
                Log.Debug("2225번");
                
                // insert or update
                returnMap = orgAppmtMgrTab2Service.saveOrgAppmtMgrTab2User(convertMap, convertMap2);
                
                Log.Debug("333번");
                
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
            resultCnt = -1; message="저장에 실패 하였습니다.";
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
