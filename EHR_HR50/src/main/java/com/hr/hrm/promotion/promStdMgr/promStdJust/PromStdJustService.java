package com.hr.hrm.promotion.promStdMgr.promStdJust;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 승진급기준관리 가감점탭 Service
 *
 * @author EW
 *
 */
@Service("PromStdJustService")
public class PromStdJustService{

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 승진급기준관리 가감점 탭 포상사항 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getPromStdJustPrizeList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPromStdJustPrizeList", paramMap);
    }

    /**
     * 승진급기준관리 가감점 탭 포상사항 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int savePromStdJustPrize(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deletePromStdJustPrize", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("savePromStdJustPrize", convertMap);
        }

        return cnt;
    }


    /**
     * 승진급기준관리 가감점 탭 징계사항 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getPromStdJustPunishList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPromStdJustPunishList", paramMap);
    }

    /**
     * 승진급기준관리 가감점 탭 징계사항 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int savePromStdJustPunish(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deletePromStdJustPunish", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("savePromStdJustPunish", convertMap);
        }

        return cnt;
    }


    /**
     * 승진급기준관리 가감점 탭 근태정보 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getPromStdJustGntList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPromStdJustGntList", paramMap);
    }

    /**
     * 승진급기준관리 가감점 탭 근태정보 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int savePromStdJustGnt(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deletePromStdJustGnt", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("savePromStdJustGnt", convertMap);
        }

        return cnt;
    }

    /**
     * 승진급기준관리 가감점 탭 자격사항 다건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getPromStdLicenseList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getPromStdLicenseList", paramMap);
    }

    /**
     * 승진급기준관리 가감점 탭 자격사항 저장 Service
     *
     * @param convertMap
     * @return int
     * @throws Exception
     */
    public int savePromStdLicense(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deletePromStdLicense", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("savePromStdLicense", convertMap);
        }

        return cnt;
    }
}

