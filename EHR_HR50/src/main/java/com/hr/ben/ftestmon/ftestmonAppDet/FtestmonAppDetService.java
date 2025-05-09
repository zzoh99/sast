package com.hr.ben.ftestmon.ftestmonAppDet;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

/**
 * 어학시험응시료신청 세부내역 Service
 *
 * @author
 *
 */
@Service("FtestmonAppDetService")
public class FtestmonAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
}