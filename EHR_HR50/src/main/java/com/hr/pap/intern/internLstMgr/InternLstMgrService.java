package com.hr.pap.intern.internLstMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 촉탁직평가대상자관리 Service
 * 
 * @author 이름
 *
 */
@Service("InternLstMgrService")  
public class InternLstMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 촉탁직평가대상자관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternLstMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternLstMgrList", paramMap);
	}	
	/**
	 *  촉탁직평가대상자관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getInternLstMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getInternLstMgrMap", paramMap);
	}

}