package com.hr.cpn.personalPay.perAccChgApr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 은행계좌변경승인 Service
 *
 * @author 이름
 *
 */
@Service("PerAccChgAprService")
public class PerAccChgAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 은행계좌변경승인 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerAccChgAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerAccChgAprList", paramMap);
	}
	/**
	 *  은행계좌변경승인 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPerAccChgAprMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPerAccChgAprMap", paramMap);
	}

	/**
	 * 은행계좌변경승인 수정 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updatePerAccChgApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;

		if( ((List<?>)convertMap.get("updateRows")).size() > 0){

		    List<Map> updateList = (List<Map>)convertMap.get("updateRows");

		    for(Map<String,Object> mp : updateList) {
		        Map<String,Object> executeMap = new HashMap<String,Object>();

                executeMap.put("ssnEnterCd",   convertMap.get("ssnEnterCd"));
                executeMap.put("ssnSabun",     convertMap.get("ssnSabun"));
                executeMap.put("sabun",        mp.get("sabun"));
                executeMap.put("accountType",  mp.get("accountType"));
                executeMap.put("bankCd",       mp.get("bankCd"));
                executeMap.put("accountNo",    mp.get("accountNo"));
                executeMap.put("accName",      mp.get("accName"));
                executeMap.put("reqSeq",       mp.get("reqSeq"));
                executeMap.put("status",       mp.get("dmyStatus"));
                executeMap.put("bigo",         mp.get("bigo"));
                executeMap.put("reqDate",      mp.get("reqDate"));


                if("Y".equals(mp.get("dmyStatus"))){
                	// 요청된 데이터  TCPN180에 반영
                	cnt += dao.update("savePerAccChgApr1", executeMap);
                	// TCPN180 기 날짜정보 수정
                	cnt += dao.update("updatePerAccChgApr1", executeMap);


                    // 요청된 데이터  TCPN183 처리상태 변경
                    cnt += dao.update("updatePerAccChgApr2", executeMap);
                }else{
                    cnt += dao.update("updatePerAccChgApr2", executeMap);
                }


		    }

		}

		return cnt;//dao.update("updatePerAccChgApr", paramMap);
	}

}