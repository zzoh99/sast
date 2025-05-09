package com.hr.sys.project.hmnrsMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("HmnrsMgrService")
public class HmnrsMgrService {

    @Inject
    @Named("Dao")
    private Dao dao;

    public List<?> getHmnrsMgr(Map<?, ?> paramMap) throws Exception {
        return (List<?>) dao.getList("getHmnrsMgr", paramMap);
    }
    public int saveHmnrsMgr(Map<String, Object> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if(((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteHmnrsMgr", convertMap);
        }
        if(((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveHmnrsMgr", convertMap);
        }
        return cnt;
    }

}
