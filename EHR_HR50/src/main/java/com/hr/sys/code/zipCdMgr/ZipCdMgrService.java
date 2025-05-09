package com.hr.sys.code.zipCdMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 우편번호관리 Service
 *
 * @author 이름
 *
 */
@Service("ZipCdMgrService")
public class ZipCdMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 우편번호관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getZipCdMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getZipCdMgrList", paramMap);
	}
	/**
	 *  우편번호관리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getZipCdMgrCntMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getZipCdMgrCntMap", paramMap);
	}
}