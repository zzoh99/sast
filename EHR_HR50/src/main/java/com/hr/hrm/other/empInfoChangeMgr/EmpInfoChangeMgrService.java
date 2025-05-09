package com.hr.hrm.other.empInfoChangeMgr;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.inject.Named;

import com.hr.common.util.DateUtil;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@SuppressWarnings("unchecked")
@Service("EmpInfoChangeMgrService")
public class EmpInfoChangeMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getEmpInfoChangeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getEmpInfoChangeMgrList", paramMap);
	}
	public List<?> getEmpInfoList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("execQuery", paramMap);
	}
	public List<?> getEmpCommonMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getEmpCommonMgrList", paramMap);
	}

	public int saveEmpInfoReq(Map<String, Object> convertMap, boolean tf) throws Exception {
		Log.Debug();
		
		int cnt=0;		
		if ( tf ) {
			cnt = saveEmpInfoChangeMgr2(convertMap);
		}
		
		cnt = dao.create("execQuery", convertMap);
		return cnt;
	}
	
	public Map<?,?> getEmpInfoChangeSeq(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEmpInfoChangeSeq", paramMap);
	}
	/**
	 * 사원정보변경 반영 or 반려 or 저장 처리
	 * 
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int saveEmpInfoChangeMgr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt = deleteEmpInfoChangeMgr(convertMap);//803 DELETE
		
		List<Map<String,Object>> deleteRows = (List<Map<String, Object>>) convertMap.get("deleteRows");
		for(Map<String,Object> map : deleteRows){
			map.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
			map.put("table", map.get("empTable")+"_HIST");
			cnt += dao.delete("deleteEmpInfoChangeMgr2",map);
		}
		cnt += saveEmpInfoChangeMgr2(convertMap);
		List<String> execQuerys = (List<String>) convertMap.get("execQuerys");
		for(String query : execQuerys){
			Map<String,String> tmap = new HashMap<String, String>();
			tmap.put("query", query);
			cnt += dao.create("execQuery", tmap);
		}
		
		return cnt;
	}
	/**
	 * 사원정보변경(thrm803) table save
	 * 
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int saveEmpInfoChangeMgr2(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;		
		cnt += dao.update("saveEmpInfoChangeMgr", convertMap);		
		return cnt;
	}
	/**
	 * 사원정보변경(thrm803) 삭제
	 * 
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int deleteEmpInfoChangeMgr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt =dao.delete("deleteEmpInfoChangeMgr", convertMap);		
		return cnt;
	}
	
	public List<?> getEmpInfoColumnPkSeqList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getEmpInfoColumnPkSeqList", paramMap);
	}
	
	public Map<?,?> getEmpInfoColumnUseList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEmpInfoColumnUseList", paramMap);
	}


	public List<?> getEmpInfoChangeTypeList(Map<String, Object> paramMap) throws Exception {
		Log.Debug(paramMap.toString());
		List<Map<String,Object>> list = null;
		List<String> grpCd = new ArrayList<>();
		paramMap.put("useYn", "Y");
		if("THRM124".equals(paramMap.get("searchEmpTable"))){
			//연락처
			list = (List<Map<String, Object>>) dao.getList("getPsnalContactUserList", paramMap);
			for(Map<String, Object> listMap : list){
				listMap.put("code", listMap.get("contType"));
				listMap.put("codeNm", listMap.get("contTypeNm"));
			}
		}else if("THRM123".equals(paramMap.get("searchEmpTable"))){
			//주소
			grpCd.add("H20185");
			paramMap.put("grpCd", grpCd);
			List<Map<String,Object>> codeList = (List<Map<String, Object>>) dao.getList("getCommonCodeLists", paramMap);
			List<Map<String,Object>> addressList = (List<Map<String, Object>>) dao.getList("getPsnalContactAddressList", paramMap);
//			for(Map<String, Object> listMap : codeList){
//				List<Map<String, Object>> code = codeList.stream()
//						.filter(item -> listMap.get("addType").equals(item.get("code")))
//						.collect(Collectors.toList());
//				listMap.put("code", listMap.get("addType"));
//				listMap.put("codeNm", code.get(0).get("codeNm"));
//			}
// id 기준으로 Map 구성
			Map<Object, Map<String, Object>> map1 = addressList.stream()
					.collect(Collectors.toMap(m -> m.get("addType"), Function.identity()));

			Map<Object, Map<String, Object>> map2 = codeList.stream()
					.collect(Collectors.toMap(m -> m.get("code"), Function.identity()));

			Set<Object> allIds = new HashSet<>();
			allIds.addAll(map1.keySet());
			allIds.addAll(map2.keySet());

			// 각 id에 대해 병합
			List<Map<String, Object>> result = new ArrayList<>();
			for (Object id : allIds) {
				Map<String, Object> merged = new HashMap<>();
				merged.put("addType", id);
				merged.put("code", id);

				if (map1.containsKey(id)) {
					merged.putAll(map1.get(id));
				}
				if (map2.containsKey(id)) {
					merged.putAll(map2.get(id));
				}

				result.add(merged);
			}

			Log.Debug(result.toString());
			list = result;
		}else if("THRM111".equals(paramMap.get("searchEmpTable"))){
			//가족
			grpCd.add("H20120");
			paramMap.put("grpCd", grpCd);
			list = (List<Map<String, Object>>) dao.getList("getCommonCodeLists", paramMap);
		}else if("THRM115".equals(paramMap.get("searchEmpTable"))){
			//학력
			grpCd.add("H20130");
			paramMap.put("grpCd", grpCd);
			list = (List<Map<String, Object>>) dao.getList("getCommonCodeLists", paramMap);
		}else if("THRM113".equals(paramMap.get("searchEmpTable"))) {
			//자격
			list = (List<Map<String, Object>>) dao.getList("getPsnalLicenseList", paramMap);
			for(Map<String, Object> listMap : list){
				listMap.put("code", listMap.get("seq"));
				listMap.put("codeNm", listMap.get("licenseNm"));
			}
		}else if("THRM117".equals(paramMap.get("searchEmpTable"))) {
			//사외경력
			list = (List<Map<String, Object>>) dao.getList("getPsnalCareerList", paramMap);
			for(Map<String, Object> listMap : list){
				listMap.put("code", listMap.get("seq"));
				listMap.put("codeNm", listMap.get("cmpNm"));
			}
		}else if("THRM129".equals(paramMap.get("searchEmpTable"))){
			//징계
			grpCd.add("H20270");
			paramMap.put("grpCd", grpCd);
			list = (List<Map<String, Object>>) dao.getList("getCommonCodeLists", paramMap);
		}else if("THRM128".equals(paramMap.get("searchEmpTable"))){
			//포상
			grpCd.add("H20250");
			paramMap.put("grpCd", grpCd);
			list = (List<Map<String, Object>>) dao.getList("getCommonCodeLists", paramMap);
		}else if("THRM125".equals(paramMap.get("searchEmpTable"))){
			//어학
			grpCd.add("H20300");
			paramMap.put("grpCd", grpCd);
			list = (List<Map<String, Object>>) dao.getList("getCommonCodeLists", paramMap);
		}else if("THRM119".equals(paramMap.get("searchEmpTable"))){
			//보증
			grpCd.add("H20380");
			paramMap.put("grpCd", grpCd);
			list = (List<Map<String, Object>>) dao.getList("getCommonCodeLists", paramMap);
		}else if("THRM131".equals(paramMap.get("searchEmpTable"))){
			//해외
			grpCd.add("H20290");
			paramMap.put("grpCd", grpCd);
			list = (List<Map<String, Object>>) dao.getList("getCommonCodeLists", paramMap);
		}

		//병역(수정)
		//보훈(수정)
		//장애(수정)
		//특례(수정)
		return list;
	}

	public List<?> getEmpInfoChangeTypeList2(Map<String, Object> paramMap) throws Exception {
		List<Map<String,Object>> list = null;
		List<String> grpCd = new ArrayList<>();
		paramMap.put("useYn", "Y");
		if("THRM111".equals(paramMap.get("searchEmpTable"))){
			//가족
			List<Map<String,Object>> famList = (List<Map<String, Object>>) dao.getList("getPsnalFamilyList", paramMap);
			List<Map<String, Object>> codeList = famList.stream()
					.filter(item -> item.get("famCd").equals(paramMap.get("code")))
					.collect(Collectors.toList());
			int i = 0;
			for(Map<String, Object> listMap : codeList){
				listMap.put("code", i+"");
				listMap.put("codeNm", listMap.get("famNm"));
				i++;
			}
			list = codeList;
		}else if("THRM115".equals(paramMap.get("searchEmpTable"))){
			//학력
			List<Map<String,Object>> schoolList = (List<Map<String, Object>>) dao.getList("getPsnalSchoolList", paramMap);
			List<Map<String, Object>> codeList = schoolList.stream()
					.filter(item -> item.get("acaCd").equals(paramMap.get("code")))
					.collect(Collectors.toList());
			int i = 0;
			for(Map<String, Object> listMap : codeList){
				listMap.put("code", i+"");
				listMap.put("codeNm", listMap.get("acaSchNm"));
				i++;
			}
			list = codeList;
		}else if("THRM129".equals(paramMap.get("searchEmpTable"))){
			//징계
			List<Map<String,Object>> punishList = (List<Map<String, Object>>) dao.getList("getPsnalJusticePunishList", paramMap);
			List<Map<String, Object>> codeList = punishList.stream()
					.filter(item -> item.get("punishCd").equals(paramMap.get("code")))
					.collect(Collectors.toList());

			int i = 0;
			for(Map<String, Object> listMap : codeList){
				listMap.put("code", listMap.get("seq"));

				DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
				DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-dd-MM");
				LocalDate date = LocalDate.parse(listMap.get("punishYmd").toString(), inputFormatter);
				String formatted = date.format(outputFormatter);

				listMap.put("codeNm", formatted + "_" + listMap.get("punishNo"));
//				listMap.put("codeNm", listMap.get("punishYmd"));
				i++;
			}
			list = codeList;
		}else if("THRM128".equals(paramMap.get("searchEmpTable"))){
			//포상
			List<Map<String,Object>> prizeList = (List<Map<String, Object>>) dao.getList("getPsnalJusticePrizeList", paramMap);
			List<Map<String, Object>> codeList = prizeList.stream()
					.filter(item -> item.get("prizeCd").equals(paramMap.get("code")))
					.collect(Collectors.toList());

			int i = 0;
			for(Map<String, Object> listMap : codeList){
				listMap.put("code", listMap.get("seq"));

				DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
				DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-dd-MM");
				LocalDate date = LocalDate.parse(listMap.get("prizeYmd").toString(), inputFormatter);
				String formatted = date.format(outputFormatter);

				listMap.put("codeNm", formatted + "_" + listMap.get("prizeNo"));
//				listMap.put("codeNm", listMap.get("prizeYmd"));
				i++;
			}
			list = codeList;
		}else if("THRM125".equals(paramMap.get("searchEmpTable"))){
			//어학
			List<Map<String,Object>> langList = (List<Map<String, Object>>) dao.getList("getPsnalLangForeignList", paramMap);
			List<Map<String, Object>> codeList = langList.stream()
					.filter(item -> item.get("foreignCd").equals(paramMap.get("code")))
					.collect(Collectors.toList());

			int i = 0;
			for(Map<String, Object> listMap : codeList){
				listMap.put("code", listMap.get("seq"));

				DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
				DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-dd-MM");
				LocalDate date = LocalDate.parse(listMap.get("applyYmd").toString(), inputFormatter);
				String formatted = date.format(outputFormatter);

				listMap.put("codeNm", formatted + "_" + listMap.get("codeNm"));
				i++;
			}
			list = codeList;
		}else if("THRM131".equals(paramMap.get("searchEmpTable"))){
			//해외
			List<Map<String,Object>> oslist = (List<Map<String, Object>>) dao.getList("getPsnalOverStudyList", paramMap);
			List<Map<String, Object>> codeList = oslist.stream()
					.filter(item -> item.get("nationCd").equals(paramMap.get("code")))
					.collect(Collectors.toList());

			int i = 0;
			for(Map<String, Object> listMap : codeList){
				listMap.put("code", listMap.get("seq"));
				listMap.put("codeNm", listMap.get("cityNm"));
				i++;
			}
			list = codeList;
		}else if("THRM119".equals(paramMap.get("searchEmpTable"))){
			//보증
			paramMap.put("type", "1");
			List<Map<String, Object>> awList = (List<Map<String, Object>>) dao.getList("getPsnalAssuranceWarrantyList", paramMap);
			List<Map<String, Object>> codeList = awList.stream()
					.filter(item -> item.get("warrantyCd").equals(paramMap.get("code")))
					.collect(Collectors.toList());

			int i = 0;
			for(Map<String, Object> listMap : codeList){
				listMap.put("code", i);
				listMap.put("codeNm", listMap.get("warrantyNo"));
				i++;
			}
			list = codeList;
		}
		return list;
	}
}
