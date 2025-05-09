package com.hr.hrm.appmt.recApplicantReg;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("RecApplicantRegService")
public class RecApplicantRegService {

    @Inject
    @Named("Dao")
    private Dao dao;

    public List<?> getRecApplicantRegList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getRecApplicantRegList", paramMap);
    }

    public int saveRecApplicantReg(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteRecApplicantReg", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveRecApplicantReg", convertMap);
        }
        Log.Debug();
        return cnt;
    }
}
