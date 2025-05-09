package com.hr.hrm.hrmComPopup.hrmLicensePopup;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import opennlp.tools.util.StringUtil;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * hrmLicensePopup Service
 *
 * @author EW
 *
 */
@Service("HrmLicensePopupService")
public class HrmLicensePopupService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * hrmLicensePopup 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrmLicensePopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmLicensePopupList", paramMap);
	}

	/**
	 * hrmLicensePopup 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHrmLicensePopup(Map convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHrmLicensePopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			//mergeRows의 코드 IDX 작업을 해줘야 한다.
			String ssnEnterCd = (String) convertMap.get("ssnEnterCd");
			String grcodeCd = (String) convertMap.get("selectGroupCode");
			List<Map<String, Object>> mergeRows = (List<Map<String, Object>>) convertMap.get("mergeRows");
			Map<String, Integer> codeIdxMap = new HashMap<>();
			mergeRows.stream().forEach(m -> {
				if (m.get("codeIdx") == null || StringUtil.isEmpty((String) m.get("codeIdx"))) {
					String code = (String) m.get("code");
					String key = grcodeCd + "_" + code;
					Integer codeIdx = 0;
					if (codeIdxMap.containsKey(key)) {
						codeIdx = codeIdxMap.get(key) + 1;
						codeIdxMap.put(key, codeIdx);
					} else {
						Map<String, Object> params = new HashMap<String, Object>() {{ put("ssnEnterCd", ssnEnterCd); put("grcodeCd", grcodeCd); put("code", code); }};
						try { codeIdx = (Integer) dao.getOne("countGrpCdMgrDeail", params); } catch (Exception e) { Log.Debug(e.getLocalizedMessage()); }
						codeIdx += 1;
						codeIdxMap.put(key, codeIdx);
					}
					m.put("codeIdx", codeIdx.toString());
				}
			});
			convertMap.put("mergeRows", mergeRows);
			cnt += dao.update("saveHrmLicensePopup", convertMap);
		}

		return cnt;
	}
	/**
	 * hrmLicensePopup 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getHrmLicensePopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getHrmLicensePopupMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
