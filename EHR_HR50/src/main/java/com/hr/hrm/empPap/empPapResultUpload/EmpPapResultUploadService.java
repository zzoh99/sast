package com.hr.hrm.empPap.empPapResultUpload;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * JobKnowledgePopup Service
 *
 * @author jy
 *
 */
@Service("EmpPapResultUploadService")
public class EmpPapResultUploadService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * JobKnowledgePopup 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpPapResultUpload(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpPapResultUpload", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpPapResultUpload", convertMap);
		}

		return cnt;
	}
}
