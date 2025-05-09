package com.hr.cpn.payData.payCalculator;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("PayCalculatorService")
public class PayCalculatorService {

	@Inject
	@Named("Dao")
	private Dao dao;
	
	public Map<?, ?> getPayCalculatorMap(Map<?, ?> param) throws Exception {
		Log.Debug();
		return dao.getMap("getPayCalculatorByPayActionCd", param);
	}
	
	public List<?> getSearchTargetList(Map<?, ?> param) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPaySearchTargetList", param);
	}
	
	public Map<?, ?> getPaymentStaticsPeoples(Map<?, ?> param) throws Exception {
		return dao.getMap("getPaymentStaticsPeoples", param);
	}
	
	public List<?> getPaymentStatics(Map<?, ?> param) throws Exception {
		return (List<?>) dao.getList("getPaymentStatics", param);
	}
	
	public Map<?, ?> getPaymentThenPrev(Map<?, ?> param) throws Exception {
		return dao.getMap("getPaymentThenPrev", param);
	}
	
	public List<?> getPaymentTransferInfo(Map<?, ?> param) throws Exception {
		return (List<?>) dao.getList("getPaymentTransferInfo", param);
	}
	
	public Map<?, ?> getPayCalcPersonalInfo(Map<?, ?> param) throws Exception {
		return dao.getMap("getPayCalcPersonalInfo", param);
	}
	
	public List<?> getPayCalcWorkTime(Map<?, ?> param) throws Exception {
		return (List<?>) dao.getList("getPayCalcWorkTime", param);
	}
	
	public List<?> getPayCalcFormila(Map<?, ?> param) throws Exception {
		return (List<?>) dao.getList("getPayCalcFormila", param);
	}
	
	//선택 급여목록 특정 대상자 삽입
	@SuppressWarnings("unchecked")
	public int savePayTarget(Map<String, Object> param,  List<Map<String, Object>> rows) {
		int count = 0;

		if (rows != null && !rows.isEmpty()) {
			for (Map<String, Object> row: rows) {
				Map<String, Object> p = new HashMap<>();
				p.putAll(row);
				p.putAll(param);
				p.put("sabun", row.get("tSabun"));
				Map<String, Object> map = (Map<String, Object>) dao.excute("PayCalcCreP_CPN_CAL_EMP_INS", p);
				if (map.get("sqlerrm") != null) {
					return -1;
				} else {
					count++;
				}
			}
		}
		
		return count;
	}
	
	
}
