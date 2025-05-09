package com.hr.hrm.psnalInfo.psnalBasicUserConfig;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.Map;

/**
 * 인사기본_임직원공통_기본탭 Service
 *
 * @author 이름
 *
 */
@Service("PsnalBasicUserConfigService")
public class PsnalBasicUserConfigService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 인사기본_임직원공통 설정 조회
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getPsnalBasicUserConfigJson(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.getMap("getPsnalBasicUserConfigJson", paramMap);
	}

	/**
	 * 인사기본_임직원공통 설정 저장
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int savePsnalBasicUserConfig(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		dao.update("savePsnalBasicUserConfig", paramMap);
		return dao.update("updatePsnalBasicUserConfigClob", paramMap);
	}
}