package com.hr.cpn.payBonus.bonusDiv;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * BonusDiv Service
 *
 * @author EW
 *
 */
@Service("BonusDivService")
public class BonusDivService{

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * BonusDiv 성과급 배분 그룹목록 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getBonusDivList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
            return (List<?>) dao.getList("getBonusDivList", paramMap);
    }

     /**
     * BonusDiv 성과급 배분  대상자 리스트 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getBonusDivDetailList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
            return (List<?>) dao.getList("getBonusDivDetailList", paramMap);
    }

    /**
     * BonusDiv 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveBonusDiv(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteBonusDiv", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveBonusDiv", convertMap);
        }

        return cnt;
    }

    /**
     * BonusDiv 단건 조회 Service
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> getBonusDivMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getBonusDivMap", paramMap);
        Log.Debug();
        return resultMap;
    }
    
     /**
     * BonusDiv 대상자생성 프로시저 Service
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> callP_CPN_BONUS_DIV_EMP_CRE(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (Map<?, ?>) dao.excute("callP_CPN_BONUS_DIV_EMP_CRE", paramMap);
    }
    
    /**
    * BonusDiv 배분실행 프로시저 Service
    *
    * @param paramMap
    * @return Map
    * @throws Exception
    */
   public Map<?, ?> callP_CPN_BONUS_DIV_MON_CRE(Map<?, ?> paramMap) throws Exception {
       Log.Debug();
       return (Map<?, ?>) dao.excute("callP_CPN_BONUS_DIV_MON_CRE", paramMap);
   }
}
