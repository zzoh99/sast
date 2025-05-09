package com.hr.tim.code.workTimeMgr;

import com.google.gson.Gson;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 근무시간코드설정 Service
 *
 * @author jtshin
 *
 */
@Service("WorkTimeMgrService")
public class WorkTimeMgrService {

    @Inject
    @Named("Dao")
    private Dao dao;


    /**
     * workTimeMgr 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getWorkTimeMgrList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getWorkTimeMgrList", paramMap);
    }

    /**
     * workTimeMgr 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getWorkTimeMgrStdHourList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getWorkTimeMgrStdHourList", paramMap);
    }

    /**
     * workTimeMgr 단건 조회 Service
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> getWorkTimeMgrMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getWorkTimeMgrMap", paramMap);
        Log.Debug();
        return resultMap;
    }

    /**
     * 근무시간코드설정 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveWorkTimeMgr(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            dao.delete("deleteWorkTimeMgrWorkTeamAll", convertMap);
            dao.delete("deleteWorkTimeMgrStdHour", convertMap);
            dao.delete("deleteWorkTimeMgrWorkGrp", convertMap);
            dao.delete("deleteWorkTimeMgrPatten", convertMap);
            cnt += dao.delete("deleteWorkTimeMgr", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveWorkTimeMgr", convertMap);
        }
        Log.Debug();
        return cnt;
    }

    /**
     * 예외인정근무시간 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveWorkTimeMgrStdHour(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteWorkTimeMgrStdHour", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveWorkTimeMgrStdHour", convertMap);
        }
        Log.Debug();
        return cnt;
    }


    /**
     * 일일근무스케쥴 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveWorkDaySchedule(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteWorkDaySchedule", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveWorkDaySchedule", convertMap);
        }

        return cnt;
    }
}
