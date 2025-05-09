package com.hr.sys.project.atnatMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("AtnatMgrService")
public class AtnatMgrService {

    @Inject
    @Named("Dao")
    private Dao dao;

    public List<?> getAtnatList(Map<String, Object> paramMap) throws Exception {
        return (List<?>) dao.getList("getAtnatList",paramMap);
    }

    public int saveAtnatApp(Map<String, Object> convertMap) throws Exception{
        Log.Debug();
        int cnt=0;
        if(((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveAtnatApp", convertMap);
        }
        return cnt;
    }

    public Map<?, ?> getAtnatAppMap(Map<String, Object> paramMap) throws Exception {
        return (Map<?, ?>) dao.getMap("getAtnatAppMap",paramMap);
    }

    public int deleteAtnatApp(Map<String, Object> convertMap) throws Exception{
        Log.Debug();
        return dao.delete("deleteAtnatApp", convertMap);
    }

    public Map<?, ?> getAtnatAppDupCheck(Map<String, Object> paramMap) throws Exception {
        return (Map<?, ?>) dao.getMap("getAtnatAppDupCheck",paramMap);
    }


}
