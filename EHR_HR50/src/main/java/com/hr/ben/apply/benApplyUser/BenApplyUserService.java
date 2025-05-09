package com.hr.ben.apply.benApplyUser;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 복리후생신청 Service
 *
 * @author 이름
 *
 */
@Service("BenApplyUserService")
public class BenApplyUserService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 복리후생신청 가능한 리스트 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBenApplList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getBenApplList", paramMap);
	}
	public List<?> getBenAppCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getBenAppCodeList", paramMap);
	}


}