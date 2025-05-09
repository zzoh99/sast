package com.hr.api.common.service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;


@Service("ApiLocaleService")
public class ApiLocaleService {

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 모바일 빌드 언어
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getLoadLocale(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getLoadLocale", paramMap);
    }

}