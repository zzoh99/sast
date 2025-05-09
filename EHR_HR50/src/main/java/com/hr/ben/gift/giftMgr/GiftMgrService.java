package com.hr.ben.gift.giftMgr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
/**
 * 선물신청관리 Service
 * 
 * @author 이름
 *
 */
@Service("GiftMgrService")  
public class GiftMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
}