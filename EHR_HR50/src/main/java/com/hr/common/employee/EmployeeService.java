package com.hr.common.employee;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("EmployeeService")
public class EmployeeService{

	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> employeeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("employeeList", paramMap);
	}
	
	public List<?> commonEmployeeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("commonEmployeeList", paramMap);
	}

	/**
	 *  MAP 조회 한건의 결과를 Map 형태로 반환
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getEmployeeInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEmployeeInfoMap", paramMap);
	}
	
	/**
	 *  MAP 조회 한건의 결과를 Map 형태로 반환
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> baseEmployeeDetail(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("baseEmployeeDetail", paramMap);
	}

	public List<?> getEmployeeHeaderColInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug("EmployeeService.getEmployeeHeaderColInfo invoke");
		return (List<?>)dao.getList("employeeHeaderColInfo", paramMap);
	}
	
	public List<?> getMainEmployeeSearch(Map<?, ?> param) throws Exception {
		return (List<?>) dao.getList("getMainEmployeeSearch", param);
	}

	public List<?> getEmployeeHiddenInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug("EmployeeService.getEmployeeHiddenInfo invoke");
		return (List<?>)dao.getList("employeeHiddenInfo", paramMap);
	}

	public Map<?, ?> getEmployeeHeaderColDataMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEmployeeHeaderColDataMap", paramMap);
	}

	public Map<?, ?> getEmployeeHeaderDataMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEmployeeHeaderDataMap", paramMap);
	}

	public List<?> getEmployeeAllList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("employeeAllList", paramMap);
	}
}