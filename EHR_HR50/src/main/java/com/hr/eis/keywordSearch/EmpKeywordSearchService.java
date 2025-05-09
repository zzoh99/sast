package com.hr.eis.keywordSearch;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 키워드검색 Service
 * 
 * @author jcy
 *
 */
@Service("EmpKeywordSearchService")  
public class EmpKeywordSearchService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 키워드검색 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpKeywordSearchList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpKeywordSearchList", paramMap);
	}
	
	/**
	 * 키워드검색 - 프로시저 실행
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcEmpKeywordSearch(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcEmpKeywordSearch", paramMap);
	}
}