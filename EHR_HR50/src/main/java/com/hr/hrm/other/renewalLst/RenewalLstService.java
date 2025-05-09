package com.hr.hrm.other.renewalLst;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 갱신예정기한 Service
 *
 * @author 이름
 *
 */
@Service("RenewalLstService")
public class RenewalLstService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 갱신예정기한 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRenewalLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRenewalLstList", paramMap);
	}
	/**
	 *  갱신예정기한 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getRenewalLstMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getRenewalLstMap", paramMap);
	}
	/**
	 * 갱신예정기한 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRenewalLst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRenewalLst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRenewalLst", convertMap);
		}
		
		return cnt;
	}
	/**
	 * 갱신예정기한 생성 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertRenewalLst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.create("insertRenewalLst", paramMap);
	}
	/**
	 * 갱신예정기한 수정 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateRenewalLst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updateRenewalLst", paramMap);
	}
	/**
	 * 갱신예정기한 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteRenewalLst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();



		int cnt = 0;

		// TBEN751 갱신예정기한(TBEN751)
		cnt = dao.delete("deleteRenewalLstFirst", paramMap);

		// THRI103 신청서마스터
		cnt += dao.delete("deleteRenewalLstSecond", paramMap);

		return cnt;
	}
}