package com.hr.common.popup.payBankPopup;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 은행관리 Service
 * 
 * @author 이름
 *
 */
@Service("PayBankPopupService")  
public class PayBankPopupService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 은행관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayBankPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayBankPopupList", paramMap);
	}	
	/**
	 * 은행관리 개인별급여세부내역(관리자)용 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayDayAdminPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayDayAdminPopupList", paramMap);
	}
	/**
	 * 은행관리 개인별급여세부내역용 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayDayUserPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayDayUserPopupList", paramMap);
	}
	/**
	 *  은행관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPayBankPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPayBankPopupMap", paramMap);
	}
	/**
	 * 은행관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayBankPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayBankPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayBankPopup", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}