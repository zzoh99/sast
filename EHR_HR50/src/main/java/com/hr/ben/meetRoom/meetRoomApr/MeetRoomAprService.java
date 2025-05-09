package com.hr.ben.meetRoom.meetRoomApr;
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
@Service("MeetRoomAprService")
public class MeetRoomAprService{
    @Inject
    @Named("Dao")
    private Dao dao;

    /**
    * 회의실신청 조회
    * */
    public List<?> getMeetRoomAprList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>)dao.getList("getMeetRoomAprList", paramMap);
    }
    
    /**
     * 회의실신청 저장
     *
     * @param paramMap
     * @return int
     * @throws Exception
     */
    public int saveMeetRoomApr(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt = 0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0) {
            // First. 회의실승인 내역 삭제
            cnt += dao.delete("deleteMeetRoomApr", convertMap);
            // Second. 신청내역 삭제
            cnt += dao.delete("deleteApprovalMgrMaster", convertMap);
        }

        if( ((List<?>)convertMap.get("mergeRows")).size() > 0) {
            // First. 회의실승인 내역 저장.
            cnt += dao.update("saveMeetRoomApr", convertMap);
            // Second. 신청내역 저장.
            //cnt += dao.update("updateApprovalStatus", convertMap);
        }
        return cnt;
    }
}