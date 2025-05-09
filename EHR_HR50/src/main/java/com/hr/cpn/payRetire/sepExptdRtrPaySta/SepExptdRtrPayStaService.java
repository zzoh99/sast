package com.hr.cpn.payRetire.sepExptdRtrPaySta;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 예상퇴직금 Service
 *
 * @author JM
 *
 */
@Service("SepExptdRtrPayStaService")
public class SepExptdRtrPayStaService {
	@Inject
	@Named("Dao")
	private Dao dao;
}