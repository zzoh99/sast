package com.hr.api.self.login;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.Map;


@Service("SelfLoginService")
public class SelfLoginService {

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 공지사항 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public Map<?, ?> getLoginSelf(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (Map<?, ?>) dao.getMap("getLoginSelf", paramMap);
    }
}