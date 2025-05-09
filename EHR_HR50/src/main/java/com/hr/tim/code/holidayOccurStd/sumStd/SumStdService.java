package com.hr.tim.code.holidayOccurStd.sumStd;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 휴가 연차휴가사용집계기준 Service
 *
 * @author bckim
 *
 */
@Service("SumStdService")
public class SumStdService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 휴가 연차휴가사용집계기준 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSumStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSumStdList", paramMap);
	}

	/**
	 * 휴가 연차휴가사용집계기준 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSumStd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSumStd", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSumStd", convertMap);
		}
		
		return cnt;
	}
}