package com.hr.sys.psnalInfoPop.psnalPostPop;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 인사기본(발령)) Service
 *
 * @author 이름
 *
 */
@Service("PsnalPostPopService")
public class PsnalPostPopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 인사기본(발령) 발령형태 콤보 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalPostPopAppmtCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalPostPopAppmtCodeList", paramMap);
	}

	/**
	 * 인사기본(발령 세부내역) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getPsnalPostPop2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap("getPsnalPostPop2", paramMap);
	}

}