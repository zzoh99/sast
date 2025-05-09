package com.hr.ben.scholarship.schStd;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 학자금기준관리 Service
 *
 * @author EW
 *
 */
@Service("SchStdService")
public class SchStdService{

	@Inject
	@Named("Dao")
	private Dao dao;
}
