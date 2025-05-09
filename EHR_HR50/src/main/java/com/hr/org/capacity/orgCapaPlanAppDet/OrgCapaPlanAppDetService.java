package com.hr.org.capacity.orgCapaPlanAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 인력충원요청신청 Service
 *
 * @author bckim
 *
 */
@Service("OrgCapaPlanAppDetService")
public class OrgCapaPlanAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 인력충원요청신청 단건 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map getOrgCapaPlanAppDetMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map)dao.getMap("getOrgCapaPlanAppDetMap", paramMap);
	}

	/**
	 * 인력충원요청신청(현재인원) 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map getOrgCntMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map)dao.getMap("getOrgCntMap", paramMap);
	}

	/**
	 *  인력충원요청신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgCapaPlanAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		cnt += dao.update("saveOrgCapaPlanAppDet", convertMap);
		Log.Debug();
		return cnt;
	}


	/* 인력충원요청 삭제 HR 4.0 이관 START */
	/**
	 * 인력충원요청신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgCapaPlanAppDet1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		cnt += dao.update("deleteOrgCapaPlanAppDet1", convertMap);
		cnt += dao.update("saveOrgCapaPlanAppDet1", convertMap);

		Log.Debug();
		return cnt;
	}

	/**
	 * 인력충원요청신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgCapaPlanAppDet2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		cnt += dao.update("deleteOrgCapaPlanAppDet2", convertMap);
		cnt += dao.update("saveOrgCapaPlanAppDet2", convertMap);

		Log.Debug();
		return cnt;
	}

	public List<?> getjobCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getjobCodeList", paramMap);
	}
	/* 인력충원요청 삭제 HR 4.0 이관 END */

}