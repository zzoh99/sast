package com.hr.cpn.yjungsan.common;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class CommonTaxService {

    @Autowired
    private Dao dao;

    public Map<?,?> getTaxYn(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getTaxYn", paramMap);
        return resultMap;
    }
}
