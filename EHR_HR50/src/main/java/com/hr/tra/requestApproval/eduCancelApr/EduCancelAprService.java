package com.hr.tra.requestApproval.eduCancelApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 교육취소승인 Service
 *
 * @author JSG
 *
 */
@Service("EduCancelAprService")
public class EduCancelAprService{
	@Inject
	@Named("Dao")
	private Dao dao;

}