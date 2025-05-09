package com.hr.hrm.other.allExepEmpLst;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class AllExepEmpLstService {

    @Autowired
    private Dao dao;

    public List<?> getAllExepEmpLstList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getAllExepEmpLstList", paramMap);
    }
}
