package com.hr.sys.pwrSrch.pwrSrchAdminUser;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.nhncorp.lucy.security.xss.XssPreventer;

@SuppressWarnings("unchecked")
@Service("PwrSrchAdminUserService")
public class PwrSrchAdminUserService {

    @Inject
    @Named("Dao")
    private Dao dao;

    public Map<?, ?> getPwrSrchAdminUserDetailDescMap(Map<?, ?> paramMap) throws Exception { 
		Log.Debug();
		return dao.getMap("getPwrSrchAdminUserDetailDescMap", paramMap);
    }

    public List<?> getPwrSrchAdminUserSht1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchAdminUserSht1List", paramMap);
    }
    
    public List<?> getPwrSrchAdminUserSht2List(Map<?, ?> paramMap) throws Exception {
    	Log.Debug();
    	return (List<?>) dao.getList("getPwrSrchAdminUserSht2List", paramMap);
    }

	public int savePwrSrchAdminUser(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if (((List<Map<String, Object>>) convertMap.get("mergeRows")).size() > 0) {
			cnt += dao.update("savePwrSrchAdminUser219", convertMap);
		}
		Log.Debug();
		return cnt;
    }

    public int updatePwrSrchAdminUserSyntax(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;
	
		cnt += dao.update("updatePwrSrchAdminUserInit", paramMap);
		Log.Debug(Integer.toString(cnt));
		Map<?, ?> m = new HashMap<>();
		if (cnt > 0) {
		    m = dao.getMap("getPwrSrchAdminUserSyntax", paramMap);
		} else {
		    return 0;
		}
		String syntax = m.get("adminSqlSyntax") != null ? m.get("adminSqlSyntax").toString():"";
		if (!"".equals(syntax)) {
		    cnt += dao.update("updatePwrSrchAdminUserSyntax", paramMap);
		} else {
		    return 0;
		}
		if(cnt < 2){ new Throwable("저장 실퍠");}
		Log.Debug();
		return cnt;
    }

    public Map<?, ?> getPwrSrchAdminUserDetail(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getPwrSrchAdminUserDetail", paramMap);
    }
    
    public String getQueryInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getQueryInfo");
		return dao.getStatement("getPwrSrchResultPopupAuthStmtList");
    }
}