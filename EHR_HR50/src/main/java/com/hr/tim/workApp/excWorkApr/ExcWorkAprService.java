package com.hr.tim.workApp.excWorkApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 당직승인 Service
 *
 * @author EW
 *
 */
@Service("ExcWorkAprService")
public class ExcWorkAprService{

	@Inject
	@Named("Dao")
	private Dao dao;
}
