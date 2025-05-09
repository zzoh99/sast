package com.hr.sys.layout.layoutMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("LayoutMgrService")
public class LayoutMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 권한별 등록된 레이아웃 개수 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLayoutMgrCount(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLayoutMgrCount", paramMap);
	}
}