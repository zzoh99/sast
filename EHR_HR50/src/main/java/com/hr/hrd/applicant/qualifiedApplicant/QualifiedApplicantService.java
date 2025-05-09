package com.hr.hrd.applicant.qualifiedApplicant;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 근무조관리 Service
 * 
 * @author jcy
 *
 */
@Service("QualifiedApplicantService")
public class QualifiedApplicantService {
	@Inject
	@Named("Dao")
	private Dao dao;


	public List<?> getJobCatCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobCatCodeList", paramMap);
	}

	public int saveEducationYn(Map<?, ?> convertMap) throws Exception {

		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEducationYn", convertMap);
		}

		return cnt;
	}

	public List<?> getQualifiedApplicantList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getQualifiedApplicantList", paramMap);
	}

	public List<?> getQualifiedApplicantOCList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getQualifiedApplicantOCList", paramMap);
	}

	public List<?> getQualifiedITKList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getQualifiedITKList", paramMap);
	}
	public List<?> getQualifiedITKOCList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getQualifiedITKOCList", paramMap);
	}

	public List<?> getQualifiedApplicantFinalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getQualifiedApplicantFinalList", paramMap);
	}

	
}