package com.hr.ben.ourBenefits.outBenefitsSta;

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
@Service("OurBenefitsStaService")
public class OurBenefitsStaService {

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 우리회사 복리후생 항목 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<Map<String, Object>> getOurCompanyBenefits(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<Map<String, Object>>) dao.getList("getOurCompanyBenefits", paramMap);
    }

    /**
     * 우리회사 복리후생 카테고리 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<Map<String, Object>> getOurCompanyBenefitCategories(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<Map<String, Object>>) dao.getList("getOurCompanyBenefitCategories", paramMap);
    }
}
