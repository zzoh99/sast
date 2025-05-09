package com.hr.cpn.perExpense.leaveRewardMonSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 차년도휴가보상비조회 Service
 *
 * @author EW
 *
 */
@Service("LeaveRewardMonStaService")
public class LeaveRewardMonStaService{

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 차년도휴가보상비조회 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getLeaveRewardMonStaList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getLeaveRewardMonStaList", paramMap);
    }

    /**
     * 차년도휴가보상비조회 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveLeaveRewardMonSta(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteLeaveRewardMonSta", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveLeaveRewardMonSta", convertMap);
        }

        return cnt;
    }
}
