package com.hr.ben.ftestmon.ftestmonApr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 어학시험응시료승인 Service
 * 
 * @author 이름
 *
 */
@Service("FtestmonAprService")  
public class FtestmonAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
}