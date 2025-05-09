package com.hr.hri.partMgr.partMgrApr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class PartMgrAprService {

    @Autowired
    private Dao dao;

    public List<?> getPartMgrAprList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPartMgrAprList", paramMap);
    }

    public int updatePartMgrAprThri(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("updatePartMgrAprThri", convertMap);
        }

        return cnt;
    }
}
