package com.hr.tim.code.holidayOccurStd.useStd;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 휴가 사용기준 Service
 *
 * @author bckim
 *
 */
@Service("UseStdService")
public class UseStdService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 휴가 사용기준 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getUseStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getUseStdList", paramMap);
	}

	/**
	 * 휴가 사용기준 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveUseStd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteUseStd", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveUseStd", convertMap);
		}
		
		return cnt;
	}
}