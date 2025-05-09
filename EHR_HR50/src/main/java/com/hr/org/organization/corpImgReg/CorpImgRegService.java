package com.hr.org.organization.corpImgReg;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 법인이미지 Service
 *
 * @author bckim
 *
 */
@Service("CorpImgRegService")
public class CorpImgRegService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 법인이미지 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCorpImgRegList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCorpImgRegList", paramMap);
	}

	/**
	 * 법인이미지 수정 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateCorpImgReg(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updateCorpImgReg", paramMap);
	}

	/**
	 * 법인이미지(품의번호적용) 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcCorpImgReg(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcCorpImgReg", paramMap);
	}

}