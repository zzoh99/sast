package com.hr.ben.meetRoom.meetRoomApp;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 회의실신청 Service
 *
 * @author kwook
 *
 */
@Service("MeetRoomAppService")
public class MeetRoomAppService{
    @Inject
    @Named("Dao")
    private Dao dao;
    
    /**
    * 회의실신청 조회
    * */
    public List<?> getMeetRoomAppList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>)dao.getList("getMeetRoomAppList", paramMap);
    }
    
    /**
    * 회의실신청 삭제
    *
    * @param convertMap
    * @return int
    * @throws Exception
    */
    public int deleteMeetRoomApp(Map<String, Object> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteMeetRoomApp", convertMap);
            dao.delete("deleteApprovalMgrMaster", convertMap);
            dao.delete("deleteApprovalMgrAppLine", convertMap);
        }

        return cnt;
    }
    
    /**
    * 회의실 스케줄
    * 
    * @param convertMap
    * @return int
    * @throws Exception
    */
    public List<?>  getMeetRoomSchedule(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return  (List<?>) dao.getList("getMeetRoomSchedule", paramMap);
    }
    
    /**
    * 회의실 스케줄상세
    * 
    * @param convertMap
    * @return int
    * @throws Exception
    */
    public List<?> getMeetRoomScheduleDetail(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return  (List<?>) dao.getList("getMeetRoomScheduleDetail", paramMap);
    }
    
    /**
    * 회의실 단건
    * 
    * @param convertMap
    * @return int
    * @throws Exception
    */
    public  Map<?, ?> getMeetRoomAppDetMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return dao.getMap("getMeetRoomAppDetMap", paramMap);
    }
    
    /**
    * 회의실 상세정보
    * 
    * @param convertMap
    * @return int
    * @throws Exception
    */
    public Map<?, ?> getMeetRoomInfo(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return dao.getMap("getMeetRoomInfo", paramMap);
    }
    
    /**
    * 회의실 이용가능정보
    * 
    * @param convertMap
    * @return int
    * @throws Exception
    */
    public List<?> getEnableMeetRoomApp(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getEnableMeetRoomApp", paramMap);
    }
    
    /**
     * 회의실신청 저장
     *
     * @param paramMap
     * @return int
     * @throws Exception
     */
    public int saveMeetRoomAppDet(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt = 0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0) {
            // First. 회의실신청 내역 삭제
            cnt += dao.delete("deleteMeetRoomAppDet", convertMap);
            // Second. 신청내역 삭제
            cnt += dao.delete("deleteApprovalMgrMaster", convertMap);
        }

        if( ((List<?>)convertMap.get("mergeRows")).size() > 0) {
            // First. 회의실신청 내역 저장.
            cnt += dao.update("saveMeetRoomAppDet", convertMap);
            // Second. 신청내역 저장.
            //cnt += dao.update("updateApprovalStatus", convertMap);
        }
        return cnt;
    }

    public List<?> getMeetRoomCdList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return  (List<?>) dao.getList("getMeetRoomCdList", paramMap);
    }
}