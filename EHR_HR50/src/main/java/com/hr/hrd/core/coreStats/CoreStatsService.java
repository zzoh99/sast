package com.hr.hrd.core.coreStats;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("CoreStatsService")
public class CoreStatsService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	public Map<?,?> getCoreStatsCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>)dao.getMap("getCoreStatsCnt", paramMap);
	}
	
	public List<?> getCoreStatsList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getCoreStatsList1", paramMap);
	}
	
	public List<?> getCoreStatsList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getCoreStatsList2", paramMap);
	}

}