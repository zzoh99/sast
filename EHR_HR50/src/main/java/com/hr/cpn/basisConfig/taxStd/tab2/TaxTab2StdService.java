package com.hr.cpn.basisConfig.taxStd.tab2;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 세율 및 과세표준 관리 Service
 * 
 * @author 이름
 *
 */
@Service("TaxTab2StdService")  
public class TaxTab2StdService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 세율 및 과세표준 관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTaxTab2StdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTaxTab2StdList", paramMap);
	}	
	/**
	 *  세율 및 과세표준 관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getTaxTab2StdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getTaxTab2StdMap", paramMap);
	}
	/**
	 * 세율 및 과세표준 관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTaxTab2Std(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTaxTab2Std", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTaxTab2Std", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 세율 및 과세표준 관리 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertTaxTab2Std(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.create("insertTaxTab2Std", paramMap);
	}
	/**
	 * 세율 및 과세표준 관리 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateTaxTab2Std(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updateTaxTab2Std", paramMap);
	}
	/**
	 * 세율 및 과세표준 관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteTaxTab2Std(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteTaxTab2Std", paramMap);
	}
}