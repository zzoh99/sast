package com.hr.hrm.other.empStaCompareLst;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * empPictureRegYn Service
 *
 * @author EW
 *
 */
@Service("EmpStaCompareLstService")
public class EmpStaCompareLstService{
	
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public Map callP_HRM_ORG_COMPARE(Map<String, Object> paramMap) throws Exception {
		Log.Debug("callP_HRM_ORG_COMPARE");
		return (Map) dao.excute("callP_HRM_ORG_COMPARE", paramMap);
	}

    public List<?> getEmpStaCompareLst(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getEmpStaCompareLst", paramMap);
    }

    public List<?> getEmpStaCompareLst2(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getEmpStaCompareLst2", paramMap);
    }
}
