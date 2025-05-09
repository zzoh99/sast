package com.hr.hrd.statistics.transferState;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("TransferStateService")
public class TransferStateService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getTransferStateList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getTransferStateList", paramMap);
	}

}
