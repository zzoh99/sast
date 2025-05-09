package com.hr.tim.workApp.holAlterAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * holAlterAppDet Service
 *
 * @author EW
 *
 */
@Service("HolAlterAppDetService")
public class HolAlterAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

}
