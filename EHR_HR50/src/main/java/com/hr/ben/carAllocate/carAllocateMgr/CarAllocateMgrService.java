package com.hr.ben.carAllocate.carAllocateMgr;
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
@Service("CarAllocateMgrService")
public class CarAllocateMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

    /**
    * 업무차량배차관리 조회
    * */
    public List<?> getCarAllocateMgrList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>)dao.getList("getCarAllocateMgrList", paramMap);
    }
    
    
	/**
	 * 업무차량배차관리 저장
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCarAllocateMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0) {
		    cnt += dao.delete("deleteCarAllocateMgr", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0) {
		    cnt += dao.update("saveCarAllocateMgr", convertMap);
		}
		return cnt;
	}

	 /**
     * 업무차량배차관리 삭제
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int deleteCarAllocateMgr(Map<String, Object> convertMap) throws Exception {
         Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){

        }

        return cnt;
    }
}