package com.hr.hrd.incoming.incomingReg;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.util.StringUtil;

@Service("IncomingRegService")
public class IncomingRegService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getIncomingRegList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getIncomingRegList", paramMap);
	}

	public int saveIncomingReg(Map<?, ?> paramMap) throws Exception {
		int imconCnt = Integer.parseInt(StringUtil.nvl((String)paramMap.get("imconCnt"),"-1"));
		
		String[] incomIdArr     = paramMap.get("incomIdArr").toString().split(",", imconCnt);
		String[] extIncomYnArr  = paramMap.get("extIncomYnArr").toString().split(",", imconCnt);
		String[] incomTimeArr   = paramMap.get("incomTimeArr").toString().split(",", imconCnt);
		String[] incomPathArr   = paramMap.get("incomPathArr").toString().split(",", imconCnt);
		String[] incomOutArr    = paramMap.get("incomOutArr").toString().split(",", imconCnt);
		String[] incomImpactArr = paramMap.get("incomImpactArr").toString().split(",", imconCnt);
		String[] incomRsnArr    = paramMap.get("incomRsnArr").toString().split(",", imconCnt);
		String[] incomProsArr   = paramMap.get("incomProsArr").toString().split(",", imconCnt);
		String[] incomConsArr  = paramMap.get("incomConsArr").toString().split(",", imconCnt);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchSabun", paramMap.get("searchSabun"));
		
		int cnt = 0;
		cnt += dao.delete("deleteIncomingReg", map);
		
		for(int i=0; i<incomIdArr.length; i++) {
			map.put("incomSeq", i+1);
			map.put("incomId",     incomIdArr[i]);
			map.put("extIncomYn",  extIncomYnArr[i]);
			map.put("incomTime",   incomTimeArr[i]);
			map.put("incomPath",   incomPathArr[i]);
			map.put("incomOut",    incomOutArr[i]);
			map.put("incomImpact", incomImpactArr[i]);
			map.put("incomRsn",    incomRsnArr[i]);
			map.put("incomPros",   incomProsArr[i]);
			map.put("incomCons",   incomConsArr[i]);
			
			if( (!StringUtil.isBlank(incomIdArr[i]) && "N".equals(extIncomYnArr[i]))
				|| ("Y".equals(extIncomYnArr[i]))) {
				cnt += dao.update("saveIncomingReg", map);	
			}
		}
		
		return cnt;
	}

}
