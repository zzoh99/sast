package com.hr.tim.code.payWayMgr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

/**
 * 근무지급방법설정(탭메인) Service
 *
 * @author bckim
 *
 */
@Service("PayWayMgrService")
public class PayWayMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
}