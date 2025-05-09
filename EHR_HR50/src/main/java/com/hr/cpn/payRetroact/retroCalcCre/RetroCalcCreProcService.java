package com.hr.cpn.payRetroact.retroCalcCre;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.dao.ProDao;
import com.hr.common.logger.Log;

/**
 * 소급계산 Service
 *
 * @author JM
 *
 */
@Async
@Service("RetroCalcCreProcService")
public class RetroCalcCreProcService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 소급계산
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_RE_PAY_MAIN(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("RetroCalcCreProcP_CPN_RE_PAY_MAIN", paramMap);
	}
}