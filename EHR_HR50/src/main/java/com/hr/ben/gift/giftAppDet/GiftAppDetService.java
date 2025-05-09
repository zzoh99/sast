package com.hr.ben.gift.giftAppDet;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
/**
 * 선물신청상세 Service
 * 
 * @author 이름
 *
 */
@Service("GiftAppDetService")  
public class GiftAppDetService{
	@Inject
	@Named("Dao")
	private Dao dao;
}