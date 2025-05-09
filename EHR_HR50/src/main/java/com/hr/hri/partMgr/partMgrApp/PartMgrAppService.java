package com.hr.hri.partMgr.partMgrApp;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class PartMgrAppService {

    @Autowired
    private Dao dao;

    public List<?> getPartMgrAppList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPartMgrAppList", paramMap);
    }

    public int deletePartMgrApp(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deletePartMgrApp", convertMap);
        }

        return cnt;
    }

    public List<?> getPartMgrAppCurEmpList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPartMgrAppCurEmpList", paramMap);
    }

    public List<?> getPartMgrAppOrgCd(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPartMgrAppOrgCd", paramMap);
    }
}

