package com.hr.tim.workApp.excWorkAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 당직신청 Service
 *
 * @author
 *
 */
@Service("ExcWorkAppDetService")
public class ExcWorkAppDetService{
	@Inject
	@Named("Dao")
	private Dao dao;

}