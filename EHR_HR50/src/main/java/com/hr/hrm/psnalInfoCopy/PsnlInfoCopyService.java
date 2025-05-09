package com.hr.hrm.psnalInfoCopy;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 인사정보 복사 Service
 *
 * @author 이름
 *
 */
@Service("PsnlInfoCopyService")
public class PsnlInfoCopyService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 인사정보 복사 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlInfoCopyList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnlInfoCopyList", paramMap);
	}

	/**
	 * 인사정보 복사 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnlInfoCopy(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)paramMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnlInfoCopy", paramMap);
		}
		if( ((List<?>)paramMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnlInfoCopy", paramMap);
		}
		return cnt;
	}

	/**
	 * 인사정보 복사 복사실행 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcPsnlInfoCopySave(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcPsnlInfoCopySave", paramMap);
	}

	/**
	 * 인사정보 복사 복사취소 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcPsnlInfoCopyCancel(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcPsnlInfoCopyCancel", paramMap);
	}
}