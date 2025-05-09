package com.hr.sys.psnalInfoPop.psnalEduPop;
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
@Service("PsnalEduPopService")
public class PsnalEduPopService{

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
	public List<?> getPsnalEduPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalEduPopList", paramMap);
	}

	/**
	 * 인사기본(이수학점) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getPsnalEduPopScore(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap("getPsnalEduPopScore", paramMap);
	}
}