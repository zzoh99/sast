package com.hr.cpn.personalPay.perPayEleGroupMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 텍스트파일생성목록 Service
 * 
 * @author 이름
 *
 */
@Service("PerPayYearEleGroupMgrService")  
public class PerPayYearEleGroupMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 텍스트파일생성목록 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayYearEleGroupMgrListFirst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerPayYearEleGroupMgrListFirst", paramMap);
	}

	/**
	 * 텍스트파일생성목록 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerPayYearEleGroupMgrFirst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePerPayYearEleGroupMgrFirst", convertMap);
			cnt += dao.delete("deletePerPayYearEleGroupMgrSecondCasCading", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePerPayYearEleGroupMgrFirst", convertMap);
		}
		Log.Debug();
		return cnt;
	}

    public List<?> getPerPayYearEleGroupMgrListSecond(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPerPayYearEleGroupMgrListSecond", paramMap);
    }

    public int savePerPayYearEleGroupMgrSecond(Map convertMap) throws Exception {
        Log.Debug();
        int cnt = 0;
        if (((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deletePerPayYearEleGroupMgrSecond", convertMap);
        }
        if (((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("savePerPayYearEleGroupMgrSecond", convertMap);
        }

        return cnt;
    }
}