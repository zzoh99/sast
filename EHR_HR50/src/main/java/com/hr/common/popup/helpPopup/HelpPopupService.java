package com.hr.common.popup.helpPopup;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("HelpPopupService")
public class HelpPopupService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  개인신상 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getHelpPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getHelpPopupMap", paramMap);
	}
	
	/**
	 * 연관 메뉴 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getHelpPopupRelateMenuList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHelpPopupRelateMenuList", paramMap);
	}
}