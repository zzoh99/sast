package com.hr.cpn.personalPay.perCarMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class PerCarMgrService {

    @Autowired
    private Dao dao;

    public List<?> getPerCarMgrList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPerCarMgrList", paramMap);
    }
}
