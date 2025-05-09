package com.hr.ben.loan.loanPersonalInterest;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("LoanPersonalInterestService")
public class LoanPersonalInterestService {
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 대출 개인별 이율 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLoanPersonalInterest(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLoanPersonalInterest", paramMap);
	}

	/**
	 * 대출 개인별 이율 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveLoanPersonalInterest(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)paramMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteLoanPersonalInterest", paramMap);
		}
		if( ((List<?>)paramMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveLoanPersonalInterest", paramMap);
		}
		Log.Debug();
		return cnt;
	}
}
