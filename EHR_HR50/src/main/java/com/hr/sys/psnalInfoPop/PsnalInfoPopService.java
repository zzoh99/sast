package com.hr.sys.psnalInfoPop;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 인사기본 Service
 *
 * @author 이름
 *
 */
@Service("PsnalInfoPopService")
public class PsnalInfoPopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 인사기본 공통 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalInfoPopCommonCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalInfoPopCommonCodeList", paramMap);
	}

	/**
	 * 인사기본 공통 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalInfoPopCommonNSCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList(paramMap.get("queryId").toString(), paramMap);
	}

	/**
	 * 사원검색 상세 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getPsnalInfoPopEmployeeDetail(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPsnalInfoPopEmployeeDetail", paramMap);
	}

	/**
	 * 공통탭 정보 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalInfoPopTabInfoList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalInfoPopTabInfoList", paramMap);
	}
}