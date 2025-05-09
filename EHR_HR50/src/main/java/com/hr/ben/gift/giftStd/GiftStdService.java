package com.hr.ben.gift.giftStd;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 선물기준관리 Service
 * 
 * @author 이름
 *
 */
@Service("GiftStdService")  
public class GiftStdService{
	@Inject
	@Named("Dao")
	private Dao dao;

	public int saveGiftStdDtl(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteGiftStdDtl", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveGiftStdDtl", convertMap);
		}

		return cnt;
	}
}