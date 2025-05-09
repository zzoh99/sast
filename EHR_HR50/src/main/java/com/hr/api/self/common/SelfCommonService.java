package com.hr.api.self.common;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;


@Service("SelfCommonService")
public class SelfCommonService {

    @Inject
    @Named("Dao")
    private Dao dao;

    public Map<?, ?> getStdCdClob(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return dao.getMap("getStdCdClob", paramMap);
    }

    /**
     * 쿼리 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public Map<?,?> getSelfQueryResult(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (Map<?,?>)dao.getMap("getSelfQueryResult", paramMap);
    }

    /**
     * 쿼리 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getSelfQueryResultList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getSelfQueryResultList", paramMap);
    }

}