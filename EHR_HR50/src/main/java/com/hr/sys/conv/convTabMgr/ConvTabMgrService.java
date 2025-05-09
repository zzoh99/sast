package com.hr.sys.conv.convTabMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 이관테이블관리 Service
 *
 * @author bckim
 *
 */
@Service("ConvTabMgrService")
public class ConvTabMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 이관테이블관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getConvTabMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getConvTabMgrList", paramMap);
	}

	/**
	 * 이관테이블관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveConvTabMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteConvTabMgr1", convertMap);
			cnt += dao.delete("deleteConvTabMgr2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveConvTabMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 이관테이블관리(이관테이블 생성) 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcConvTabMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcConvTabMgr", paramMap);
	}

	/**
	 * 이관테이블관리(이관테이블 생성) 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcConvTabMgrApp(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcConvTabMgrApp", paramMap);
	}

}