package com.hr.cpn.payBonus.bonusUpload;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * BonusUpload Service
 *
 * @author EW
 *
 */
@Service("BonusUploadService")
public class BonusUploadService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * BonusUpload 성과급 배분 그룹목록 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBonusUploadList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
            return (List<?>) dao.getList("getBonusUploadList", paramMap);
	}

	 /**
     * BonusUpload 성과급 배분  대상자 리스트 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public List<?> getBonusUploadDetailList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
            return (List<?>) dao.getList("getBonusUploadDetailList", paramMap);
    }

	/**
	 * BonusUpload 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBonusUpload(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBonusUpload", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveBonusUpload", convertMap);
		}

		return cnt;
	}

	/**
	 * BonusUpload 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getBonusUploadMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getBonusUploadMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	 /**
     * BonusUpload 대상자생성 프로시저 Service
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> callP_CPN_BONUS_Upload_EMP_CRE(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (Map<?, ?>) dao.excute("callP_CPN_BONUS_Upload_EMP_CRE", paramMap);
    }
    
    /**
    * BonusUpload 배분실행 프로시저 Service
    *
    * @param paramMap
    * @return Map
    * @throws Exception
    */
   public Map<?, ?> callP_CPN_BONUS_Upload_MON_CRE(Map<?, ?> paramMap) throws Exception {
       Log.Debug();
       return (Map<?, ?>) dao.excute("callP_CPN_BONUS_Upload_MON_CRE", paramMap);
   }
}
