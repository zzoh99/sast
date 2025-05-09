package com.hr.eis.hrm.yearEmpSta;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service
public class YearEmpStaService {
    @Inject
    @Named("Dao")
    private Dao dao;

    public List<?> getYearEmpStaList2(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getYearEmpStaList2", paramMap);
    }

    public int saveAppGradeTableMgr(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteAppGradeTableMgr", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveAppGradeTableMgr", convertMap);
        }

        return cnt;
    }

    public List<?> getPayComCode(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPayComCode", paramMap);
    }

    public List<?> getYearEmpStaList33(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getYearEmpStaList33", paramMap);
    }
}
