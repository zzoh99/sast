package com.hr.hri.commonApproval.comApr;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 공통승인 Service
 * 
 * @author 이름
 *
 */
@Service("ComAprService")  
public class ComAprService{
	@Inject
	@Named("Dao")
	private Dao dao;


	public List<?> getSeqList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		
		List<Map<String, Object>> seqList = new ArrayList<Map<String, Object>>();
		seqList = (List<Map<String, Object>>)dao.getList("getComAprSeqList", paramMap);
		
		return (List<?>) seqList;
	}
}