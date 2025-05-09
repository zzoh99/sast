package com.hr.common.language;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 다국어관리 Service
 *
 * @author CBK 20013.11.21
 *
 */
@Service("LangIdService")
public class LangIdService{
	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 언어관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLangIdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("LangIdService.getLangIdList ");
		return (List<?>) dao.getList("getLangIdList", paramMap);
	}

	/**
	 * 사용 언어관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getUseLangIdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("LangIdService.getUseLangIdList ");
		return (List<?>) dao.getList("getUseLangIdList", paramMap);
	}
	/**
	 *  기본 사용언어조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getDefaultUseLangId(Map<?, ?> paramMap) throws Exception {
		Log.Debug("LangIdService.getDefaultUseLangId");
		return dao.getMap("getDefaultUseLangId", paramMap);
	}

	/**
	 * 언어코드 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLangIdCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("LangIdService.getLangIdCodeList ");
		return (List<?>) dao.getList("getLangIdCodeList", paramMap);
	}

	public String langCdSequence() throws Exception {
		Log.Debug();
		return dao.getMap("langCdSequence", new HashMap<>()).get("seq").toString();
	}

	public String getLangCdTword(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> result = dao.getMap("getLangCdTword", paramMap );
		if(result.isEmpty()) return "";
		return result.get("tlangword").toString();
	}


}