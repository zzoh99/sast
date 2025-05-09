package com.hr.cpn.yjungsan.befYearEtcMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class BefYearEtcMgrService {
    @Autowired
    private Dao dao;
    public List<?> getBefYearEtcMgrList(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getBefYearEtcMgrList", paramMap);
    }
}
