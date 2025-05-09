package com.hr.api.m.ben.occasion;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;


@Service("ApiOccasionService")
public class ApiOccasionService {

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 결제함 조회
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<?> getOccasionList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getOccasionList", paramMap);
    }

    public int getOccAppListCnt(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (int) dao.getOne("getOccAppListCnt", paramMap);
    }

    /**
     * 경조코드 조회 Serivce
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getOccCdList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>)dao.getList("getOccCdList", paramMap);
    }

    /**
     * 경조금신청 단건 조회 3 Service
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> getOccAppDetMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getOccAppDetMap", paramMap);
        Log.Debug();
        return resultMap;
    }

    /**
     * 경조금신청 중복체크 Service
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> getOccasionAppDupChk(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getOccasionAppDupChk", paramMap);
        Log.Debug();
        return resultMap;
    }

    /**
     * 경조금신청 세부내역 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveOccasionAppDet(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return dao.update("saveOccasionAppDet", paramMap);
    }
}
