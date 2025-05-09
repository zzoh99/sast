package com.hr.cpn.yjungsan.befComMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class BefComMgrService {

    @Autowired
    private Dao dao;

    public List<?> getNoTaxCodeList(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getNoTaxCodeList", paramMap);
    }

    public List<?> getBefComMgr(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getBefComMgr", paramMap);
    }


    public List<?> getBefComMgrNoTax(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getBefComMgrNoTax", paramMap);
    }

    public int saveBefComMgr(Map<String, Object> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;

        if (((List<?>)convertMap.get("deleteRows")).size() > 0) {
            cnt += dao.delete("deleteBefComMgr1", convertMap);
            cnt += dao.delete("deleteBefComMgr2", convertMap);
        }

        if (((List<?>)convertMap.get("mergeRows")).size() > 0) {
            cnt += dao.update("saveBefComMgr", convertMap);
        }

        Log.Debug();
        return cnt;
    }

    public int saveBefComMgrNoTax(Map<String, Object> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;

        if (((List<?>)convertMap.get("deleteRows")).size() > 0) {
            cnt += dao.delete("deleteBefComMgrNoTax", convertMap);
        }

        if (((List<?>)convertMap.get("mergeRows")).size() > 0) {
            cnt += dao.update("saveBefComMgrNoTax", convertMap);
        }

        Log.Debug();
        return cnt;
    }
}
