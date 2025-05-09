package com.hr.hrd.statistics.workSatisfactionPersonStatistics;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("WorkSatisfactionPersonStatisticsService")
public class WorkSatisfactionPersonStatisticsService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getWorkSatisfactionPersonStatisticsItem(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkSatisfactionPersonStatisticsItem", paramMap);
	}

	public List<?> getWorkSatisfactionPersonStatisticsSurveyItemList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkSatisfactionPersonStatisticsSurveyItemList", paramMap);
	}

	public Map<?,?> getWorkSatisfactionPersonStatisticsSurveyItemStr(Map<?, ?> paramMap) throws Exception {
		return (Map<?,?>) dao.getMap("getWorkSatisfactionPersonStatisticsSurveyItemStr", paramMap);
	}

	public List<?> getWorkSatisfactionPersonStatisticsList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkSatisfactionPersonStatisticsList", paramMap);
	}

//	private Map<String, Object> getSameReturnItem(List<Map<String, Object>> returnList, Map<String, Object> resultItem ){
//		for(Map<String, Object> returnItem : returnList){
//			if ( returnItem.get("enterCd").equals(resultItem.get("enterCd").toString()) &&
//					returnItem.get("sabun").equals(resultItem.get("sabun").toString()) )
//				return returnItem;
//		}
//
//		Map<String, Object> returnItem = new HashMap<>();
//		returnItem.put("enterCd"  , resultItem.get("enterCd"  ));
//		returnItem.put("sabun"    , resultItem.get("sabun"    ));
//		returnItem.put("name"     , resultItem.get("name"     ));
//		returnItem.put("jikgubCd" , resultItem.get("jikgubCd" ));
//		returnItem.put("jikweeCd" , resultItem.get("jikweeCd" ));
//		returnItem.put("jikchakCd", resultItem.get("jikchakCd"));
//		returnItem.put("jikgubNm" , resultItem.get("jikgubNm" ));
//		returnItem.put("jikweeNm" , resultItem.get("jikweeNm" ));
//		returnItem.put("jikchakNm", resultItem.get("jikchakNm"));
//		returnList.add(returnItem);
//
//		return returnItem;
//	}

//	private void calculateAvg(List<Map<String, Object>> returnItems){
//		int totalValue = 0;
//		int totalCount = 0;
//		int avgValue = 0;
//
//		for(Map<String, Object> returnItem : returnItems){
//			for(Map.Entry<String, Object> value : returnItem.entrySet()){
//				if (value.getKey().startsWith("surveyItemCd")){
//					totalCount++;
//					totalValue += Integer.parseInt(value.getValue().toString());
//				}
//			}
//
//			if (totalCount != 0 )
//				avgValue = totalValue / totalCount;
//
//			returnItem.put("avgPoint", avgValue );
//		}
//	}

//	private void addSummary(List<Map<String, Object>> returnItems){
//		int totalValue = 0;
//		int totalCount = 0;
//		int avgValue = 0;
//
//		for(Map<String, Object> returnItem : returnItems){
//			for(Map.Entry<String, Object> value : returnItem.entrySet()){
//				if (value.getKey().startsWith("surveyItemCd")){
//					totalCount++;
//					totalValue += Integer.parseInt(value.getValue().toString());
//				}
//			}
//
//			if (totalCount != 0 )
//				avgValue = totalValue / totalCount;
//
//			returnItem.put("avgPoint", avgValue );
//		}
//
//	}

//	public List<?> getWorkSatisfactionPersonStatisticsList(Map<?, ?> paramMap) throws Exception {
//		List<Map<String, Object>> headerList = (List<Map<String, Object>>)dao.getList("getWorkSatisfactionPersonStatisticsList", paramMap);
//		List<Map<String, Object>> resultList = (List<Map<String, Object>>) dao.getList("getWorkSatisfactionPersonStatisticsList", paramMap);
//
//		List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
//
//		for(Map<String, Object> resultItem : resultList){
//			Map<String, Object> returnItem = getSameReturnItem(returnList, resultItem);
//
//			for(Map<String, Object> headerItem: headerList){
//				String surveyItemCd    = String.format("surveyItemCd%s", headerItem.get("surveyItemCd").toString());
//				int surveyItemValue = 0;
//				if ( returnItem.get(surveyItemCd) != null)
//					surveyItemValue = Integer.parseInt(returnItem.get("point").toString());
//
//				returnItem.put(surveyItemCd, surveyItemValue);
//			}
//		}
//
//		calculateAvg(returnList);
//
//		return returnList;
//	}

}
