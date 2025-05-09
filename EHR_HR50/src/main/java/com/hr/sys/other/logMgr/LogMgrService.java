package com.hr.sys.other.logMgr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.SessionUtil;

@Service("LogMgrService")
public class LogMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getPwrSrchCdElemtMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPwrSrchCdElemtMgrList", paramMap);
	}

	public int savePwrSrchCdElemtMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePwrSrchCdElemtMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePwrSrchCdElemtMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	public Map<?,?> getPwrSrchCdElemtMgrDetail(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>)dao.getMap("getPwrSrchCdElemtMgrDetail", paramMap);
	}


	public Map<?, ?> getLogQueryMap(String queryId, Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap(queryId, paramMap);
	}


	/**
	 * 로그 생성
	 *
	 * @param queryId
	 * @param job
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertLog(String queryId, String job, Map<?,?> paramMap) throws Exception {

		Log.Debug("insertLog paramMap ="+ paramMap.toString());

		String enterCd = (String) SessionUtil.getRequestAttribute("ssnEnterCd");
		String controllerName = (String)  SessionUtil.getRequestAttribute("logController");

		if(enterCd == null || "".equals(enterCd)) return -1;

		Map<String, Object> logParam = new HashMap<String, Object>();

		paramMap.remove("localeCd1");
		paramMap.remove("localeCd2");
		paramMap.remove("s_SAVENAME");
		paramMap.remove("loginPassword");

		logParam.put("logEnterCd",		SessionUtil.getRequestAttribute("ssnEnterCd") );
		logParam.put("logJob", 			job );
		logParam.put("logIp", 			SessionUtil.getRequestAttribute("logIp") );
		logParam.put("logRequestUrl", 	SessionUtil.getRequestAttribute("logRequestUrl") );
		logParam.put("logRequestBaseUrl", 	SessionUtil.getRequestAttribute("logRequestBaseUrl") );
		logParam.put("logGrpCd", 		SessionUtil.getRequestAttribute("ssnGrpCd") );

		//관리자가 사용자변경 후 작업 시 메모에 남김.
		String adminSabun = (String)SessionUtil.getRequestAttribute("ssnAdminSabun");
		String ssnSabun = (String)SessionUtil.getRequestAttribute("ssnSabun");
		if( adminSabun != null && !adminSabun.equals(ssnSabun) ){
			logParam.put("logMemo", "Admin Sabun : "+adminSabun );
		}else{
			logParam.put("logMemo", "");
		}

		logParam.put("logController", 	controllerName );
		logParam.put("logParameter", 	paramMap.toString() );
		logParam.put("logQueryId", 		queryId );
		logParam.put("logSabun", 		ssnSabun );

		Log.Debug("로그 저장 ="+ logParam.toString());

		Map<?, ?> seqMax = getLogQueryMap("getLogMgrSeqMap",logParam );
		String logSeq = seqMax.get("seq").toString();

		logParam.put("logSeq", 			logSeq );
		logParam.put("logQueryString",	"");
		logParam.put("logRefererUrl",	"");

		dao.excute("insertLogMgr", logParam);
		dao.excute("updateLogMgr", logParam);
		return 0;
	}

}