package com.hr.hrm.psnalInfo.psnalEdu;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 인사기본(교육) Service
 *
 * @author 이름
 *
 */
@Service("PsnalEduService")
public class PsnalEduService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 인사기본(교육) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalEduList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalEduList", paramMap);
	}

	/**
	 * 인사기본(이수학점) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
/*	public Map<?,?> getPsnalEduScore(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap("getPsnalEduScore", paramMap);
	}*/
}