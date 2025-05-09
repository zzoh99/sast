package com.hr.ben.meetRoom.meetRoomMgr;
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
@Service("MeetRoomMgrService")
public class MeetRoomMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

    /**
    * 회의실관리 조회
    * */
    public List<?> getMeetRoomMgrList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>)dao.getList("getMeetRoomMgrList", paramMap);
    }
    
    
	/**
	 * 회의실관리 저장
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMeetRoomMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0) {
		    cnt += dao.delete("deleteMeetRoomMgr", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0) {
		    cnt += dao.update("saveMeetRoomMgr", convertMap);
		}
		return cnt;
	}

	 /**
     * 회의실관리 삭제
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int deleteMeetRoomMgr(Map<String, Object> convertMap) throws Exception {
         Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){

        }

        return cnt;
    }
}