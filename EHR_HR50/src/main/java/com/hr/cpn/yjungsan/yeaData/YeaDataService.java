package com.hr.cpn.yjungsan.yeaData;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class YeaDataService {

    @Autowired
    private Dao dao;

    public Map<?,?> getYeaDataDefaultInfo(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getYeaDataDefaultInfo", paramMap);
        Log.Debug();
        return resultMap;
    }
}
