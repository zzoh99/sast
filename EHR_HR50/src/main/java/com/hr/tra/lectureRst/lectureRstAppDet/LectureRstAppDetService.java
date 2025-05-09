package com.hr.tra.lectureRst.lectureRstAppDet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 사내교육결과보고신청 세부내역 Service
 */
@Service("LectureRstAppDetService")
public class LectureRstAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 사내교육결과보고신청 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getLectureRstAppDetMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getLectureRstAppDetMap", paramMap);
	}

	/**
	 * 사내교육결과보고신청 중복 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getLectureRstAppDetDupChk(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getLectureRstAppDetDupChk", paramMap);
	}

	/**
	 *  사내교육결과보고신청 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveLectureRstAppDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("saveLectureRstAppDet", paramMap);
	}

	/**
	 *  사내교육결과보고 지급정보 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveLectureRstAppDetAdmin(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteLectureRstAppDetAdmin", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveLectureRstAppDetAdmin", convertMap);
		}

		return cnt;
	}
}