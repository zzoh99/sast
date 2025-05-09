package com.hr.tra.lectureRst.lectureRstApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 사내교육결과보고승인 Service
 *
 * @author JSG
 *
 */
@Service("LectureRstAprService")
public class LectureRstAprService{

	@Inject
	@Named("Dao")
	private Dao dao;
}