package com.hr.hrm.other.empOrdOrgMoveSrch;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class EmpOrdOrgMoveSrchService {

    @Autowired
    private Dao dao;

    public List<?> getEmpOrdOrgMoveSrchList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getEmpOrdOrgMoveSrchList", paramMap);
    }
}
