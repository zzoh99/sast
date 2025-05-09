package com.hr.org.capacity.orgPersonalManageAdmin;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 조직별인력관리(관리자)(\C774\C218) Service
 *
 * @author EW
 *
 */
@Service("OrgPersonalManageAdminService")
public class OrgPersonalManageAdminService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 조직별인력관리(관리자)(\C774\C218) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgPersonalManageAdminList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgPersonalManageAdminList", paramMap);
	}
}
