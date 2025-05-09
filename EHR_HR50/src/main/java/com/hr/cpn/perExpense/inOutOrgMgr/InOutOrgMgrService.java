package com.hr.cpn.perExpense.inOutOrgMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 전출입관리 Service
 *
 * @author EW
 *
 */
@Service("InOutOrgMgrService")
public class InOutOrgMgrService{

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 전출입관리 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getInOutOrgMgrTab1List(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getInOutOrgMgrTab1List", paramMap);
    }

    /**
     * 전출입관리 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getInOutOrgMgrTab2List(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getInOutOrgMgrTab2List", paramMap);
    }

    /**
     * 전출입관리 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveInOutOrgMgr(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteInOutOrgMgr", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveInOutOrgMgr", convertMap);
        }

        return cnt;
    }
    /**
     * 전출입관리 인터페이스ID 조회 Service
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> getInOutOrgMgrITFIDMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getInOutOrgMgrITFIDMap", paramMap);
        Log.Debug();
        return resultMap;
    }
    /**
     * 전출입관리 단건 조회 Service
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> getInOutOrgMgrMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getInOutOrgMgrMap", paramMap);
        Log.Debug();
        return resultMap;
    }
    /**
     * 전출입관리 프로시저 Service
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> inOutOrgMgrPrc1(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (Map<?, ?>) dao.excute("inOutOrgMgrPrc1", paramMap);
    }

    /**
     * 전출입관리 프로시저 Service
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> inOutOrgMgrPrc2(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (Map<?, ?>) dao.excute("inOutOrgMgrPrc2", paramMap);
    }
}
