package com.hr.sys.psnalInfoPop.psnalBasicPop;
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
@Service("PsnalBasicPopService")
public class PsnalBasicPopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근무지 코드 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalBasicPopLocationCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalBasicPopLocationCodeList", paramMap);
	}
}