package com.hr.api.common.service;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.com.ComService;
import com.hr.common.dao.Dao;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


@Service("ApiComService")
public class ApiComService {

    @Inject
    @Named("Dao")
    private Dao dao;

    @Autowired
    @Qualifier("ComService")
    private ComService comService;

    @Autowired
    @Qualifier("AuthTableService")
    private AuthTableService authTableService;

    /**
     * 로그인 정보 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public Map<?,?> getMobileToken(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (Map<?,?>)dao.getMap("getMobileToken", paramMap);
    }

    public List<?> getDataList(Map<String, Object> paramMap, HttpSession session) throws Exception {
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

        try{
            list = comService.getDataList(paramMap);
        }catch(Exception e){
            Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
            Log.Debug(Message);
        }

        Log.DebugEnd();
        return list;
    }

}