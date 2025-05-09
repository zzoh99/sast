package com.hr.hrd.code.cdpManage;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("CDPManageService")
public class CDPManageService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getCDPManageList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getCDPManageList", paramMap);
	}

	public int saveCDPManageList(Map<?, ?> convertMap) throws Exception {
	int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCDPManageList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCDPManageList", convertMap);
		}

		return cnt;
	}


}
