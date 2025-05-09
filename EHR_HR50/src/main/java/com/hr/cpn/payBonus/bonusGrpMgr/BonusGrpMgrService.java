package com.hr.cpn.payBonus.bonusGrpMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * BonusGrpMgr Service
 *
 * @author EW
 *
 */
@Service("BonusGrpMgrService")
public class BonusGrpMgrService{

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * BonusGrpMgr 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getBonusGrpMgrList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getBonusGrpMgrList", paramMap);
    }

    /**
     * BonusGrpMgr 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveBonusGrpMgr(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteBonusGrpMgr", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveBonusGrpMgr", convertMap);
        }

        return cnt;
    }

    /**
     * BonusGrpMgr 단건 조회 Service
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> getBonusGrpMgrMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getBonusGrpMgrMap", paramMap);
        Log.Debug();
        return resultMap;
    }
}
