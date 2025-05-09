package com.hr.ben.carAllocate.carAllocateApp;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 업무차량배차신청 Service
 *
 * @author kwook
 *
 */
@Service("CarAllocateAppService")
public class CarAllocateAppService{
    @Inject
    @Named("Dao")
    private Dao dao;
    
    /**
    * 업무차량배차신청 조회
    * */
    public List<?> getCarAllocateAppList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>)dao.getList("getCarAllocateAppList", paramMap);
    }
    
    /**
    * 업무차량배차 코드 조회
    * */
    public List<?> getCarAllocateCdList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>)dao.getList("getCarAllocateCdList", paramMap);
    }
    
    /**
    * 업무차량배차신청 삭제
    *
    * @param convertMap
    * @return int
    * @throws Exception
    */
    public int deleteCarAllocateApp(Map<String, Object> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteCarAllocateApp", convertMap);
            dao.delete("deleteApprovalMgrMaster", convertMap);
            dao.delete("deleteApprovalMgrAppLine", convertMap);
        }

        return cnt;
    }
    
    /**
    * 업무차량배차 스케줄
    * 
    * @param convertMap
    * @return int
    * @throws Exception
    */
    public List<?> getCarAllocateSchedule(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return  (List<?>)dao.getList("getCarAllocateSchedule", paramMap);
    }
    
    /**
    * 업무차량배차 스케줄상세
    * 
    * @param convertMap
    * @return int
    * @throws Exception
    */
    public List<?> getCarAllocateScheduleDetail(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getCarAllocateScheduleDetail", paramMap);
    }
    
    /**
    * 업무차량배차 단건
    * 
    * @param convertMap
    * @return int
    * @throws Exception
    */
    public  Map<?, ?> getCarAllocateAppDetMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return dao.getMap("getCarAllocateAppDetMap", paramMap);
    }
    
    /**
    * 업무차량배차 상세정보
    * 
    * @param convertMap
    * @return int
    * @throws Exception
    */
    public Map<?, ?> getCarAllocateInfo(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return dao.getMap("getCarAllocateInfo", paramMap);
    }
    
    /**
    * 업무차량배차 이용가능정보
    * 
    * @param convertMap
    * @return int
    * @throws Exception
    */
    public List<?> getEnableCarAllocateApp(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getEnableCarAllocateApp", paramMap);
    }
    
    /**
     * 업무차량배차신청 저장
     *
     * @param paramMap
     * @return int
     * @throws Exception
     */
    public int saveCarAllocateAppDet(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt = 0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0) {
            // First. 업무차량배차신청 내역 삭제
            cnt += dao.delete("deleteCarAllocateAppDet", convertMap);
            // Second. 신청내역 삭제
            cnt += dao.delete("deleteApprovalMgrMaster", convertMap);
        }

        if( ((List<?>)convertMap.get("mergeRows")).size() > 0) {
            // First. 업무차량배차신청 내역 저장.
            cnt += dao.update("saveCarAllocateAppDet", convertMap);
            // Second. 신청내역 저장.
           // cnt += dao.update("updateApprovalStatus", convertMap);
        }
        return cnt;
    }
}