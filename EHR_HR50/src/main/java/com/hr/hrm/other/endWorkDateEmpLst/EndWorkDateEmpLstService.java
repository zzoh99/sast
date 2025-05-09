package com.hr.hrm.other.endWorkDateEmpLst;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class EndWorkDateEmpLstService {

    @Autowired
    private Dao dao;

    public List<?> getEndWorkDateEmpLstList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getEndWorkDateEmpLstList", paramMap);
    }
}
