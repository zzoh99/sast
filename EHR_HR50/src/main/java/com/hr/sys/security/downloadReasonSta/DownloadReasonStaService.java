package com.hr.sys.security.downloadReasonSta;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 파일다운로드 사유 현황 Service
 * @author gjyoo
 *
 */
@Service("DownloadReasonStaService")
public class DownloadReasonStaService {
	
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 임시비밀번호 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getDownloadReasonStaTempPasswd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getDownloadReasonStaTempPasswd", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 파일다운로드 사유 현황 등록 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertDownloadReasonSta(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("insertDownloadReasonSta", paramMap);
		return cnt;
	}
}
