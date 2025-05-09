package com.hr.cpn.perExpense.bonusAdjustMonSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 상여조정액조회 Service
 *
 * @author EW
 *
 */
@Service("BonusAdjustMonStaService")
public class BonusAdjustMonStaService{

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 상여조정액조회 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getBonusAdjustMonStaList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getBonusAdjustMonStaList", paramMap);
    }

    /**
     * 상여조정액조회 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveBonusAdjustMonSta(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteBonusAdjustMonSta", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveBonusAdjustMonSta", convertMap);
        }

        return cnt;
    }
}
