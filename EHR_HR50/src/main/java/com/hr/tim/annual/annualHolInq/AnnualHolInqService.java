package com.hr.tim.annual.annualHolInq;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연차확정 Service
 *
 * @author bckim
 *
 */
@Service("AnnualHolInqService")
public class AnnualHolInqService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 연차확정 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnnualHolInqList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnnualHolInqList", paramMap);
	}
	
	/**
	 * 연차확정 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAnnualHolInq(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAnnualHolInq", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAnnualHolInq", convertMap);
		}
		
		return cnt;
	}
	
	/**
	 * 연차확정 전체삭제 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int deleteAnnualHolInqAll(Map<?, ?> paramMap) throws Exception {
		Log.Debug();	
		int cnt=0;
		cnt += dao.delete("deleteAnnualHolInqAll", paramMap);
		return cnt;
	
	}
	
	
	
}