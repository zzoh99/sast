package com.hr.tra.requestApproval.eduApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 교육승인 Service
 *
 * @author JSG
 *
 */
@Service("EduAprService")
public class EduAprService{

	@Inject
	@Named("Dao")
	private Dao dao;
}