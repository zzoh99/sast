package com.hr.tim.workApp.extenWorkApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연장근무추가승인 Service
 *
 * @author EW
 *
 */
@Service("ExtenWorkAprService")
public class ExtenWorkAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

}
