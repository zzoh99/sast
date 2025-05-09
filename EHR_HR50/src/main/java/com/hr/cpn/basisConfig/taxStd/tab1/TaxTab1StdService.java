package com.hr.cpn.basisConfig.taxStd.tab1;
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
@Service("TaxTab1StdService")  
public class TaxTab1StdService{
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
	public List<?> getTaxTab1StdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTaxTab1StdList", paramMap);
	}	
	/**
	 *  세율 및 과세표준 관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getTaxTab1StdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getTaxTab1StdMap", paramMap);
	}
	/**
	 * 세율 및 과세표준 관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTaxTab1Std(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTaxTab1Std", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTaxTab1Std", convertMap);
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
	public int insertTaxTab1Std(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.create("insertTaxTab1Std", paramMap);
	}

	
	
	/**
	 * 세율 관리 및 과세 표준 - 전년도 자료 복사
	 * 
	 * 세율 관리 : TCPN501
	 * 과세 표준 : TCPN502
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcTariffMaxYearCall(Map<?, ?> paramMap) throws Exception {
		Log.Debug("TaxTab1StdController.java.prcTariffMaxYearCall ");
		Log.Debug("obj : "+paramMap);
		return (Map) dao.excute("prcTariffMaxYearCall", paramMap);
	}
}