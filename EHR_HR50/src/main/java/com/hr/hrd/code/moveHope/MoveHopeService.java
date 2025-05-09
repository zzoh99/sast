package com.hr.hrd.code.moveHope;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("MoveHopeService")
public class MoveHopeService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getMoveHopeList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getMoveHopeList", paramMap);
	}

	public int saveMoveHope(Map<?, ?> convertMap) throws Exception {
	int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMoveHope", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMoveHope", convertMap);
		}

		return cnt;
	}

	public int deleteMoveHope(Map<?, ?> paramMap) throws Exception {
		return dao.delete("deleteMoveHope", paramMap);
	}

}
