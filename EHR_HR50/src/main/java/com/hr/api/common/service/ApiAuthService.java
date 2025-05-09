package com.hr.api.common.service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.Map;


@Service
public class ApiAuthService {

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 로그인 정보 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public Map<?,?> getMobileToken(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (Map<?,?>)dao.getMap("getMobileToken", paramMap);
    }
}