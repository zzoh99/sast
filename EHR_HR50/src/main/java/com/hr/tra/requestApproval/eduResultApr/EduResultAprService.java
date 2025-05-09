package com.hr.tra.requestApproval.eduResultApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.dao.ProDao;
import com.hr.common.logger.Log;

/**
 * eduResultApr Service
 *
 * @author EW
 *
 */
@Service("EduResultAprService")
public class EduResultAprService{

	@Inject
	@Named("Dao")
	private Dao dao;
}
