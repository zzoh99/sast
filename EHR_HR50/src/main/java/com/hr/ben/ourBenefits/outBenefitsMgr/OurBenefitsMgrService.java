package com.hr.ben.ourBenefits.outBenefitsMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * OurBenefitsService Service
 */
@Service("OurBenefitsMgrService")
public class OurBenefitsMgrService {

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 우리회사 복리후생 관리 항목 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<Map<String, Object>> getOurBenefitsMgr(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<Map<String, Object>>) dao.getList("getOurBenefitsMgr", paramMap);
    }

    /**
     * 우리회사 복리후생 항목 저장 Service
     *
     * @param convertMap
     * @return List
     * @throws Exception
     */
    public int saveOurBenefitsMgr(Map<String, Object> convertMap) throws Exception {
        Log.Debug();
        int cnt = 0;
        if ( (convertMap.get("deleteRows") instanceof List) && !((List) convertMap.get("deleteRows")).isEmpty()) {
            dao.delete("deleteOurBenefitsMgr", convertMap);
        }

        if ( (convertMap.get("mergeRows") instanceof List) && !((List) convertMap.get("mergeRows")).isEmpty()) {
            cnt = dao.update("saveOurBenefitsMgr", convertMap);
        }
        return cnt;
    }
}
