package com.hr.cpn.yjungsan.yearEndItemMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import yjungsan.exception.UserException;

import java.util.List;
import java.util.Map;

@Service
public class YearEndItemMgrService {

    @Autowired
    private Dao dao;

    public List<?> getYearEndItemMgrProcess(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getYearEndItemMgrProcess", paramMap);
    }

    public List<?> getYearEndItemMgr(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getYearEndItemMgr", paramMap);
    }

    public Map<?,?> getYearEndItemMgrPopup(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getYearEndItemMgrPopup", paramMap);
        Log.Debug();
        return resultMap;
    }

    public int saveYearEndItemMgrProcess(Map<String, Object> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;

        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteYearEndItemMgrProcess1", convertMap);
            cnt += dao.delete("deleteYearEndItemMgrProcess2", convertMap);
        }

        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveYearEndItemMgrProcess", convertMap);
        }

        Log.Debug();
        return cnt;
    }

    public int saveYearEndItemMgr(Map<String, Object> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;

        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteYearEndItemMgr", convertMap);
        }

        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveYearEndItemMgr", convertMap);
        }

        Log.Debug();
        return cnt;
    }

    public List<?> getYearEndItemMgrPopupSub(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getYearEndItemMgrPopupSub", paramMap);
    }

    public int saveYearEndItemMgrPopupSub(Map<String, Object> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;

        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteYearEndItemMgrPopupSub", convertMap);
        }

        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveYearEndItemMgrPopupSub", convertMap);
        }

        Log.Debug();
        return cnt;
    }
}
