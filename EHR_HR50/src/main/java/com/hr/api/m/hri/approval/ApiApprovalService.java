package com.hr.api.m.hri.approval;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;


@Service("ApiApprovalService")
public class ApiApprovalService {

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
    public List<?> getApprovalList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getApprovalList", paramMap);
    }

    public int getApprovalListCnt(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (int) dao.getOne("getApprovalListCnt", paramMap);
    }
}