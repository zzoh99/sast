package com.hr.tra.lectureFee.lectureFeeApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 사내강사료승인 Service
 *
 * @author JSG
 *
 */
@Service("LectureFeeAprService")
public class LectureFeeAprService{

	@Inject
	@Named("Dao")
	private Dao dao;
}