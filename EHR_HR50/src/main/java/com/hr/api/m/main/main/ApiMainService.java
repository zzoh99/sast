package com.hr.api.m.main.main;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;


@Service("ApiMainService")
public class ApiMainService {

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
    public List<?> getBoardListPaging(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getBoardListPaging", paramMap);
    }


    /**
     * 공지사항 개수 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public int getBoardListCnt(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (int) dao.getOne("getBoardListCnt", paramMap);
    }
}