package com.hr.cpn.perExpense.retAllowanceSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직충당금조회 Service
 *
 * @author EW
 *
 */
@Service("RetAllowanceStaService")
public class RetAllowanceStaService{

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 퇴직충당금조회 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getRetAllowanceStaList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getRetAllowanceStaList", paramMap);
    }

    /**
     * 퇴직충당금조회 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getRetAllowanceStaPopList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getRetAllowanceStaPopList", paramMap);
    }

    /**
     * 퇴직충당금조회 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int saveRetAllowanceSta(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteRetAllowanceSta", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveRetAllowanceSta", convertMap);
        }

        return cnt;
    }
}
