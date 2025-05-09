package com.hr.hrm.other.empPictureChangeMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("EmpPictureChangeMgrService")
public class EmpPictureChangeMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getEmpPictureChangeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getEmpPictureChangeMgrList", paramMap);
	}
	public List<?> getEmpInfoChangeMailMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getEmpInfoChangeMailMgrList", paramMap);
	}
	
	
	public Map<?,?> getEmpPictureChangeSeq(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEmpPictureChangeSeq", paramMap);
	}
	
	public int insertEmpPictureChangeReq(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;		
		cnt += dao.update("insertEmpPictureChangeReq", paramMap);		
		return cnt;
	}
	
	public int insertEmpPictureChangeHist(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;		
		cnt += dao.update("insertEmpPictureChangeHist", paramMap);		
		return cnt;
	}
	
	public int deleteEmpPictureChangeMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;		
		cnt += dao.update("deleteEmpPictureChangeMgr", paramMap);		
		return cnt;
	}
	public int deleteEmpPictureChangeEmp(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;		
		cnt += dao.update("deleteEmpPictureChangeEmp", paramMap);		
		return cnt;
	}
	
	public int updateEmpPicture(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;		
		cnt += dao.update("updateEmpPicture", paramMap);		
		return cnt;
	}
	
	
	public Map<?,?> getEmpPictureChangeMgrBeforeTHRM911(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEmpPictureChangeMgrBeforeTHRM911", paramMap);
	}
	
	public Map<?,?> getEmpPictureChangeMgrDupChk(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEmpPictureChangeMgrDupChk", paramMap);
	}
}
