package com.hr.cpn.payCalculate.gLInterfaceCalMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 급상여전표처리 Service
 *
 * @author JSG
 *
 */
@Service("GLInterfaceCalMgrService")
public class GLInterfaceCalMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 급상여전표처리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getGLInterfaceCalMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getGLInterfaceCalMgrList", paramMap);
	}
	/**
	 * callP_CPN_GL_INS 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_CPN_GL_INS(Map<?, ?> paramMap) throws Exception {
		Log.Debug("callP_CPN_GL_INS");
		Log.Debug("Nomal paramMap====================>" + paramMap);
		return (Map) dao.excute("callP_CPN_GL_INS", paramMap);
	}
	
	/**
	 * SapReturResultProcP_CPN_GL_RETURN_JJA 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map SapReturResultProcP_CPN_GL_RETURN_JJA(Map<?, ?> paramMap) throws Exception {
		Log.Debug("SapReturResultProcP_CPN_GL_RETURN_JJA");
		Log.Debug("Jco paramMap====================>" + paramMap);
		return (Map) dao.excute("SapReturResultProcP_CPN_GL_RETURN_JJA", paramMap);
	}

	/**
	 * 급상여전표처리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveGLInterfaceCalMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteGLInterfaceCalMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveGLInterfaceCalMgr", convertMap);
		}

		return cnt;
	}
}