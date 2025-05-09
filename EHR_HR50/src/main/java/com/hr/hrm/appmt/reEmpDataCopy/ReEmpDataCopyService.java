package com.hr.hrm.appmt.reEmpDataCopy;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 사번변경 Service
 * 
 * @author JCY
 *
 */
@Service("ReEmpDataCopyService")  
public class ReEmpDataCopyService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 사번변경 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getReEmpDataCopyList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getReEmpDataCopyList", paramMap);
	}	

	/**
	 * 사번변경 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveReEmpDataCopy(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteReEmpDataCopy", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveReEmpDataCopy", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	
	/**
     * 사번변경 프로시져
     *
     * @param paramMap
     * @return int
     * @throws Exception
     */
    public Map prcP_HRM_POST_REEMP_DATA_COPY(Map<?, ?> paramMap) throws Exception {
        Log.Debug();

        return (Map) dao.excute("prcP_HRM_POST_REEMP_DATA_COPY", paramMap);
    }


}