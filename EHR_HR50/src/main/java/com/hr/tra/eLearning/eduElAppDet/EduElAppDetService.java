package com.hr.tra.eLearning.eduElAppDet;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

/**
 * 이러닝신청 세부내역 Service
 *
 * @author
 *
 */
@Service("EduElAppDetService")
public class EduElAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
}