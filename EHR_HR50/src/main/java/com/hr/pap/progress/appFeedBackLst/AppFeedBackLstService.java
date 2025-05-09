package com.hr.pap.progress.appFeedBackLst;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

import java.util.List;
import java.util.Map;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("AppFeedBackLstService")
public class AppFeedBackLstService {

    @Inject
    @Named("Dao")
    private Dao dao;

    public int saveAppFeedBackLstComment(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        int cnt=0;
         cnt += dao.update("saveAppFeedBackLstComment", paramMap);

        Log.Debug();
        return cnt;
    }
    
    /**
	 * 평가결과피드백(관리자) 다건 조회
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppFeedBackAllLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppFeedBackAllLstList", paramMap);
	}
}
