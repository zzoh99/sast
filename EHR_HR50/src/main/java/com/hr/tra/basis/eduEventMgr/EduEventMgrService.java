package com.hr.tra.basis.eduEventMgr;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 교육회차관리 Service
 *
 * @author JSG
 *
 */
@Service("EduEventMgrService")
public class EduEventMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 교육회차관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduEventMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduEventMgrList", paramMap);
	}

	/**
	 *  교육회차관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduEventMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduEventMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduEventMgr", convertMap);
		}

		return cnt;
	}

	/**
	 *  교육회차관리 다건 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduEventMgrSheet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduEventMgrSheet", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduEventMgrSheet", convertMap);
		}

		return cnt;
	}

	/**
	 * 교육회차관리 강사내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduEventLecturerPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduEventLecturerPopupList", paramMap);
	}

	/**
	 * 교육회차관리 강사내역 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduEventLecturerPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduEventLecturerPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduEventLecturerPopup", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 교육회차관리 강사선택팝업 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduEventLecturerNmPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduEventLecturerNmPopupList", paramMap);
	}
}