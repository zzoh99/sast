package com.hr.cpn.personalPay.perlAccChgApp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import javax.inject.Inject;
import javax.inject.Named;

import com.hr.common.util.StringUtil;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 메뉴명 Service
 *
 * @author 이름
 *
 */
@Service("PerlAccChgAppService")
public class PerlAccChgAppService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 메뉴명 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerlAccChgAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerlAccChgAppList", paramMap);
	}
	/**
	 * 메뉴명 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerlAccChgApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePerlAccChgApp", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePerlAccChgApp", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 현재 유효한 급여계좌 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPerlAccChgAppDetCurrAccountList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getPerlAccChgAppDetCurrAccountList", paramMap);
	}

	/**
	 * 급여계좌 신청 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerlAccChgAppDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		List<Map<String, Object>> list = new ArrayList<>();
		if (paramMap.get("new") instanceof List && !((List<?>) paramMap.get("new")).isEmpty() ) {
			List<Map<String, Object>> newList = (List<Map<String, Object>>) paramMap.get("new");
			List<Map<String, Object>> tmpList = newList.stream().map(map -> {
				Map<String, Object> tmpMap = new HashMap<>(map);
				tmpMap.put("enterCd", StringUtil.stringValueOf(paramMap.get("ssnEnterCd")));
				tmpMap.put("appType", "I");
				return tmpMap;
			}).collect(Collectors.toList());

			list.addAll(tmpList);
		}

		if (paramMap.get("cancel") instanceof List && !((List<?>) paramMap.get("cancel")).isEmpty() ) {
			List<Map<String, Object>> newList = (List<Map<String, Object>>) paramMap.get("cancel");
			List<Map<String, Object>> tmpList = newList.stream().map(map -> {
				Map<String, Object> tmpMap = new HashMap<>(map);
				tmpMap.put("enterCd", StringUtil.stringValueOf(paramMap.get("ssnEnterCd")));
				tmpMap.put("appType", "D");
				return tmpMap;
			}).collect(Collectors.toList());

			list.addAll(tmpList);
		}

		if (!list.isEmpty()) {
			Map<String, Object> params = new HashMap<>();
			params.put("list", list);
			params.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			params.put("ssnSabun", paramMap.get("ssnSabun"));
			cnt = dao.create("savePerlAccChgAppDet", params);
		}

		Log.Debug();
		return cnt;
	}


}