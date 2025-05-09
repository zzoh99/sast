package com.hr.api.m.hrm.emp;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.com.ComService;
import com.hr.common.employee.EmployeeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.util.StringUtil;
import com.hr.cpn.personalPay.perPayPartiTermUSta.PerPayPartiTermUStaService;
import com.hr.hrm.psnalInfo.psnalCareer.PsnalCareerService;
import com.hr.hrm.psnalInfo.psnalContact.PsnalContactService;
import com.hr.hrm.psnalInfo.psnalPost.PsnalPostService;
import com.hr.hrm.psnalInfo.psnalSchool.PsnalSchoolService;
import com.hr.org.organization.orgPersonSta.OrgPersonStaService;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(value="/api/v5/emp")
public class ApiEmpController {

    @Inject
    @Named("AuthTableService")
    private AuthTableService authTableService;

    @Inject
    @Named("EmployeeService")
    private EmployeeService employeeService;

    @Inject
    @Named("ComService")
    private ComService comService;

    @Inject
    @Named("OrgPersonStaService")
    private OrgPersonStaService orgPersonStaService;

    @Inject
    @Named("OtherService")
    private OtherService otherService;

    @Inject
    @Named("PsnalPostService")
    private PsnalPostService psnalPostService;

    @Inject
    @Named("PsnalCareerService")
    private PsnalCareerService psnalCareerService;

    @Inject
    @Named("PsnalSchoolService")
    private PsnalSchoolService psnalSchoolService;

    @Inject
    @Named("PerPayPartiTermUStaService")
    private PerPayPartiTermUStaService perPayPartiTermUStaService;

    @Inject
    @Named("PsnalContactService")
    private PsnalContactService psnalContactService;

    /**
     * 자동검색 조회
     *
     * @param session
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getEmployeeList")
    public Map<String, Object> getEmployeeList(HttpSession session, @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();

        String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();
        String ssnLocaleCd = session.getAttribute("ssnLocaleCd").toString();
        String ssnSabun = session.getAttribute("ssnSabun").toString();

        paramMap.put("ssnEnterCd",		ssnEnterCd);
        paramMap.put("ssnLocaleCd",		ssnLocaleCd);
        paramMap.put("ssnSabun",		ssnSabun);

        Log.Debug(session.getAttribute("ssnSearchType").toString());
        Log.Debug(session.getAttribute("ssnGrpCd").toString());

        paramMap.put("ssnSearchType",	paramMap.get("searchEmpType").toString().equals("T") ?   "A": session.getAttribute("ssnSearchType"));
        paramMap.put("ssnGrpCd",		paramMap.get("searchEmpType").toString().equals("T") ?  "10": session.getAttribute("ssnGrpCd"));
        paramMap.put("ssnBaseDate", 	session.getAttribute("ssnBaseDate"));
        paramMap.put("authSqlID",		"THRM151");

        paramMap.put("ssnAdminYn",		session.getAttribute("ssnAdminYn"));
        paramMap.put("ssnEnterAllYn",	session.getAttribute("ssnEnterAllYn"));
        paramMap.put("ssnPreSrchYn",	session.getAttribute("ssnPreSrchYn"));
        paramMap.put("ssnRetSrchYn",	session.getAttribute("ssnRetSrchYn"));
        paramMap.put("ssnResSrchYn",	session.getAttribute("ssnResSrchYn"));

        Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
        if(query != null) {
            //Log.Debug("query.get=> "+ query.get("query"));
            paramMap.put("query",query.get("query"));
        }

        List<?> list = employeeService.employeeList(paramMap);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        Log.DebugEnd();
        return result;
    }

    /**
     * getPsnalContactUserList 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getPsnalContactUserList")
    public Map<String, Object> getPsnalContactUserList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = psnalContactService.getPsnalContactUserList(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);
        Log.DebugEnd();
        return result;
    }

    /**
     * getPsnalContactAddressList 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getPsnalContactAddressList")
    public Map<String, Object> getPsnalContactAddressList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = psnalContactService.getPsnalContactAddressList(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);
        Log.DebugEnd();
        return result;
    }

    /**
     * 자동검색 조회
     *
     * @param session
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getSearchMenuList")
    public Map<String, Object> getSearchMenuList(HttpSession session, @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        //임직원공통일때 사번은 본인으로 제한
        if( session.getAttribute("ssnGrpCd").equals("99") ) {
            String chkSabun = (String)session.getAttribute("ssnSabun");
            String paramSabun =  StringUtil.stringValueOf(paramMap.get("sabun"));
            if(!paramSabun.equals("")) {

                Log.Debug("//임직원공통일때 사번은 본인으로 제한");
                Log.Debug("GetDataList paramMap==> {}", paramMap);

                paramSabun = paramSabun.equals(chkSabun) ? paramSabun : chkSabun;
                paramMap.put("sabun",paramSabun);
            }
        }

        Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
        //Log.Debug("query.get=> {}", query.get("query"));
        paramMap.put("query", query == null ? null:query.get("query"));

        List<?> list = new ArrayList<Object>();
        String Message = "";

        paramMap.put("cmd", "getSearchMenuLayerList");
        try{
            list = comService.getDataList(paramMap);
//            list = subService.getSearchMenuList(paramMap);
        }catch(Exception e){
            Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
            Log.Debug(Message);
        }
        Log.DebugEnd();

        Map<String, Object> result = new HashMap<>();
        if(list != null) {
            result.put("list", list);
        }else{
            result.put("Message", Message);
        }

        return result;
    }

    /**
     * orgCdMgr 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getOrgPersonStaList")
    public Map<String, Object> getOrgPersonStaList(HttpSession session,
      HttpServletRequest request,HttpServletResponse response,
      @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<Map<String, Object>> list  = new ArrayList<Map<String, Object>>();
        String Message = "";
        try{
            list = (List<Map<String, Object>>) orgPersonStaService.getOrgPersonStaList(paramMap);

            //하위 트리 필드 set
            int i = 0;
            for(Map<String, Object> org : list){
                list.get(i).put("children", new ArrayList<>());
                list.get(i).put("childCnt", 0);
                i++;
            }
//            for(Map<String, Object> org : list){
//                Log.Debug(org.toString());
//                paramMap.put("searchOrgCd", org.get("orgCd"));
//                List<?> personList  = orgPersonStaService.getOrgPersonStaMeberList1(paramMap);
//                Object[] obj = {personList};
//                if(personList.size() > 0){
//                    list.get(i).put("children", obj);
//                }else {
//                    list.get(i).put("children", new ArrayList<>());
//                }
//                i++;
//            }
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);
        Log.DebugEnd();
        return result;
    }

    /**
     * orgCdMgr 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getOrgPersonStaMeberList")
    public Map<String, Object> getOrgPersonStaMeberList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = orgPersonStaService.getOrgPersonStaMeberList1(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);
        Log.DebugEnd();
        return result;
    }

    /**
     * Employee의 정보  조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getEmployeeDataMap")
    public Map<String, Object> getEmployeeDataMap(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        String ssnLocaleCd = (String)session.getAttribute("ssnLocaleCd");
        paramMap.put("ssnLocaleCd", ssnLocaleCd);
        paramMap.put("searchViewNm", "인사_인사기본_기준일");
        Map<?, ?> map = null;
        String Message = "";

        String viewQuery = otherService.getViewQuery(paramMap);
        paramMap.put("selectViewQuery", viewQuery);

        try{
            Map<?, ?> hmap  = employeeService.getEmployeeHeaderColDataMap(paramMap);
            if (hmap != null) {
                paramMap.put("selectColumn", hmap.get("selectColumn"));
            } else {
                paramMap.put("selectColumn", null);
            }
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        try{
            map = employeeService.getEmployeeHeaderDataMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("DATA", map);
        result.put("Message", Message);

        Log.DebugEnd();
        return result;
    }

    /**
     * psnalPost 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getPsnalPostList")
    public Map<String, Object> getPsnalPostList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = psnalPostService.getPsnalPostList(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        Map<String, Object> result = new HashMap<>();
        result.put("DATA", list);
        result.put("Message", Message);
        Log.DebugEnd();

        return result;
    }

    /**
     * getPsnalCareerList 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getPsnalCareerList")
    public Map<String, Object> getPsnalCareerList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = psnalCareerService.getPsnalCareerList(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("DATA", list);
        result.put("Message", Message);
        Log.DebugEnd();

        return result;
    }

    /**
     * psnalSchool 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getPsnalSchoolList")
    public Map<String, Object> getPsnalSchoolList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = psnalSchoolService.getPsnalSchoolList(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("DATA", list);
        result.put("Message", Message);
        Log.DebugEnd();

        return result;
    }

    /**
     * perPayPartiTermUSta 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getPerPayPartiTermUStaList")
    public Map<String, Object> getPerPayPartiTermUStaList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("searchSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
//            list = payBankPopupService.getPayDayUserPopupList(paramMap);
//            tmpPayYmFrom}, '-', '') AND REPLACE(#{tmpPayYmTo
            list = perPayPartiTermUStaService.getPerPayPartiTermUStaList(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        Log.DebugEnd();
        return result;
    }

}
