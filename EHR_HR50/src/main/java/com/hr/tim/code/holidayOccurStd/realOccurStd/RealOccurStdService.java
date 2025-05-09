package com.hr.tim.code.holidayOccurStd.realOccurStd;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 휴가 발생조건 Service
 *
 * @author bckim
 *
 */
@Service("RealOccurStdService")
public class RealOccurStdService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 휴가 발생조건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRealOccurStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRealOccurStdList", paramMap);
	}

	/**
	 * 휴가 발생조건 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRealOccurStd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRealOccurStd", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRealOccurStd", convertMap);
		}
		
		return cnt;
	}
}