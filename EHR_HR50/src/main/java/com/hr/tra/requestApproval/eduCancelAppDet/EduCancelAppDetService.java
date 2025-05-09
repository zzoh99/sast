package com.hr.tra.requestApproval.eduCancelAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 교육취소신청 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("EduCancelAppDetService")
public class EduCancelAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

}