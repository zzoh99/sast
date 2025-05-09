package com.hr.hri.partMgr.partMgrAppDet;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class PartMgrAppDetService {

    @Autowired
    private Dao dao;

    public Map<?, ?> getPartMgrAppDet(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getPartMgrAppDet", paramMap);
        Log.Debug();
        return resultMap;
    }

    public Map<?, ?> getPartMgrAppDetCurEmp(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getPartMgrAppDetCurEmp", paramMap);
        Log.Debug();
        return resultMap;
    }

}
