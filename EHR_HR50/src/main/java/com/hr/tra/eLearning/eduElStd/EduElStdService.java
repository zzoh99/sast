package com.hr.tra.eLearning.eduElStd;
import javax.inject.Inject;
import javax.inject.Named;

import com.hr.common.logger.Log;
import opennlp.tools.util.StringUtil;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 경조기준관리 Service
 * 
 * @author 이름
 *
 */
@Service("EduElStdService")  
public class EduElStdService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 이러닝기준관리 - 신청기간 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduElStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduElStdList", paramMap);
	}

	/**
	 * 이러닝기준관리 - 예외자 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduElStdEmpList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduElStdEmpList", paramMap);
	}

	/**
	 * 이러닝기준관리 - 신청항목 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduElStdItemList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduElStdItemList", paramMap);
	}

	/**
	 * 이러닝기준관리 - 신청세부항목 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduElStdItemDtlList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduElStdItemDtlList", paramMap);
	}

	/**
	 * 이러닝기준관리 - 신청기간 저장
	 *
	 * @param convertMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public int saveEduElStdDate(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduElStdDate", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduElStdDate", convertMap);
		}

		return cnt;
	}

	/**
	 * 이러닝기준관리 - 예외자 저장
	 *
	 * @param convertMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public int saveEduElStdEmp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduElStdEmp", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduElStdEmp", convertMap);
		}

		return cnt;
	}

	/**
	 * 이러닝기준관리 - 신청항목 저장
	 *
	 * @param convertMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public int saveEduElStdItem(Map convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduElStdItem", convertMap);
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
			cnt += dao.update("saveEduElStdItem", convertMap);
		}

		return cnt;
	}

	/**
	 * 이러닝기준관리 - 세부항목 저장
	 *
	 * @param convertMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public int saveEduElStdItemDtl(Map convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduElStdItemDtl", convertMap);
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
			cnt += dao.update("saveEduElStdItemDtl", convertMap);
		}

		return cnt;
	}

	/**
	 * 이러닝기준관리 - 신청기간 자동생성
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcEduElStd(Map<?, ?> paramMap) throws Exception {
		Log.Debug("prcEduElStd");
		return (Map) dao.excute("prcEduElStd", paramMap);
	}
}