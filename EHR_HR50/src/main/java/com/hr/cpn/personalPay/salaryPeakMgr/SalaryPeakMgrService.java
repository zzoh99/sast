package com.hr.cpn.personalPay.salaryPeakMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("SalaryPeakMgrService")
public class SalaryPeakMgrService {

    @Inject
    @Named("Dao")
    private Dao dao;

    public List<?> getYearCombo(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getYearCombo", paramMap);
    }
}
