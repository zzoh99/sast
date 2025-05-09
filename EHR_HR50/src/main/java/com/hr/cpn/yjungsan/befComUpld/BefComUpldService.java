package com.hr.cpn.yjungsan.befComUpld;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class BefComUpldService {

    @Autowired
    private Dao dao;
    public List<?> getBefComUpldList(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getBefComUpldList", paramMap);
    }

    public int saveBefComUpld(Map<String, Object> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;

        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteBefComUpld", convertMap);
        }

        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveBefComUpld", convertMap);
        }

        Log.Debug();
        return cnt;
    }
}
