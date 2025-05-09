package com.hr.hrm.psnalInfo.psnalBasic;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 인사기본(기본탭) Service
 *
 * @author 이름
 *
 */
@Service("PsnalBasicService")
public class PsnalBasicService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 인사기본(기본탭) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalBasicList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalBasicList", paramMap);
	}

	/**
	 * 인사기본(인사정보 복사) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalBasicCopyPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalBasicCopyPopList", paramMap);
	}


	/**
	 * 인사기본(기본탭) 수정 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updatePsnalBasic(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;

		cnt = dao.update("updatePsnalBasic", paramMap);

		return cnt;
	}

	/**
	 * 인사기본(인사정보복사팝업) - 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcPsnalBasicCopy(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcPsnalBasicCopy", paramMap);
	}

	public Map<?, ?> getPsnalBasic(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalBasic", paramMap);
		return resultMap;
	}

    public List<?> getPsnalTimeLineList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalTimeLineList", paramMap);
    }
}