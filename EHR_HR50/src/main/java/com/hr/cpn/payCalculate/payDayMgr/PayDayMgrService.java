package com.hr.cpn.payCalculate.payDayMgr;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 급여일자관리 Service
 *
 * @author 이름
 *
 */
@Service("PayDayMgrService")
public class PayDayMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 221Popup 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayDayMgrPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayDayMgrPopList", paramMap);
	}

	/**
	 * 221Popup 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayDayMgrPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayDayMgrPop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayDayMgrPop", convertMap);
		}

		return cnt;
	}

	/**
	 * 급여일자관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayDayMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		// 트리거 사용을 위한 단건 처리

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){

			List<Map> deleteRows = (List<Map>)convertMap.get("deleteRows");

			for(Map<String,Object> mp : deleteRows) {
				Map<String,Object> dupMap = new HashMap<String,Object>();
				dupMap.put("ssnEnterCd",convertMap.get("ssnEnterCd"));
				dupMap.put("payActionCd",mp.get("payActionCd"));

				dupMap.put("ssnSabun", 	convertMap.get("ssnSabun"));
				dupMap.put("ssnEnterCd",convertMap.get("ssnEnterCd"));

				cnt += dao.delete("deletePayDayMgr", dupMap);
			}
		}

		// 업데이트 기능만 수행 한다.
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayDayMgr", convertMap);
		}

		// 트리거 사용을 위한 단건 처리
		if( ((List<?>)convertMap.get("insertRows")).size() > 0){

			List<Map> insertRows = (List<Map>)convertMap.get("insertRows");

			for(Map<String,Object> mp : insertRows) {
				Map<String,Object> dupMap = new HashMap<String,Object>();
				dupMap.put("ssnEnterCd",convertMap.get("ssnEnterCd"));
				dupMap.put("ssnSabun", 	convertMap.get("ssnSabun"));

//				dupMap.put("payActionCd",      mp.get("payActionCd"));
				dupMap.put("payActionNm",      mp.get("payActionNm"));
				dupMap.put("payYm",            mp.get("payYm"));
				dupMap.put("payCd",            mp.get("payCd"));
				dupMap.put("runType",          mp.get("runType"));
				dupMap.put("paymentYmd",       mp.get("paymentYmd"));
				dupMap.put("closeYn",          mp.get("closeYn"));
				dupMap.put("ordSymd",          mp.get("ordSymd"));
				dupMap.put("ordEymd",          mp.get("ordEymd"));
				dupMap.put("timeYm",           mp.get("timeYm"));
				dupMap.put("calTaxMethod",     mp.get("calTaxMethod"));
				dupMap.put("calTaxSym",        mp.get("calTaxSym"));
				dupMap.put("calTaxEym",        mp.get("calTaxEym"));
				dupMap.put("addTaxRate",       mp.get("addTaxRate"));
				dupMap.put("bonSymd",          mp.get("bonSymd"));
				dupMap.put("bonEymd",          mp.get("bonEymd"));
				dupMap.put("gntSymd",          mp.get("gntSymd"));
				dupMap.put("gntEymd",          mp.get("gntEymd"));
				dupMap.put("bonCalType",       mp.get("bonCalType"));
				dupMap.put("bonApplyType",     mp.get("bonApplyType"));
				dupMap.put("bonMonRate",       mp.get("bonMonRate"));
				dupMap.put("paymentMethod",    mp.get("paymentMethod"));
				dupMap.put("manCnt",           mp.get("manCnt"));
				dupMap.put("bigo",             mp.get("bigo"));
				dupMap.put("taxPeriordChoiceYn",             mp.get("taxPeriordChoiceYn"));

				cnt += dao.create("insertPayDayMgr", dupMap);
			}
		}

		Log.Debug();
		return cnt;
	}



}