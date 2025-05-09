package com.hr.ben.carAllocate.carAllocateApr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 업무차량 배차승인 Service
 *
 * @author kwook
 *
 */
@Service("CarAllocateAprService")
public class CarAllocateAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
    /**
    * 업무차량 배차 승인 조회
    * */
    public List<?> getCarAllocateAprList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>)dao.getList("getCarAllocateAprList", paramMap);
    }
    
	/**
	 * 업무차량 배차승인 저장
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCarAllocateApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0) {
			// First. 업무차량배차승인 내역 삭제
			cnt += dao.delete("deleteCarAllocateApr", convertMap);
			// Second. 신청내역 삭제
			cnt += dao.delete("deleteApprovalMgrMaster", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0) {
			// First. 업무차량배차승인 내역 저장.
			cnt += dao.update("saveCarAllocateApr", convertMap);
			// Second. 신청내역 저장.
			//cnt += dao.update("updateApprovalStatus", convertMap);
		}
		return cnt;
	}
}