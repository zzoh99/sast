package com.hr.sys.other.guideMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 메뉴명 Service
 * 
 * @author 이름
 *
 */
@Service("GuideService")  
public class GuideService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 메뉴명 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getGuideList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getGuideList", paramMap);
	}	

	/**
	 * appSample 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> appSample(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("appSample", paramMap);
	}
}