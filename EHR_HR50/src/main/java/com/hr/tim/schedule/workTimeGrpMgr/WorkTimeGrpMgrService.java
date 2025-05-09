package com.hr.tim.schedule.workTimeGrpMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("WorkTimeGrpMgrService")
public class WorkTimeGrpMgrService {

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 근무그룹관리 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getWorkPattenMgrGrpList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getWorkPattenMgrGrpList", paramMap);
    }

    /**
     * 근무그룹관리 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getWorkPattenMgrTimeGrp(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getWorkPattenMgrTimeGrp", paramMap);
    }


    /**
     * 근무그룹관리 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveWorkPattenMgrGrp(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( !((List<?>)convertMap.get("deleteRows")).isEmpty()){
            cnt += dao.delete("deleteWorkPattenMgrGrp", convertMap);
        }
        if( !((List<?>)convertMap.get("mergeRows")).isEmpty()){
            cnt += dao.update("saveWorkPattenMgrGrp", convertMap);
        }

        return cnt;
    }

    /**
     * 근무그룹관리 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveWorkPattenMgrTimeGrp(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( !((List<?>)convertMap.get("deleteRows")).isEmpty()){
            cnt += dao.delete("deleteWorkPattenMgrTimeGrp", convertMap);
        }
        if( !((List<?>)convertMap.get("mergeRows")).isEmpty()){
            cnt += dao.update("saveWorkPattenMgrTimeGrp", convertMap);
        }

        return cnt;
    }


    /**
     * 근무시간표 조건 조회 Service
     *
     * @param paramMap
     * @return int
     * @throws Exception
     */
    public List<?> getTimeCdList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>)dao.getList(paramMap.get("queryId").toString(), paramMap);
//        return (List<?>)dao.getList("getWorkOrgTimeCdList", paramMap);
    }

}
