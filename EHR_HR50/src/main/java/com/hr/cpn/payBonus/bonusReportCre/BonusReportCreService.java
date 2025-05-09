package com.hr.cpn.payBonus.bonusReportCre;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * BonusReportCre Service
 *
 * @author EW
 *
 */
@Service("BonusReportCreService")
public class BonusReportCreService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * BonusReportCre 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBonusReportCreList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
            return (List<?>) dao.getList("getBonusReportCreList", paramMap);
	}

	/**
	 * BonusReportCre 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBonusReportCre(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBonusReportCre", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveBonusReportCre", convertMap);
		}

		return cnt;
	}

	/**
	 * BonusReportCre 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getBonusReportCreMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getBonusReportCreMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
    /**
     * BonusReportCre 성과급확인서생성 프로시저 Service
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> callP_CPN_BONUS_RPT_CRE(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (Map<?, ?>) dao.excute("callP_CPN_BONUS_RPT_CRE", paramMap);
    }
}
