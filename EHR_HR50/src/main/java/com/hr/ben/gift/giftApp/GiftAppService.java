package com.hr.ben.gift.giftApp;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
/**
 * 선물신청 Service
 * 
 * @author 이름
 *
 */
@Service("GiftAppService")  
public class GiftAppService{
	@Inject
	@Named("Dao")
	private Dao dao;
}